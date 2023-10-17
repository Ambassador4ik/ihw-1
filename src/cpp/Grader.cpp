#include <cerrno>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <fstream>
#include <iostream>
#include <unistd.h>

#include "lib/json.hpp"
using json = nlohmann::json;

const char* command = "java -jar rars.jar sm nc p assembly/main.asm";

int* createProcess() {
    int input_fds[2];
    int output_fds[2];
    pid_t pid;

    // Create pipes
    pipe(input_fds);
    pipe(output_fds);

    pid = fork();
    if (pid < 0) {
        exit(EXIT_FAILURE);
    }
    else if (pid == 0) {  // Child process
        close(input_fds[1]);  // Close the write end of input pipe in child

        dup2(input_fds[0], STDIN_FILENO);  // Redirect standard input to input pipe
        dup2(output_fds[1], STDOUT_FILENO);  // Redirect standard output to output pipe

        close(input_fds[0]);  // Close the read end of input pipe in child
        close(output_fds[0]);  // Close the read end of output pipe in child

        system(command);
        exit(0);
    }
    else {  // Parent process
        close(input_fds[0]);  // Close the read end of input pipe in parent
        close(output_fds[1]);  // Close the write end of output pipe in parent
    }

    // Array to hold read and write pipe file descriptors
    // 0th index will have write-end of input pipe and 1st index will have read-end of output pipe
    static int pipe_fds[2];
    pipe_fds[0] = input_fds[1];
    pipe_fds[1] = output_fds[0];

    return pipe_fds;
}

struct Test {
    int count;
    std::string result;
    std::vector<int> input;

    Test() {
        count = 0;
        result = "";
        input = std::vector<int>();
    }
};

std::vector<Test> readTests() {
    std::ifstream i("input.json");
    json j;
    i >> j;

    std::vector<Test> tests;
    for (auto& element : j["tests"]) {
        Test test;
        test.count = element["count"];
        test.result = element["result"];
        for (auto &item : element["array"]) {
            test.input.push_back(item);
        }
        tests.push_back(test);
    }

    return tests;
}

bool equals(std::string& str1, const char* str2) {
    if (str1.length() != strlen(str2)) {
        return false;
    }
    for (int i = 0; i < str1.length(); ++i) {
        if (str1[i] != str2[i]) {
            return false;
        }
    }
    return true;
}

void strip(char* str) {
    // Remove leading whitespace
    char* first_non_whitespace = str;
    while (*first_non_whitespace == ' ' || *first_non_whitespace == '\t' ||
           *first_non_whitespace == '\r' || *first_non_whitespace == '\n') {
        ++first_non_whitespace;
    }

    // Remove trailing whitespace
    char* last_non_whitespace = str + strlen(str) - 1;
    while (last_non_whitespace >= first_non_whitespace && (*last_non_whitespace == ' ' ||
                                                           *last_non_whitespace == '\t' ||
                                                           *last_non_whitespace == '\r' ||
                                                           *last_non_whitespace == '\n'))
    {
        --last_non_whitespace;
    }

    // Move the non-whitespace characters to the beginning of the string
    memmove(str, first_non_whitespace, last_non_whitespace - first_non_whitespace + 1);

    // Null-terminate the string
    str[last_non_whitespace - first_non_whitespace + 1] = '\0';
}

void runTest(Test& test){
    int* pipe_fds = createProcess();
    FILE* readPipe = fdopen(pipe_fds[1], "r");
    FILE* writePipe = fdopen(pipe_fds[0], "w");
    char buffer[512];

    if (readPipe == nullptr || writePipe == nullptr) {
        std::cerr << "Failed to start the process!" << std::endl;
    }

    // Send the count
    std::string input = std::to_string(test.count) + "\n";
    fwrite(input.c_str(), sizeof(char), input.length(), writePipe);
    fflush(writePipe);
    fgets(buffer, sizeof(buffer), readPipe);
    fflush(stdout);

    // Send the array
    for (auto& item : test.input) {
        input = std::to_string(item) + "\n";
        fwrite(input.c_str(), sizeof(char), input.length(), writePipe);
        fflush(writePipe);
    }
    fgets(buffer, sizeof(buffer), readPipe);
    fflush(stdout);

    // Get the result
    fgets(buffer, sizeof(buffer), readPipe);
    fflush(stdout);
    strip(buffer);
    std::cout << buffer << " | ";
    if (equals(test.result, buffer)) {
        std::cout << "\033[1;32mOK\033[0m" << std::endl;
    } else {
        std::cout << "\033[1;31mFAIL\033[0m" << std::endl;
    }
}

int main() {
    std::vector<Test> tests = readTests();

    for (auto &test: tests) {
        runTest(test);
    }

    return 0;
}
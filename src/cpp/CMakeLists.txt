cmake_minimum_required(VERSION 3.10)
set(CMAKE_CXX_STANDARD 23)

project(RARS_AutoGrader)

add_executable(RARS-AutoGrader Grader.cpp lib/json.hpp)
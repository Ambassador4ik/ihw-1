rm -rf ./cpp/build
cmake -S ./cpp/ -B ./cpp/build
cmake --build ./cpp/build
./cpp/build/RARS-AutoGrader
.PHONY: run test build clean

run:
	@java -jar ./src/rars.jar sm nc p ./src/assembly/main.asm

test:
	make build
	@cd src && ./cpp/build/RARS-AutoGrader

test-docker:
	docker-compose build rars-auto && docker-compose run rars-auto

run-docker:
	docker-compose build rars-interactive && docker-compose run rars-interactive

build:
	cmake -S ./src/cpp/ -B ./src/cpp/build
	cmake --build ./src/cpp/build

clean:
	rm -rf ./src/cpp/build/*

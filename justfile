default:
    @just --list

# Build the Devcontainer.
build:
    @docker build -t use-the-fork/snow-blower-devcontainer:latest -f src/Dockerfile src

test:
    @docker build -t snow-blower-devcontainer-test \
        --build-arg USERNAME=user \
        --build-arg USER_UID=1001 \
        --build-arg USER_GID=1001 \
        test -f test/Dockerfile

    @docker run -ti -e PRELOAD_EXTENSIONS="test" nix-devcontainer-test \
        bash -ic '$${PROMPT_COMMAND}; . /workspace/test.sh; pkill -TERM ext-preloader'
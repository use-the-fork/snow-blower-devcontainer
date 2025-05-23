default:
    @just --list

# Start AIder AI assitant
ai:
    @aider --model sonnet --watch-files --no-suggest-shell-commands --no-detect-urls --git-commit-verify --read "README.MD"

# Build the Devcontainer.
build:
    @docker build -t use-the-fork/snow-blower-devcontainer:latest -f src/Dockerfile src

# Build the Devcontainer.
build-no-cache:
    @docker build --no-cache -t use-the-fork/snow-blower-devcontainer:latest -f src/Dockerfile src

test:
    @docker build -t snow-blower-devcontainer-test \
        --build-arg USERNAME=user \
        --build-arg USER_UID=1001 \
        --build-arg USER_GID=1001 \
        test -f test/Dockerfile

    @docker run -ti -e PRELOAD_EXTENSIONS="test" nix-devcontainer-test \
        bash -ic '$${PROMPT_COMMAND}; . /workspace/test.sh; pkill -TERM ext-preloader'

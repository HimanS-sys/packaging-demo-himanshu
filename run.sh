#!/bin/bash

set -e

THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)"

function try-load-dotenv {
    if [ ! -f "$THIS_DIR/.env" ]; then
        echo "no .env file found"
        return 1
    fi
    while read -r line; do
        export "$line"
    done < <(grep -v '^#' "$THIS_DIR/.env" | grep -v '^$')
}
function install {
    python -m pip install --upgrade pip
    python -m pip install --editable "$THIS_DIR/[dev]"
}

function build {
    python -m build --sdist --wheel "$THIS_DIR/"
}

function publish:test {
    try-load-dotenv || true
    python -m twine upload dist/* \
        --repository testpypi \
        --username=__token__ \
        --password="$TEST_PYPI_TOKEN"
}

function publish:prod {
    try-load-dotenv || true
    python -m twine upload dist/* \
    --repository pypi \
    --username=__token__ \
    --password="$PROD_PYPI_TOKEN"
}
function clean {
    rm -rf dist build
    find . \
        -type d \
        \( \
            -name "*cache*" \
            -o -name "*.dist-info" \
            -o -name "*.egg-info" \
        \) \
        -not -path "./venv/*" \
        -exec rm -r {} +
}

function release:test {
    clean
    build
    publish:test
}

function release:prod {
    release:test
    publish:prod
}

function lint {
    pre-commit run --all-files
}
function lint:ci {
    SKIP=no-comit-to-branch pre-commit run --all-files
}
function start {
    echo "start task not implemented"
}

function test {
    echo "test task not implemented"
}

function default {
    # Default task to execute
    start
}

function help {
    echo "$0 <task> <args>"
    echo "Tasks:"
    compgen -A function | cat -n
}

TIMEFORMAT="Task completed in %3lR"
time ${@:-help}

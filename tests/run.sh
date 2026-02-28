#!/usr/bin/env sh
set -eu

REPO_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
cd "$REPO_DIR"

run_with() {
  cmd="$1"
  if command -v "$cmd" >/dev/null 2>&1; then
    "$cmd" -Nu NONE -n -es -S tests/test_omnifunc.vim
    "$cmd" -Nu NONE -n -es -S tests/test_syntax.vim
    return 0
  fi
  return 1
}

if run_with nvim; then
  echo "tests: nvim ok"
  exit 0
fi

if run_with vim; then
  echo "tests: vim ok"
  exit 0
fi

echo "Neither nvim nor vim found in PATH" >&2
exit 1

#!/usr/bin/env sh
set -eu

REPO_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
cd "$REPO_DIR"

TEST_SCRIPTS="
tests/test_omnifunc.vim
tests/test_syntax.vim
tests/test_completion_values.vim
tests/test_compiler.vim
tests/test_features.vim
tests/test_filetype_paths.vim
"

run_test() {
  editor="$1"
  script="$2"
  if "$editor" -Nu NONE -n -i NONE -es -S "$script"; then
    echo "ok: $editor $script"
    return 0
  fi

  log_file="${TMPDIR:-/tmp}/vpcb-$(basename "$editor")-$(basename "$script").log"
  "$editor" -Nu NONE -n -i NONE -V1"$log_file" -es -S "$script" || true
  echo "fail: $editor $script" >&2
  echo "---- begin $log_file ----" >&2
  sed -n '1,220p' "$log_file" >&2 || true
  echo "---- end $log_file ----" >&2
  return 1
}

run_with() {
  cmd="$1"
  if command -v "$cmd" >/dev/null 2>&1; then
    for script in $TEST_SCRIPTS; do
      run_test "$cmd" "$script"
    done
    return 0
  fi
  return 1
}

if [ "${1:-}" = "vim" ] || [ "${1:-}" = "nvim" ]; then
  run_with "$1"
  echo "tests: $1 ok"
  exit 0
fi

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

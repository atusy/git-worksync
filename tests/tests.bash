#!/bin/bash
set -e
DO="${1:-test}"
WD="$( cd "$( dirname "$0" )" && pwd )"
TESTED=0
FAILED=0
function try() {
  bash "$WD/template.bash" "$@"
}
function expect() {
  command cat "$WD/expected_${1}.txt" 
}

function test() {
  local NAME="$1"
  shift 1
  if [[ ! "$( try "$@" )" == "$( expect $NAME )" ]]
  then
    echo "failed: $NAME"
    FAILED=$(( $FAILED + 1 ))
  fi
  TESTED=$(( $TESTED + 1))
}

function update() {
  local NAME="$1"
  shift 1
  try "$@" > "expected_${NAME}.txt"
}

$DO default
$DO all_ignored_as_hardlink --ignored=hard-link
$DO ignored-file_as_hardlink -h="ignored-file"
$DO only_ignored-file_as_hardlink -i=no -u=no -h="ignored-file"
YML=$( mktemp )
cat <<EOF > $YML && $DO "with_yml_only_ignored-file_as_hardlink" --config=$YML
ignored: "no"
untracked: "no"
hard-link:
  - "ignored-file"
EOF

echo "Failed $FAILED / $TESTED"
if [[ FAILED -eq 0 ]]; then
  exit 0
else
  exit 1
fi


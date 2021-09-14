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
  TRY="$( try "$@" )"
  EXPECT="$( expect $NAME )"
  if [[ ! "$TRY" == "$EXPECT" ]]
  then
    echo "=== failed: $NAME ===" 1>&2
    echo '$ diff <( echo "$EXPECT" ) <( echo "$TRY" )' 1>&2
    diff <( echo "$EXPECT" ) <( echo "$TRY" ) 1>&2 || true
    FAILED=$(( $FAILED + 1 ))
  fi
  TESTED=$(( $TESTED + 1))
}

function update() {
  local NAME="$1"
  shift 1
  try "$@" > "$WD/expected_${NAME}.txt"
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

echo "Failed $FAILED / $TESTED" 1>&2
if [[ FAILED -eq 0 ]]; then
  exit 0
else
  exit 1
fi


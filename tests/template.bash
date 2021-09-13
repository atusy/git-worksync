#!/bin/bash
set -e
MAIN="$( mktemp -d )"
WORKSYNC="$(cd "$( dirname $0 )/.." && pwd )/git-worksync"

echo "$(
cd $MAIN
git init --initial-branch=main --quiet

mkdir -p \
  tracked-dir/ignored-dir \
  tracked-dir/untracked-dir \
  untracked-dir/foo-dir \
  ignored-dir/foo-dir/bar-dir

touch tracked-dir/foo-file \
      tracked-dir/untracked-file \
      tracked-dir/ignored-dir/foo-file \
      tracked-dir/ignored-file \
      untracked-dir/foo-file \
      untracked-dir/foo-dir/bar-file \
      untracked-file \
      ignored-dir/foo-file \
      ignored-dir/foo-dir/bar-file \
      ignored-file 

echo "ignored*" > ".gitignore"
git add .gitignore tracked-dir
git commit -m 'initial commit' --quiet

git branch "test" --quiet
$WORKSYNC test "$@" --quiet 1> /dev/null
cd test
find \
  -P -type f,l \
  -not -path "./.git/*" \
  -not -path "./.git" \
  -not -path "." \
  -exec ls -F {} +
)"


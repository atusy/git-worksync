# git-worksync

Extend `git worktree add` by syncing untracked and ignored resouces.

## Install

1. Install dependencies: [Git](https://git-scm.com/) and optionally [mikefarah/yq](https://github.com/mikefarah/yq). 
1. Download [git-worksync](git-worksync) to one of your path (e.g., `~/.local/bin`)
1. Let the file be executable

For example,

``` bash
wget -O "$HOME/.local/bin/git-worksync" https://raw.githubusercontent.com/atusy/git-worksync/main/git-worksync
chmod +x "$HOME/.local/bin/git-worksync"
```

## Getting started


`git worksync` extends `git worktree add`, and remains compatibility at the same time.

By default, `git worksync` creates hard links for the untracked and symbolic links for the ignored.
This design has chosen for the following reasons.

- Hard links are suitable for `git add <untracked paths>`
- Symbolic links are suitable for synchronizing ignored directories (e.g., .venv/, data/, ...) after adding the new worktree.

The behavior can be tweaked by command line options or by a YAML file (require [mikefarah/yq](https://github.com/mikefarah/yq)).
The deafult path for the YAML file is `.worksync.yml` at the root of repository.
However, it can also be changed by the `WORKSYNC_CONFIG` evironmental variable or by the `--config=<path>` option.

Details are available from `git worksync --help`.

### Examples

```bash
# Sync the untracked by hard links, and the ignroed by symbolic links
git worksync <path> [<commit-ish>]

# Sync the ignored by hard links
git worksync <path> [<commit-ish>] --untracked=symbolic-link

# Sync the ignored by hard links according to the YAML file
echo "ignored: hard-link" > "$(git rev-parse --show-toplevel)/.worksync.yml"
```


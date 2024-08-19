# git-recon

## Overview

This repository contains custom Git configuration files that define aliases useful for working with recent branches.

## Basic usage

### `git checkout-nth-local`

#### Purpose

Checks out the nth most recently updated local branch.

#### Usage

```shell
# Short form
git con <branch_number>
    
# Long form
git checkout-nth-local <branch_number>
```

---

### `git checkout-nth-remote`

#### Purpose

Checks out the nth most recently updated remote branch.
If the branch exists locally, it checks out the local version;
otherwise, it creates a local branch that tracks the remote branch.

#### Usage

```shell
git checkout-nth-remote <branch_number>
git con-r <branch_number>  # Alias
```

---

### `git default-branch`

#### Purpose

Displays the name of the default branch for the specified remote.

#### Usage

```shell
git default-branch <remote_name=origin>
```

---

### `git recent`

#### Purpose

Displays a list of the most recently updated local branches, including tracking information.

#### Usage

```shell
# Long form
git recent <count=10> [<for-each-ref-options>]
```

---

### `git recent-prompt`

#### Purpose

Displays recent branches and then prompts you to check one out by number.

#### Usage

```shell
# Short form
git reconl <count=10> [<for-each-ref-options>] 

# Long form  
git recent-prompt <count=10> [<for-each-ref-options>]
```

The command accepts any of the options accepted by `git for-each-ref`.

---

### `git recent-remote`

#### Purpose

Displays a list of the most recently updated remote branches, including tracking information.

#### Usage

```shell
# Short form
git recent-r <count=10> [<for-each-ref-options>]

# Long form
git recent-remote <count=10> [<for-each-ref-options>]
```

The command accepts any of the options accepted by `git for-each-ref`.

---

### `git recent-remote-prompt`

#### Purpose

Displays recent remote branches and then prompts you to check one out by number.

#### Usage

```shell
# Short form
git reconr <count=10> [<for-each-ref-options>] 

# Long form
git recent-remote-prompt <count=10> [<for-each-ref-options>]
```

The command accepts any of the options accepted by `git for-each-ref`.

## Installation

### Using Homebrew

```shell
brew tap williamthorsen/tap
brew install git-recon
git-recon --install
```

### Manual installation

1. Clone the repo or download the configuration file.
2. Add a directive to your `~/.gitconfig` file to include the configuration file:

```ini
[include]
    path = /path/to/git-recon.gitconfig
```

## Configuration files

- `git-recon.gitconfig`: Stable git configuration.

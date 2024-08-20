# Git Recon

Easy branch status and checkout on the command line

---

[![Latest Version](https://img.shields.io/badge/version-0.12.0-blue.svg)](https://github.com/williamthorsen/git-recon/releases)
[![License: ISC](https://img.shields.io/badge/License-ISC-yellow.svg)](https://opensource.org/licenses/ISC)

## 📖 Overview

Git Recon is a set of custom aliases useful for working with recent Git branches,
bundled into a single configuration file that can be referenced in your Git config.

Git Recon aliases provide a simple way to

- list recent branches with tracking information, and then
- check out a branch by number

## ⚡ Table of Contents

<!-- TOC -->
* [Git Recon](#git-recon)
  * [📖 Overview](#-overview)
  * [⚡ Table of Contents](#-table-of-contents)
  * [🏎️ Quick start](#-quick-start)
  * [🎯 Features](#-features)
    * [Core features](#core-features)
    * [More features](#more-features)
  * [💡 How to use](#-how-to-use)
    * [List](#list)
    * [Check out](#check-out)
    * [List and checkout](#list-and-checkout)
  * [🛠️ Installation](#-installation)
    * [Homebrew](#homebrew)
    * [Manual installation](#manual-installation)
  * [🛣️ Roadmap](#-roadmap)
  * [🤝 Contributing](#-contributing)
  * [🙏 Acknowledgments](#-acknowledgments)
  * [📝 License](#-license)
<!-- TOC -->

## 🏎️ Quick start

Here's how to get started quickly with Git Recon aliases.
For more detailed instructions, see the [How to use](#-how-to-use) and [Installation](#-installation) sections below.

```shell
# Install Git Recon using Homebrew
brew tap williamthorsen/tap
brew install git-recon

# Add the Git Recon aliases file to your ~/.gitconfig
git-recon --install

# Switch to any directory in a Git repository and view recent local and remote branches
git recon-local
git recon-remote
```

## 🎯 Features

### Core features

- Displays recent local or remote branches with at-a-glance tracking information
- Identifies current branch, default remote branch, and tracking branches
- Allows easy checkout of a branch by number
- Warns when there are changes in the working directory
- Easy installation with Homebrew

### More features

- Offers choice of explicit long-form or convenient short-form aliases
- Easy to combine with other Git configurations
- One-line configuration: Just include the aliases file in your `~/.gitconfig`
- Purely alias-based: No scripts, plugins, or additional dependencies
- Provides help text and legend for each command

## 💡 How to use

### List

Start by listing recent branches, which can be local or remote.

```shell
# List local branches
git recent-local [<count=10>]
# Short form
git recl

# List remote branches
git recent-remote [<count=10>]
# Short form
git recr
```

Sample output:

```bash
git recent-local
```

```
⦿ ▶︎  Sun 2024-Aug-18 00:09   Alex Smith       b1cfe51  feature/user-auth                origin   ↑3
  2   Tue 2023-Oct-03 11:58  Jamie Lee        18b3375  bugfix/pay-validation            
⦿ 3   Tue 2023-Oct-03 11:58  Jordan Kim       18b3375  develop                          origin   ↓2
⦿ 4   Sun 2023-Jan-29 22:43  Taylor Johnson   8170c0b  feature/shopping-cart            origin   ↑5↓1
⦿ 5   Sat 2023-Jan-28 14:50  Casey Brown      7f4eef6  chore/update-dependencies        origin   ✔
  6   Sat 2023-Jan-28 12:21  Morgan Clark     ee4a07a  feature/checkout-flow
  7   Sat 2023-Jan-28 12:21  Dakota Williams  0a067a1  feature/dashboard-stats
  8   Sat 2023-Jan-21 18:32  Avery Taylor     a0473ca  feature/order-tracking
⦿ 9   Wed 2023-Jan-18 20:47  Riley Davis      f9b520a  main                             origin   ✔
⦿ 10  Wed 2023-Jan-18 20:44  Drew Martinez    38f67dd  fix/coupon-discount-calculation  origin   -×-

Legend: ▶︎ current branch
        ⦿ tracking branch | ↑ commits ahead | ↓ commits behind | ✔ up to date | -×- upstream gone
```

### Check out

Then check out a branch by using the number displayed in the list.

```shell
# Check out a local branch
git checkout-nth-local <branch_number>
# Short form: c[heck o[ut] n[th] l[ocal]
git conl

# Check out a remote branch
git checkout-nth-remote <branch_number>
# Short form: c[heck o[ut] n[th] r[emote]
git conr
```

Example:

```shell
git checkout-nth-local 1
```

```
Switched to branch 'feature/user-auth'
Your branch is ahead of 'origin/feature/user-auth' by 3 commits.
```

### List and checkout

Alternatively, you can run a single command that effectively **combines** these commands by listing recent branches and then prompting for a branch number to check out,
which reduces the number of commands and keystrokes. (This is the most common use case.)

```shell
# List & check out local branches
git recon-local [<count=10>]
# Short form
git reconl

# List & check out remote branches
git recon-remote [<count=10>]
# Short form
git reconr
```

Example of remote list and checkout:

```shell
git recon-remote
```

```
⦿ ▶︎  Sun 2024-Aug-18 00:09   Alex Smith       b1cfe51  origin/feature/user-auth                local   ↑3
  2   Tue 2023-Oct-03 11:58  Jamie Lee        18b3375  origin/bugfix/pay-validation
⦿ 3   Tue 2023-Oct-03 11:58  Jordan Kim       18b3375  origin/develop                          local   ↓2
⦿ 4   Sun 2023-Jan-29 22:43  Taylor Johnson   8170c0b  origin/feature/shopping-cart            local   ↑5↓1
⦿ 5   Sat 2023-Jan-28 14:50  Casey Brown      7f4eef6  origin/chore/update-dependencies        local   ✔
  6   Sat 2023-Jan-28 12:21  Morgan Clark     ee4a07a  origin/feature/checkout-flow
  7   Sat 2023-Jan-28 12:21  Dakota Williams  0a067a1  origin/feature/dashboard-stats
  8   Sat 2023-Jan-21 18:32  Avery Taylor     a0473ca  origin/feature/order-tracking
⦿ 9   Wed 2023-Jan-18 20:47  Riley Davis      f9b520a  origin/main                             local   ✔
⦿ 10  Wed 2023-Jan-18 20:44  Drew Martinez    38f67dd  origin/fix/coupon-discount-calculation  local
Enter branch number to check out branch, [h] for help, or [Enter] to quit: 8
```

```
branch 'feature/order-tracking' set up to track 'origin/feature/order-tracking'.
Switched to a new branch 'feature/order-tracking'
```

## 🛠️ Installation

### Homebrew

```shell
brew tap williamthorsen/tap
brew install git-recon
git-recon --install
```

### Manual installation

1. Clone the repo or download the aliases file.
2. Add a directive to your `~/.gitconfig` file to include the aliases file:

   ```ini
   [include]
       path = /path/to/git-recon.gitconfig
   ```

## 🛣️ Roadmap

- [ ] Add detailed API reference
- [ ] Add uninstall and validate functions to the `git-recon` utility
- [ ] Add documentation and templates for contributors
- [ ] Adopt a framework appropriate for unit testing of Git commands
- [ ] Improve tooling: automated versioning, changelog generation, release management
- [ ] Add automated testing against different versions of Git

## 🤝 Contributing

Contributions to Git Recon are welcomed! To get started, please read our [contribution guidelines](CONTRIBUTING.md).

## 🙏 Acknowledgments

- [Git](https://git-scm.com/) - The tool that inspired this project.
- [Homebrew](https://brew.sh/) - For making package management so easy.

## 📝 License

This project is licensed under the ISC License. See the [LICENSE](LICENSE) file for details.

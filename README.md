# GitRecon

[![Latest Version](https://img.shields.io/badge/version-0.9.0-blue.svg)](https://github.com/williamthorsen/git-recon/releases)
[![License: ISC](https://img.shields.io/badge/License-ISC-yellow.svg)](https://opensource.org/licenses/ISC)

## 📖 Overview

GitRecon is a set of custom aliases useful for working with recent Git branches,
bundled into a single configuration file that can be referenced in your Git config.

GitRecon provides a simple way to

- list recent branches with tracking information
- check out a branch by number
- automatically set up tracking branches

## ⚡ Table of Contents

<!-- TOC -->
* [GitRecon](#gitrecon)
  * [📖 Overview](#-overview)
  * [⚡ Table of Contents](#-table-of-contents)
  * [🎯 Features](#-features)
    * [Core features](#core-features)
    * [More features](#more-features)
  * [💡 How to use](#-how-to-use)
    * [List](#list)
    * [Check out](#check-out)
    * [List and prompt for checkout](#list-and-prompt-for-checkout)
  * [🛠️ Installation](#-installation)
    * [Homebrew](#homebrew)
    * [Manual installation](#manual-installation)
  * [🛣️ Roadmap](#-roadmap)
  * [🤝 Contributing](#-contributing)
  * [🙏 Acknowledgments](#-acknowledgments)
  * [📝 License](#-license)
<!-- TOC -->

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
- Extensible and customizable: List commands accept all options of `git for-each-ref`
- One-line configuration: Just include the configuration file in your `~/.gitconfig`
- Purely alias-based: No scripts, plugins, or additional dependencies
- Provides help text and legend for each command

## 💡 How to use

### List

Start by listing recent branches, which can be local or remote.

```shell
# Local branches
git recent-local <count=10> [<for-each-ref-options>]
# Short form
git recl

# Remote branches
git recent-remote <count=10> [<for-each-ref-options>]
# Short form
git recr
```

Sample output:

```bash
git recl # recent-local
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
# Local branch
git checkout-nth-local <branch_number>
# Short form
git conl

  
# Remote branch
git checkout-nth-remote <branch_number>
# Short form
git conr
```

Example:

```shell
git conl 1
```

```
Switched to branch 'feature/user-auth'
Your branch is ahead of 'origin/feature/user-auth' by 3 commits.
```

### List and prompt for checkout

Alternatively, you can run a single command that effectively **combines** these commands by listing recent branches and then prompting for a branch number to check out,
which reduces the number of commands and keystrokes. ( This is the most common use case.)

```shell
# Local branches
git recent-prompt-local <count=10> [<for-each-ref-options>]
# Short form (think "recl" + "conl")
git reconl

# Remote branches
git recent-prompt-remote <count=10> [<for-each-ref-options>]
# Short form (think "recr" + "conr")
git reconr
```

Example of remote listing with prompt:

```shell
git reconr
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

1. Clone the repo or download the configuration file.
2. Add a directive to your `~/.gitconfig` file to include the configuration file:

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

We welcome contributions to GitRecon! To get started, please read our [Contributing Guidelines](CONTRIBUTING.md).

## 🙏 Acknowledgments

- [Git](https://git-scm.com/) - The tool that inspired this project.
- [Homebrew](https://brew.sh/) - For making package management so easy.

## 📝 License

This project is licensed under the ISC License. See the [LICENSE](LICENSE) file for details.


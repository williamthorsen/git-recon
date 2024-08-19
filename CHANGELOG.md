# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.10.0] - 2024-08-19

### Features

- Added guards to all the aliases that use underlying Git commands, so that they exit with Git's error message when run outside a repo.

### Tooling

- Modified the `create-release.sh` script to generate a title in the required format `v0.0.0 - 2024-01-01` instead of `v0.0.0 Release`

### Tests

- Fixed tests broken by alias changes in 0.9.0.

## [0.9.0] - 2024-08-19

### Changed

- Renamed aliases for consistency and to avoid conflict with the `git-recon` utility script:
  - `checkout-nth` → `checkout-nth-local`
  - `con` → `conl`
  - `con-r` → `conr`
  - `recent` → `recent-local`
  - `recent-r` → `recr`
  - `recent-prompt` → `recent-prompt-local`
  - `recent-prompt-usage` → `recent-prompt-local-usage`
  - `recent-remote-prompt` → `recent-prompt-remote`
  - `recent-remote-prompt-usage` → `recent-prompt-remote-usage`
  - `recent-usage` → `recent-local-usage`
  - `recon` → `reconl`
  - `recon-r` → `reconr`
- Added `recl` alias for `recent-local`

### Refactored

- Renamed some internal aliases for clarity and consistency:
  - `decorated` → `decorated-local`
  - `recent-legend` → `recent-local-legend`

### Docs

- Updated README: Added overview, updated aliases, usage instructions, examples, and links to license and contribution guidelines
- Removed detailed API reference from README (will be re-added in a separate document)
- Added a CONTRIBUTING.md file with guidelines for contributing to the project

## [0.8.3] - 2024-08-18

### Fixed

- Fixed the issue that `brew upgrade` does not upgrade the Git-Recon configuration file.

### Tests

- Add guards to report failure if a `git` command fails in a test.

## [0.8.2] - 2024-08-18

### Fixed

- Fixed the issue that `git checkout-nth-remote` (or its shortcut equivalent) fails if the branch is not the default branch.

### Tooling

- Added a Deno configuration file (`deno.jsonc`) to support formatting and scripts.
- Replaced `package.json` with `metadata.ts` and supporting Deno scripts.

## [0.8.1] - 2024-08-18

### Fixed

- Fixed the issue that `git checkout-nth-remote` (or its shortcut equivalent) fails if Git lists the default remote branch as `<remote>` rather than `<remote>/HEAD`.

### Changed

- Improved the message that displays when Git-Recon is already configured. Old: "Nothing to do"; new: "Nothing to do. Git-Recon is already configured."

### Internal

- Added the script `list-git-configs.sh` to assist in debugging of Git configs. It lists all applicable Git configs in descending order of precedence.

## [0.8.0] - 2024-08-16

### Fixed

- Fixed an issue that caused the user's Git config not to be updated if it had no `[include]` section.

### Added

- Added option descriptions to help text for `git-recon`.

### Changed

- Changed `path` indent in Git config files from 6 spaces to standard 4 spaces.
- Improved output messages for `git-recon --install`.

### Tests

- Added unit tests for `git-recon --install`.
- Added `testing/install-to-fixtures.sh` script to test `git-recon --install` locally.

## [0.7.3] - 2024-08-16

### Added

- Initial implementation of core features.

# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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

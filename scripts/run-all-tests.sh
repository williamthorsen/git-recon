#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1

../git/__tests__/aliases.test.sh
../git/__tests__/recon.config.test.sh
#!/usr/bin/env bash
set -e

CURR_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
ABI_ROOT=${CURR_DIR}/../..

declare -a docs=(
    # 32-bit
    "aadwarf32" "addenda32" "clibabi32" "ehabi32"

    # 64-bit
    "aaelf64" "aapcs64" "vfabia64"

    # pauth extension
    "pauthabielf64"
)

for doc in "${docs[@]}"; do
    ( set -x; rstcheck --ignore-language=c,cpp --report=warning ${ABI_ROOT}/${doc}/${doc}.rst )
done

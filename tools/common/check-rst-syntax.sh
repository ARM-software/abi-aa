#!/usr/bin/env bash
set -e

CURR_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
ABI_ROOT=${CURR_DIR}/../..

declare -a docs=(
    # 32-bit
    "aadwarf32" "aaelf32" "aapcs32" "addenda32" "bpabi32" "bsabi32" "clibabi32" "cppabi32" "ehabi32" "rtabi32"

    # 64-bit
    "aadwarf64" "aaelf64" "aapcs64" "cppabi64" "vfabia64"

    # pauth extension
    "pauthabielf64"

    # morello
    "aadwarf64-morello" "aaelf64-morello" "aapcs64-morello"

    # semihosting
    "semihosting"
)

for doc in "${docs[@]}"; do
    ( set -x; rstcheck --ignore-language=c,cpp --report=warning ${ABI_ROOT}/${doc}/${doc}.rst )
done

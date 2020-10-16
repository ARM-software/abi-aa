#!/usr/bin/env bash

if [ $# -ne 1 ]; then
    echo "usage: `basename $0` <output-dir>"
    echo "   <output-dir> - dir that will contain the pdfs"
    exit 1
fi

CURR_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
ABI_ROOT=${CURR_DIR}/../..
OUTPUT_DIR=$1

mkdir -p ${OUTPUT_DIR}

declare -a docs=(
    # 32-bit
    "aadwarf32" "addenda32" "clibabi32" "ehabi32"

    # 64-bit
    "aadwarf64" "aaelf64" "aapcs64" "vfabia64"

    # pauth extension
    "pauthabielf64"
)

for doc in "${docs[@]}"; do
    ( set -x ; rst2pdf ${ABI_ROOT}/${doc}/${doc}.rst    \
                       -s ${CURR_DIR}/rst2pdf-abi.style \
                       --repeat-table-rows              \
                       --default-dpi=110                \
                       -o ${OUTPUT_DIR}/${doc}.pdf )
done


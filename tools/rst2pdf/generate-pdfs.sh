#!/usr/bin/env bash

# Copyright (c) 2020-2021, Arm Limited
# SPDX-License-Identifier: Apache-2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


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
    "aadwarf32" "aaelf32" "aapcs32" "addenda32" "advnote132" "bpabi32" "bsabi32" "clibabi32" "cppabi32" "dbgovl32" "ehabi32" "rtabi32"

    # 64-bit
    "aadwarf64" "aaelf64" "aapcs64" "cppabi64" "sysvabi64" "vfabia64"

    # pauth extension
    "pauthabielf64"

    # morello
    "aadwarf64-morello" "aaelf64-morello" "aapcs64-morello"

    # semihosting
    "semihosting"
)

for doc in "${docs[@]}"; do
    ( set -x ; rst2pdf ${ABI_ROOT}/${doc}/${doc}.rst    \
                       -s ${CURR_DIR}/rst2pdf-abi.style \
                       --repeat-table-rows              \
                       --default-dpi=110                \
                       -o ${OUTPUT_DIR}/${doc}.pdf )
done

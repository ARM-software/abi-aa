#!/usr/bin/env bash

CURR_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
ABI_ROOT=${CURR_DIR}/../..

# 32-bit
rstcheck --ignore-language=c,cpp ${ABI_ROOT}/addenda32/addenda32.rst
rstcheck --ignore-language=c,cpp ${ABI_ROOT}/ehabi32/ehabi32.rst

# 64-bit
rstcheck --ignore-language=c,cpp ${ABI_ROOT}/aapcs64/aapcs64.rst
rstcheck --ignore-language=c,cpp ${ABI_ROOT}/vfabia64/vfabia64.rst

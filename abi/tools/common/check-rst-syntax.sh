#!/usr/bin/env bash

CURR_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
ABI_ROOT=${CURR_DIR}/../..

rstcheck --ignore-language=c,cpp ${ABI_ROOT}/vfabia64/vfabia64.rst
rstcheck --ignore-language=c,cpp ${ABI_ROOT}/aapcs64/aapcs64.rst

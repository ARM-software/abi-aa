#!/usr/bin/env bash
# helper script to aid in writing release notes

if [ $# -ne 2 ]; then
    echo "usage: `basename $0` <release> <hash>"
    echo "   <release> - name of the release, for example '2020Q3'"
    echo "   <hash>    - the git commit hash of the release"
    exit 1
fi

URL="https://github.com/ARM-software/abi-aa"
RELEASE=$1
HASH=$2

spec() {
    DOC=$1
    NAME=$2
    echo "${NAME} - [pdf](${URL}/releases/download/${RELEASE}/${DOC}.pdf), [html](${URL}/blob/${HASH}/${DOC}/${DOC}.rst)"
}

cat <<EOF
### the specifications included in this release

#### ABI for the Arm 32-bit Architecture
- $(spec aapcs32 "Procedure Call Standard for the Arm Architecture")
- $(spec aaelf32 "ELF for the Arm Architecture")
- $(spec aadwarf32 "DWARF for the Arm Architecture")
- $(spec bpabi32 "Base Platform ABI for the Arm Architecture")
- $(spec cppabi32 "C++ ABI for the Arm Architecture")
- $(spec ehabi32 "Exception Handling ABI for the Arm Architecture")
- $(spec rtabi32 "Run-time ABI for the Arm Architecture")
- $(spec clibabi32 "C Library for the Arm Architecture")
- $(spec addenda32 "Addenda to, and Errata in, the ABI for the ARM Architecture")

#### ABI for the Arm 64-bit Architecture
- $(spec aapcs64 "Procedure Call Standard for the Arm 64-bit Architecture")
- $(spec aaelf64 "ELF for the Arm 64-bit Architecture")
- $(spec aadwarf64 "DWARF for the Arm 64-bit Architecture")
- $(spec cppabi64 "C++ ABI for the Arm 64-bit Architecture")
- $(spec vfabia64 "Vector Function ABI for the Arm 64-bit Architecture")

#### PAuth ABI Extension
- $(spec pauthabielf64 "PAuth ABI Extension to ELF for the Arm 64-bit Architecture")

#### Morello Extension
- $(spec aapcs64-morello "Morello Extension to the Procedure Call Standard for the Arm 64-bit Architecture")
- $(spec aaelf64-morello "Morello Extension to ELF for the Arm 64-bit Architecture")
- $(spec aadwarf64-morello "Morello Extension to DWARF for the Arm 64-bit Architecture")

#### Miscellaneous material
- $(spec semihosting "Semihosting for AArch32 and AArch64")

### download bundle

PDFs of all the above specifications have also been bundled in this [zip file](${URL}/releases/download/${RELEASE}/Arm-Architecture-ABI-rel-${RELEASE}.zip).

### other specifications

For other ABI specifications, please go to: https://developer.arm.com/architectures/system-architectures/software-standards/abi
EOF

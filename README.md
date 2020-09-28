<div align="center">
   <img src="Arm_logo_blue_150MN.png" />
</div>

# Application Binary Interface for the Arm®  Architecture

This is the official place for the latest releases of the Application Binary
Interface for the Arm® Architecture, both for source files and officially
released documents.


## Transitioning the ABI specs

Currently we are in a transistion period while we convert all the ABI
specifications to this new format, with a CC-BY-SA-4.0 license. One by one, once
the individual documents have been converted, they will appear here, and they
will be included in future releases here on Github.

ABI documents that haven't been converted yet can be found on [the Arm-hosted
developer
site](https://developer.arm.com/architectures/system-architectures/software-standards/abi).


## Document locations

See the below tables for the status of the various ABI specifications. A dash represents that the document isn't available either on Github or on the Arm-hosted developer site.

### ABI for the Arm 32-bit Architecture

specification                                                      | latest on Github                     | last on developer site
---                                                                | ---                                  | ---
Application Binary Interface for the Arm architecture introduction | -                                    | [2019Q4](https://developer.arm.com/documentation/ihi0036/latest)
Procedure Call Standard for the Arm Architecture                   | -                                    | [2020Q2](https://developer.arm.com/documentation/ihi0042/latest)
ELF for the Arm Architecture                                       | -                                    | [2019Q1](https://developer.arm.com/documentation/ihi0044/latest)
DWARF for the Arm Architecture                                     | -                                    | [2018Q4](https://developer.arm.com/documentation/ihi0040/latest)
Base Platform ABI for the Arm Architecture                         | -                                    | [2018Q4](https://developer.arm.com/documentation/ihi0037/latest)
C++ ABI for the Arm Architecture                                   | -                                    | [2019Q4](https://developer.arm.com/documentation/ihi0041/latest)
Exception Handling ABI for the Arm Architecture                    | [ehabi32](ehabi32/ehabi32.rst)       | [2018Q4](https://developer.arm.com/documentation/ihi0038/latest)
Run-time ABI for the Arm Architecture                              | -                                    | [2018Q4](https://developer.arm.com/documentation/ihi0043/latest)
C Library for the Arm Architecture                                 | [clibabi32](clibabi32/clibabi32.rst) | [2018Q4](https://developer.arm.com/documentation/ihi0039/latest)
Support for Debugging Overlaid Programs                            | -                                    | [2018Q4](https://developer.arm.com/documentation/ihi0049/latest)
Addenda to, and Errata in, the ABI for the ARM Architecture        | [addenda32](addenda32/addenda32.rst) | [2019Q1](https://developer.arm.com/documentation/ihi0045/latest)
ABI Advisory Note - SP 8-byte alignment                            | -                                    | [2018Q4](https://developer.arm.com/documentation/ihi0046/latest)


### ABI for the Arm 64-bit Architecture

specification                                                      | latest on Github                     | last on developer site
---                                                                | ---                                  | ---
Procedure Call Standard for the Arm 64-bit Architecture            | [aapcs64](aapcs64/aapcs64.rst)       | [2018Q4](https://developer.arm.com/documentation/ihi0055/latest)
ELF for the Arm 64-bit Architecture                                | [aaelf64](aaelf64/aaelf64.rst)       | [2020Q2](https://developer.arm.com/documentation/ihi0056/latest)
DWARF for the Arm 64-bit Architecture                              | -                                    | [2020Q2](https://developer.arm.com/documentation/ihi0057/latest)
C++ ABI for the Arm 64-bit Architecture                            | -                                    | [2020Q2](https://developer.arm.com/documentation/ihi0059/latest)
Vector Function ABI for the Arm 64-bit Architecture                | [vfabia64](vfabia64/vfabia64.rst)    | [2019Q2](https://developer.arm.com/documentation/101129/latest)


### ABI for the Arm 64-bit Architecture with SVE support

specification                                                                                                                 | latest on Github                                   | last on developer site
---                                                                                                                           | ---                                                | ---
Procedure Call Standard for the Arm 64-bit Architecture with SVE support                                                      | content merged with [aapcs64](aapcs64/aapcs64.rst) | [2019Q2](https://developer.arm.com/documentation/101129/latest)
DWARF for the Arm 64-bit Architecture with SVE support                                                                        | -                                                  | [SVEdwf 00bet1](https://developer.arm.com/documentation/100985/latest)
Vector Function ABI for the Arm 64-bit Architecture (identical to document in *ABI for the Arm 64-bit Architecture* section) |  [vfabia64](vfabia64/vfabia64.rst)                 | [2019Q2](https://developer.arm.com/documentation/101129/latest)

### PAuth ABI Extension

specification                                               | latest on Github                  | last on developer site
---                                                         | ---                               | ---
PAuth ABI Extension to ELF for the Arm 64-bit Architecture  | [pauthabielf64](pauthabielf64/pauthabielf64.rst) | -


## Releases

The latest ABI releases are being made available only here on Github: https://github.com/ARM-software/abi-aa/releases

For the last specifications released on developer.arm.com, see the links to the individual documents in the *Document location* section above.


## Defects report

Please report defects in or enhancements to the specifications in this folder to
the [issue tracker page on
GitHub](https://github.com/ARM-software/abi-aa/issues).

For reporting defects or enhancements to documents that currenlty are not yet
included in this repo and are thus only hosted on developer.arm.com, please send
an email to arm.eabi@arm.com.

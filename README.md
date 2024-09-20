[![Actions Status](https://github.com/ARM-software/abi-aa/workflows/CI/badge.svg)](https://github.com/ARM-software/abi-aa/actions)

<div align="center">
   <img src="Arm_logo_blue_RGB.svg" />
</div>

# Application Binary Interface for the Arm®  Architecture

This is the official place for the latest documents of the Application Binary
Interface for the Arm® Architecture, both for source files and officially
released documents.


## Releases

The latest ABI releases are being made available only here on Github:
https://github.com/ARM-software/abi-aa/releases and are licensed under the
Creative Commons Attribution-ShareAlike 4.0 International License + grant of
Patent License.

If there is no entry in the change history table for a release, there are no
changes to the content of the document for that release.

Previous versions of the documents were released under a proprietary license on
developer.arm.com. These are now hosted in this repo, and are to be found under
the legacy documents folder. They follow the same folder naming scheme as the
main document folders.

See the links to the individual documents in the *Document locations* section below.


## Defect reports

Please report defects in or enhancements to the specifications in this folder to
the [issue tracker page on
GitHub](https://github.com/ARM-software/abi-aa/issues).

For reporting defects or enhancements to documents that currenlty are not yet
included in this repo and are thus only hosted on developer.arm.com, please send
an email to arm.eabi@arm.com.


## Document locations

See the tables below for the status of the various ABI specifications. A dash represents that the document isn't available either as a Github release or as a legacy release.

### ABI for the Arm 32-bit Architecture

specification                                                      | latest                                  | last legacy release
---                                                                | ---                                     | ---
Application Binary Interface for the Arm architecture introduction | [bsabi32](bsabi32/bsabi32.rst)          | [2019Q4](legacy-documents/bsabi32/ihi0036_D/ihi0036D_bsabi.pdf)
Procedure Call Standard for the Arm Architecture                   | [aapcs32](aapcs32/aapcs32.rst)          | [2020Q2](legacy-documents/aapcs32/ihi0042_J/IHI0042J_2020Q2_aapcs32.pdf)
ELF for the Arm Architecture                                       | [aaelf32](aaelf32/aaelf32.rst)          | [2019Q1](legacy-documents/aaelf32/ihi0044_H/IHI0044G_aaelf.pdf)
DWARF for the Arm Architecture                                     | [aadwarf32](aadwarf32/aadwarf32.rst)    | [2018Q4](legacy-documents/aadwarf32/ihi0040_C/IHI0040C_aadwarf.html)
Base Platform ABI for the Arm Architecture                         | [bpabi32](bpabi32/bpabi32.rst)          | [2018Q4](legacy-documents/bpabi32/ihi0037_D/IHI0037D_bpabi.html)
C++ ABI for the Arm Architecture                                   | [cppabi32](cppabi32/cppabi32.rst)       | [2019Q4](legacy-documents/cppabi32/ihi0041_G/IHI0041G_cppabi32.pdf)
Exception Handling ABI for the Arm Architecture                    | [ehabi32](ehabi32/ehabi32.rst)          | [2018Q4](legacy-documents/ehabi32/ihi0038_C/IHI0038B_ehabi.html)
Run-time ABI for the Arm Architecture                              | [rtabi32](rtabi32/rtabi32.rst)          | [2018Q4](legacy-documents/rtabi32/ihi0043_E/IHI0043D_rtabi.html)
C Library for the Arm Architecture                                 | [clibabi32](clibabi32/clibabi32.rst)    | [2018Q4](legacy-documents/oclibabi32/ihi0039_E/IHI0039E_clibabi.html)
Support for Debugging Overlaid Programs                            | [dbgovl32](dbgovl32/dbgovl32.rst)       | [2018Q4](https://developer.arm.com/documentation/ihi0049/latest)
Addenda to, and Errata in, the ABI for the ARM Architecture        | [addenda32](addenda32/addenda32.rst)    | [2019Q1](legacy-documents/addenda32/ihi0045_H/IHI0045H_ABI_addenda.html)
ABI Advisory Note - SP 8-byte alignment                            | [advnote132](advnote132/advnote132.rst) | [2018Q4](legacy-documents/advnote132/ihi0046_C/IHI0046C_ABI_Advisory_1.html)


### ABI for the Arm 64-bit Architecture

specification                                                      | latest                               | last legacy release
---                                                                | ---                                  | ---
Procedure Call Standard for the Arm 64-bit Architecture            | [aapcs64](aapcs64/aapcs64.rst)       | [2018Q4](legacy-documents/aapcs64/ihi0055_D/IHI0055D_aapcs64.html)
ELF for the Arm 64-bit Architecture                                | [aaelf64](aaelf64/aaelf64.rst)       | [2020Q2](legacy-documents/aaelf64/ihi0056_G/IHI0056G_2020Q2_aaelf64.pdf)
DWARF for the Arm 64-bit Architecture                              | [aadwarf64](aadwarf64/aadwarf64.rst) | [2020Q2](legacy-documents/aadwarf64/ihi0057_E/IHI0057_E_2020Q2_aadwarf64.pdf)
C++ ABI for the Arm 64-bit Architecture                            | [cppabi64](cppabi64/cppabi64.rst)    | [2020Q2](legacy-documents/cppabi64/ihi0059_E/IHI0059E_2020Q2_cppabi64.pdf)
Vector Function ABI for the Arm 64-bit Architecture                | [vfabia64](vfabia64/vfabia64.rst)    | [2019Q2](legacy-documents/vfabia64/101129_1920/101129_1920_01_en.pdf)
C/C++ Atomics ABI for the Arm 64-bit Architecture                  | [atomicsabi64](atomicsabi64/atomicsabi64.rst)    | n/a
System V ABI for the Arm 64-bit Architecture                       | [sysvabi64](sysvabi64/sysvabi64.rst) | n/a


### ABI for the Arm 64-bit Architecture with SVE support

specification                                                                                                                 | latest                                             | last legacy release
---                                                                                                                           | ---                                                | ---
Procedure Call Standard for the Arm 64-bit Architecture with SVE support                                                      | content merged with [aapcs64](aapcs64/aapcs64.rst) | [SVEpcs 00bet1](legacy-documents/aapcs64-sve/100986_0000/abi_sve_aapcs64_100986_0000_00_en.pdf)
DWARF for the Arm 64-bit Architecture with SVE support                                                                        | content merged with [aadwarf64](aadwarf64/aadwarf64.rst) | [SVEdwf 00bet1](legacy-documents/aadwarf64-sve/100985_0000/abi_sve_aadwarf_100985_0000_00_en.pdf)
Vector Function ABI for the Arm 64-bit Architecture (identical to document in *ABI for the Arm 64-bit Architecture* section)  |  [vfabia64](vfabia64/vfabia64.rst) | [2019Q2](legacy-documents/vfabia64/101129_1920/101129_1920_01_en.pdf)

### PAuth ABI Extension

specification                                               | latest                            | last legacy document
---                                                         | ---                               | ---
PAuth ABI Extension to ELF for the Arm 64-bit Architecture  | [pauthabielf64](pauthabielf64/pauthabielf64.rst) | -


### Memtag ABI Extension

specification                                                | latest on Github                                    | last on developer site
---                                                          | ---                                                 | ---
Memtag ABI Extension to ELF for the Arm 64-bit Architecture  | [memtagabielf64](memtagabielf64/memtagabielf64.rst) | -


### Morello Extension

specification                                                                     | latest                                                       | last legacy release
---                                                                               | ---                                                          | ---
Morello Extension to the Procedure Call Standard for the Arm 64-bit Architecture  | [aapcs64-morello](aapcs64-morello/aapcs64-morello.rst)       | [2020Q3](legacy-documents/aapcs64-morello/102205_0001/102205_aapcs-morello_final.pdf)
Morello Extension to ELF for the Arm 64-bit Architecture                          | [aaelf64-morello](aaelf64-morello/aaelf64-morello.rst)       | [2020Q3](legacy-documents/aaelf64-morello/102072_0001/102072_aaelf64-morello_final.pdf)
Morello Extension to DWARF for the Arm 64-bit Architecture                        | [aadwarf64-morello](aadwarf64-morello/aadwarf64-morello.rst) | [2020Q3](legacy-documents/aadwarf64-morello/102215_0001/102215_aadwarf64-morello_final.pdf)


### Miscellaneous material

specification                       | latest                                      | last legacy release
---                                 | ---                                         | ---
Semihosting for AArch32 and AArch64 |  [semihosting](semihosting/semihosting.rst) | [2019Q4](legacy-documents/semihosting/100863_0300/semihosting.pdf)


## Contributions

Please find contribution guidelines in https://github.com/ARM-software/abi-aa/blob/main/CONTRIBUTING.md.


## License

All the open-source ABI documents are licensed under the Creative
Commons Attribution-ShareAlike 4.0 International License + grant
of Patent License.

For more information on licensing in this repository, see the license file:
[LICENSE](LICENSE.md).

..
   Copyright (c) 2011-2020, Arm Limited and its affiliates.  All rights reserved.
   CC-BY-SA-4.0 AND Apache-Patent-License
   See LICENSE file for details

.. |release| replace:: 2020Q3
.. |date-of-issue| replace:: 1\ :sup:`st` October 2020
.. |copyright-date| replace:: 2011-2020
.. |footer| replace:: Copyright © |copyright-date|, Arm Limited and its
                      affiliates. All rights reserved.

.. _ABIAA: https://github.com/ARM-software/abi-aa/releases
.. _ARMARM: https://developer.arm.com/documentation/ddi0487/latest
.. _AAPCS64: https://github.com/ARM-software/abi-aa/releases
.. _AAELF64: https://github.com/ARM-software/abi-aa/releases
.. _CPPABI64: https://developer.arm.com/docs/ihi0059/latest
.. _GCABI: https://itanium-cxx-abi.github.io/cxx-abi/abi.html
.. _LSB: https://refspecs.linuxfoundation.org/LSB_1.2.0/gLSB/noteabitag.html
.. _SYSVABI: https://github.com/ARM-software/abi-aa/releases
.. _TLSDESC: http://www.fsfla.org/~lxoliva/writeups/TLS/paper-lk2006.pdf

System V ABI for the Arm® 64-bit Architecture (AArch64)
*******************************************************

.. class:: version

|release|

.. class:: issued

Date of Issue: |date-of-issue|

.. class:: logo

.. image:: ../Arm_logo_blue_150MN.png

.. section-numbering::

.. raw:: pdf

   PageBreak oneColumn

Preamble
========

Abstract
--------

This document describes the System V Application Binary Interface (ABI) for the Arm 64-bit architecture.

Keywords
--------

Code Model

Latest release and defects report
---------------------------------

Please check `Application Binary Interface for the Arm® Architecture
<https://github.com/ARM-software/abi-aa>`_ for the latest
release of this document.

Please report defects in this specification to the `issue tracker page
on GitHub
<https://github.com/ARM-software/abi-aa/issues>`_.

.. raw:: pdf

   PageBreak

Licence
-------

This work is licensed under the Creative Commons
Attribution-ShareAlike 4.0 International License. To view a copy of
this license, visit http://creativecommons.org/licenses/by-sa/4.0/ or
send a letter to Creative Commons, PO Box 1866, Mountain View, CA
94042, USA.

Grant of Patent License. Subject to the terms and conditions of this
license (both the Public License and this Patent License), each
Licensor hereby grants to You a perpetual, worldwide, non-exclusive,
no-charge, royalty-free, irrevocable (except as stated in this
section) patent license to make, have made, use, offer to sell, sell,
import, and otherwise transfer the Licensed Material, where such
license applies only to those patent claims licensable by such
Licensor that are necessarily infringed by their contribution(s) alone
or by combination of their contribution(s) with the Licensed Material
to which such contribution(s) was submitted. If You institute patent
litigation against any entity (including a cross-claim or counterclaim
in a lawsuit) alleging that the Licensed Material or a contribution
incorporated within the Licensed Material constitutes direct or
contributory patent infringement, then any licenses granted to You
under this license for that Licensed Material shall terminate as of
the date such litigation is filed.

About the license
-----------------

As identified more fully in the Licence_ section, this project
is licensed under CC-BY-SA-4.0 along with an additional patent
license.  The language in the additional patent license is largely
identical to that in Apache-2.0 (specifically, Section 3 of Apache-2.0
as reflected at https://www.apache.org/licenses/LICENSE-2.0) with two
exceptions.

First, several changes were made related to the defined terms so as to
reflect the fact that such defined terms need to align with the
terminology in CC-BY-SA-4.0 rather than Apache-2.0 (e.g., changing
“Work” to “Licensed Material”).

Second, the defensive termination clause was changed such that the
scope of defensive termination applies to “any licenses granted to
You” (rather than “any patent licenses granted to You”).  This change
is intended to help maintain a healthy ecosystem by providing
additional protection to the community against patent litigation
claims.

Contributions
-------------

Contributions to this project are licensed under an inbound=outbound
model such that any such contributions are licensed by the contributor
under the same terms as those in the `Licence`_ section.

Trademark notice
----------------

The text of and illustrations in this document are licensed by Arm
under a Creative Commons Attribution–Share Alike 4.0 International
license ("CC-BY-SA-4.0”), with an additional clause on patents.
The Arm trademarks featured here are registered trademarks or
trademarks of Arm Limited (or its subsidiaries) in the US and/or
elsewhere. All rights reserved. Please visit
https://www.arm.com/company/policies/trademarks for more information
about Arm’s trademarks.

Copyright
---------

Copyright (c) |copyright-date|, Arm Limited and its affiliates.  All rights reserved.

.. raw:: pdf

   PageBreak

.. contents::
   :depth: 3

.. raw:: pdf

   PageBreak

About this document
===================

Change Control
--------------

Current Status and Anticipated Changes
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The following support level definitions are used by the Arm ABI specifications:

**Release**
   Arm considers this specification to have enough implementations, which have
   received sufficient testing, to verify that it is correct. The details of these
   criteria are dependent on the scale and complexity of the change over previous
   versions: small, simple changes might only require one implementation, but more
   complex changes require multiple independent implementations, which have been
   rigorously tested for cross-compatibility. Arm anticipates that future changes
   to this specification will be limited to typographical corrections,
   clarifications and compatible extensions.

**Beta**
   Arm considers this specification to be complete, but existing
   implementations do not meet the requirements for confidence in its release
   quality. Arm may need to make incompatible changes if issues emerge from its
   implementation.

**Alpha**
   The content of this specification is a draft, and Arm considers the
   likelihood of future incompatible changes to be significant.

This document is at **Beta** release quality.

Change History
^^^^^^^^^^^^^^

.. table::

 +------------+--------------------+------------------------------------------------------------------+
 | Issue      | Date               | Change                                                           |
 +============+====================+==================================================================+
 | 00Alp1     | 3rd December 2020  | Alpha release containing Code Model only                         |
 +------------+--------------------+------------------------------------------------------------------+

References
----------

This document refers to, or is referred to by, the following documents.

.. table::

  +------------------------------+-------------------------------------------------------------+-----------------------------------------------------------------------------+
  | Ref                          | External reference or URL                                   | Title                                                                       |
  +==============================+=============================================================+=============================================================================+
  | SYSVABI_                     | Source for this document                                    | System V Application Binary Interface (ABI) for the Arm 64-bit architecture |
  +------------------------------+-------------------------------------------------------------+-----------------------------------------------------------------------------+
  | ARMARM_                      | DDI 0487                                                    | Arm Architecture Reference Manual Armv8 for Armv8-A architecture profile    |
  +------------------------------+-------------------------------------------------------------+-----------------------------------------------------------------------------+
  | AAPCS64_                     | IHI 0055                                                    | Procedure Call Standard for the Arm 64-bit Architecture                     |
  +------------------------------+-------------------------------------------------------------+-----------------------------------------------------------------------------+
  | AAELF64_                     | IHI 0056                                                    | ELF for the Arm 64-bit Architecture (AArch64).                              |
  +------------------------------+-------------------------------------------------------------+-----------------------------------------------------------------------------+
  | CPPABI64_                    | IHI 0059                                                    | C++ ABI for the Arm 64-bit Architecture                                     |
  +------------------------------+-------------------------------------------------------------+-----------------------------------------------------------------------------+
  | GCABI_                       | <https://itanium-cxx-abi.github.io/cxx-abi/abi.html>`_      | Generic C++ ABI                                                             |
  +------------------------------+-------------------------------------------------------------+-----------------------------------------------------------------------------+

Terms and Abbreviations
-----------------------

The ABI for the Arm 64-bit Architecture uses the following terms and abbreviations.
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

A32
   The instruction set named Arm in the Armv7 architecture; A32 uses 32-bit
   fixed-length instructions.

A64
   The instruction set available when in AArch64 state.

AAPCS64
   Procedure Call Standard for the Arm 64-bit Architecture (AArch64)

AArch32
   The 32-bit general-purpose register width state of the Armv8 architecture,
   broadly compatible with the Armv7-A architecture.

AArch64
   The 64-bit general-purpose register width state of the Armv8 architecture.

ABI
   Application Binary Interface:

   1. The specifications to which an executable must conform in order to
      execute in a specific execution environment. For example, the
      *Linux ABI for the Arm Architecture*.

   2. A particular aspect of the specifications to which independently
      produced relocatable files must conform in order to be
      statically linkable and executable.  For example, the CPPABI64

Arm-based
   ... based on the Arm architecture ...

Floating point
   Depending on context floating point means or qualifies: (a) floating-point
   arithmetic conforming to IEEE 754 2008; (b) the Armv8 floating point
   instruction set; (c) the register set shared by (b) and the Armv8 SIMD
   instruction set.

Q-o-I
   Quality of Implementation – a quality, behavior, functionality, or
   mechanism not required by this standard, but which might be provided
   by systems conforming to it.  Q-o-I is often used to describe the
   tool-chain-specific means by which a standard requirement is met.

SIMD
   Single Instruction Multiple Data – A term denoting or qualifying:
   (a) processing several data items in parallel under the control of one
   instruction; (b) the Arm v8 SIMD instruction set: (c) the register set
   shared by (b) and the Armv8 floating point instruction set.

SIMD and floating point
   The Arm architecture’s SIMD and Floating Point architecture comprising
   the floating point instruction set, the SIMD instruction set and the
   register set shared by them.

SVE
   The Arm architecture's Scalable Vector Extension.

T32
   The instruction set named Thumb in the Armv7 architecture; T32 uses
   16-bit and 32-bit instructions.

VG
   The number of 64-bit “vector granules” in an SVE vector; in other words,
   the number of bits in an SVE vector register divided by 64.

ILP32
   SysV-like data model where int, long int and pointer are 32-bit

LP64
   SysV-like data model where int is 32-bit, but long int and pointer are 64-bit.

LLP64
   Windows-like data model where int and long int are 32-bit, but long long int and pointer are 64-bit.

This document uses the following terms and abbreviations.
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

SysV
   Unix System V. A variant of the Unix Operating System. Although
   this specification refers to SysV, many other operating systems,
   such as Linux or BSD use similar conventions.

Platform
   A program execution environment such as that defined by an
   operating system or run- time environment. A platform defines the
   specific variant of the ABI and may impose additional
   constraints. Linux is a platform in this sense.

More specific terminology is defined when it is first used.

.. raw:: pdf

   PageBreak

Scope
=====

Except where otherwise stated the AArch64 System V ABI follows the
AArch64 base ABI documents in ABIAA_ . The AArch64 System V ABI
documents the places where divergence exists with respect to the base
ABI and attempts to act as a unifying document to cover information in
a variety of places that is of relevance to a System V implementation.

Software Installation
=====================

This document does not specify how software must be installed on an
AArch64 system.

Low Level Information
=====================

TBD

Programming / Coding Examples
=============================

Architectural Considerations
----------------------------

The AArch64 architecture does not allow for instructions to encode
arbitrary 64 bit constants in a single instructions. Immediates or
constants need to be constructed by a sequence of instructions that
are defined in the Arm Architecture Reference Manual for AArch64
ARMARM_. Most instructions accept restricted immediate forms as
detailed in the ARMARM_, the details of which are beyond the scope of
this document. Given the range of immediates and offsets accepted by
various instructions, programming on this architecture lends itself to
a set of code models that define a set of constraints to allow an
efficient mapping of a program to a set of machine instructions. In
the following section we document the code sequences for memory
addressing; and in effect document the various memory models produced
for the architecture.

Absolute Addressing
-------------------

Absolute addressing means that the virtual addresses of instructions
and statically allocated data are known at static link time. To
execute properly the object must be loaded at the virtual address
specified by the static linker. Critically this means that the static
linker can embed these fixed, absolute addresses into the read-only,
shareable code, rather than requiring run-time relocation via a Global
Offset Table (GOT). Absolute addressing does not mean that PC-relative
addressing cannot be used, if that is the most efficient way to
generate an absolute address within the limits supported by the model.

Absolute addressing is suitable for most bare-metal code, including
the Linux kernel, as well as for normal GNU/Linux executables which –
while dynamically linked – are loaded at a fixed address.

Position independent addressing
-------------------------------

In position independent code (PIC) the virtual addresses of
instructions and static data are not known until dynamic link
time.

The PIC model depends on an offset, known at static link time between
a read-only dynamic relocation free executable segment and a
read-write segment containing dynamic relocations. Code in the
executable segment accesses data in the read-write segment via
PC-relative addressing modes. PIC is typically used when building
dynamic shared objects, where references to external variables must
use indirect references via a static linker created global offset
table (GOT).

A GOT generating relocation is used to inform the static
linker to create the GOT entry. The address of symbol definitions that
cannot be pre-empted at dynamic link time can have their address
taken so no GOT generating relocation is required.

PIC can also be used to build position independent executables. A
variant of PIC called PIE (position independent executable) can be
used to build an executable. PIE assumes that global symbols cannot be
pre-empted, which means that an indirection via the GOT is not needed.

Assembler language addressing mode conventions
----------------------------------------------

The assembler examples in this document make use of operators to
modify the addressing mode used to form the immediate value of the
instruction.

The tables below describe the assembler operators that can be used to
alter the relocation directive emitted by the assembler. The typical
syntax is of the form ``#:<operator>:<symbol name>``

.. table:: Absolute operators

  +-----------------------+-------------+----------------------------+
  | Operator              | Instruction | Relocation                 |
  +=======================+=============+============================+
  | ``lo12``              | ``add``     | R_AARCH64_ADD_ABS_LO12_NC  |
  +-----------------------+-------------+----------------------------+
  | ``lo12``              | ``ldr,str`` | R_AARCH64_LDST_ABS_LO12_NC |
  +-----------------------+-------------+----------------------------+
  | ``abs_g0``            | ``mov[nz]`` | R_AARCH64_MOVW_UABS_G0     |
  +-----------------------+-------------+----------------------------+
  | ``abs_g0_s``          | ``mov[nz]`` | R_AARCH64_MOVW_SABS_G0     |
  +-----------------------+-------------+----------------------------+
  | ``abs_g0_nc``         | ``movk``    | R_AARCH64_MOVW_UABS_G0_NC  |
  +-----------------------+-------------+----------------------------+
  | ``abs_g1``            | ``mov[nz]`` | R_AARCH64_MOVW_UABS_G1     |
  +-----------------------+-------------+----------------------------+
  | ``abs_g1_s``          | ``mov[nz]`` | R_AARCH64_MOVW_SABS_G1     |
  +-----------------------+-------------+----------------------------+
  | ``abs_g1_nc``         | ``movk``    | R_AARCH64_MOVW_UABS_G1_NC  |
  +-----------------------+-------------+----------------------------+
  | ``abs_g2``            | ``mov[nz]`` | R_AARCH64_MOVW_UABS_G2     |
  +-----------------------+-------------+----------------------------+
  | ``abs_g2_s``          | ``mov[nz]`` | R_AARCH64_MOVW_SABS_G2     |
  +-----------------------+-------------+----------------------------+
  | ``abs_g2_nc``         | ``movk``    | R_AARCH64_MOVW_UABS_G2_NC  |
  +-----------------------+-------------+----------------------------+
  | ``abs_g3``            | ``mov[nz]`` | R_AARCH64_MOVW_UABS_G3     |
  +-----------------------+-------------+----------------------------+

.. table:: Position independent operators

  +-----------------------+-------------+-------------------------------+
  | Operator              | Instruction | Relocation                    |
  +=======================+=============+===============================+
  | (no operator)         | ``adrp``    | R_AARCH64_ADR_PREL_PG_HI21    |
  +-----------------------+-------------+-------------------------------+
  | ``pg_hi21``           | ``adrp``    | R_AARCH64_ADR_PREL_PG_HI21    |
  +-----------------------+-------------+-------------------------------+
  | ``pg_hi21_nc``        | ``adrp``    | R_AARCH64_ADR_PREL_PG_HI21_NC |
  +-----------------------+-------------+-------------------------------+
  | (no operator)         | ``adr``     | R_AARCH64_ADR_PREL_LO21       |
  +-----------------------+-------------+-------------------------------+
  | ``prel_g0``           | ``mov[nz]`` | R_AARCH64_MOVW_PREL_G0        |
  +-----------------------+-------------+-------------------------------+
  | ``prel_g0_nc``        | ``movk``    | R_AARCH64_MOVW_PREL_G0_NC     |
  +-----------------------+-------------+-------------------------------+
  | ``prel_g1``           | ``mov[nz]`` | R_AARCH64_MOVW_PREL_G1        |
  +-----------------------+-------------+-------------------------------+
  | ``prel_g1_nc``        | ``movk``    | R_AARCH64_MOVW_PREL_G1_NC     |
  +-----------------------+-------------+-------------------------------+
  | ``prel_g2``           | ``mov[nz]`` | R_AARCH64_MOVW_PREL_G2        |
  +-----------------------+-------------+-------------------------------+
  | ``prel_g2_nc``        | ``movk``    | R_AARCH64_MOVW_PREL_G2_NC     |
  +-----------------------+-------------+-------------------------------+
  | ``prel_g3``           | ``mov[nz]`` | R_AARCH64_MOVW_PREL_G3        |
  +-----------------------+-------------+-------------------------------+

.. table:: GOT operators

  +-----------------------+-------------+-------------------------------+
  | Operator              | Instruction | Relocation                    |
  +=======================+=============+===============================+
  | ``got``               | ``adrp``    | R_AARCH64_ADR_GOT_PAGE        |
  +-----------------------+-------------+-------------------------------+
  | ``got_lo12``          | ``ldr``     | R_AARCH64_LD64_GOT_LO12_NC    |
  +-----------------------+-------------+-------------------------------+
  | ``gotoff_g0_nc``      | ``movk``    | R_AARCH64_MOVW_GOTOFF_G0_NC   |
  +-----------------------+-------------+-------------------------------+
  | ``gotoff_g1``         | ``mov[nz]`` | R_AARCH64_MOVW_GOTOFF_G1      |
  +-----------------------+-------------+-------------------------------+
  | ``gotoff_lo15``       | ``ldr``     | R_AARCH64_LD64_GOTOFF_LO15    |
  +-----------------------+-------------+-------------------------------+
  | ``gotpage_lo15``      | ``ldr``     | R_AARCH64_LD64_GOTPAGE_LO15   |
  +-----------------------+-------------+-------------------------------+

.. note::

   ``#:got:src`` refers to the GOT slot for the symbol ``src``

   ``#:got_lo12:src`` refers to the lower 12 bits of the
   address of the GOT slot for the symbol ``src``.

   The symbol``__GLOBAL_OFFSET_TABLE__`` refers to the start of the
   global offset table (GOT) in the ELF module. The assembler
   instruction ``adrp xn, __GLOBAL_OFFSET_TABLE__`` finds the address of the 4KiB page
   containing the start of the GOT.

   ``#:gotpage_lo15:src`` is a 15-bit offset into the page containing
   the GOT entry for ``src``.

   ``#:gotoff_lo15:src`` - This refers to the 15 bit offset from the
   start of the GOT.

.. table:: TLS operators

  +-----------------------+-------------+---------------------------------------+
  | Operator              | Instruction | Relocation                            |
  +=======================+=============+=======================================+
  | ``gottprel_g0_nc``    | ``movk``    | R_AARCH64_TLSIE_MOVW_GOTTPREL_G0_NC   |
  +-----------------------+-------------+---------------------------------------+
  | ``gottprel_g1``       | ``mov[nz]`` | R_AARCH64_TLSIE_MOVW_GOTTPREL_G1      |
  +-----------------------+-------------+---------------------------------------+
  | ``tlsgd``             | ``adrp``    | R_AARCH64_TLSGD_ADR_PAGE21            |
  +-----------------------+-------------+---------------------------------------+
  | ``tlsgd``             | ``adr``     | R_AARCH64_TLSGD_ADR_PREL21            |
  +-----------------------+-------------+---------------------------------------+
  | ``tlsgd_lo12``        | ``add``     | R_AARCH64_TLSGD_ADD_LO12_NC           |
  +-----------------------+-------------+---------------------------------------+
  | ``tlsgd_g0_nc``       | ``movk``    | R_AARCH64_TLSGD_MOVW_G0_NC            |
  +-----------------------+-------------+---------------------------------------+
  | ``tlsgd_g1``          | ``mov[nz]`` | R_AARCH64_TLSGD_MOVW_G1               |
  +-----------------------+-------------+---------------------------------------+
  | ``tlsdesc``           | ``adrp``    | R_AARCH64_TLSDESC_ADR_PAGE21          |
  +-----------------------+-------------+---------------------------------------+
  | ``tlsdesc``           | ``adr``     | R_AARCH64_TLSDESC_ADR_PREL21          |
  +-----------------------+-------------+---------------------------------------+
  | ``tlsdesc_lo12``      | ``ldr``     | R_AARCH64_TLSDESC_LD64_LO12           |
  +-----------------------+-------------+---------------------------------------+
  | ``tlsldm``            | ``adrp``    | R_AARCH64_TLSLD_ADR_PAGE21            |
  +-----------------------+-------------+---------------------------------------+
  | ``tlsldm``            | ``adr``     | R_AARCH64_TLSLD_ADR_PREL21            |
  +-----------------------+-------------+---------------------------------------+
  | ``tlsldm_lo12_nc``    | ``add``     | R_AARCH64_TLSLD_ADD_LO12_NC           |
  +-----------------------+-------------+---------------------------------------+
  | ``dtprel_lo12``       | ``add``     | R_AARCH64_TLSLD_ADD_DTPREL_LO12       |
  +-----------------------+-------------+---------------------------------------+
  | ``dtprel_lo12``       | ``ldr``     | R_AARCH64_TLSLD_LDST64_DTPREL_LO12    |
  +-----------------------+-------------+---------------------------------------+
  | ``dtprel_lo12_nc``    | ``add``     | R_AARCH64_TLSLD_ADD_DTPREL_LO12_NC    |
  +-----------------------+-------------+---------------------------------------+
  | ``dtprel_lo12_nc``    | ``ldr``     | R_AARCH64_TLSLD_LDST64_DTPREL_LO12_NC |
  +-----------------------+-------------+---------------------------------------+
  | ``dtprel_g0``         | ``mov[nz]`` | R_AARCH64_TLSLD_MOVW_DTPREL_G0        |
  +-----------------------+-------------+---------------------------------------+
  | ``dtprel_g0_nc``      | ``movk``    | R_AARCH64_TLSLD_MOVW_DTPREL_G0_NC     |
  +-----------------------+-------------+---------------------------------------+
  | ``dtprel_g1``         | ``mov[nz]`` | R_AARCH64_TLSLD_MOVW_DTPREL_G1        |
  +-----------------------+-------------+---------------------------------------+
  | ``dtprel_g1_nc``      | ``movk``    | R_AARCH64_TLSLD_MOVW_DTPREL_G1_NC     |
  +-----------------------+-------------+---------------------------------------+
  | ``dtprel_g2``         | ``mov[nz]`` | R_AARCH64_TLSLD_MOVW_DTPREL_G2        |
  +-----------------------+-------------+---------------------------------------+
  | ``tlsdesc_off_g0_nc`` | ``movk``    | R_AARCH64_TLSDESC_OFF_G0_NC           |
  +-----------------------+-------------+---------------------------------------+
  | ``tlsdesc_off_g1``    | ``mov[nz]`` | R_AARCH64_TLSDESC_OFF_G1              |
  +-----------------------+-------------+---------------------------------------+
  | ``gottprel``          | ``adrp``    | R_AARCH64_TLSIE_ADR_GOTTPREL_PAGE21   |
  +-----------------------+-------------+---------------------------------------+
  | ``gottprel_lo12``     | ``ldr``     | R_AARCH64_TLSIE_LD64_GOTTPREL_LO12_NC |
  +-----------------------+-------------+---------------------------------------+
  | ``tprel``             | ``add``     | R_AARCH64_TLSLE_ADD_TPREL_LO12        |
  +-----------------------+-------------+---------------------------------------+
  | ``tprel_lo12``        | ``add``     | R_AARCH64_TLSLE_ADD_TPREL_LO12        |
  +-----------------------+-------------+---------------------------------------+
  | ``tprel_lo12``        | ``ldr``     | R_AARCH64_TLSLE_LDST64_TPREL_LO12     |
  +-----------------------+-------------+---------------------------------------+
  | ``tprel_hi12``        | ``add``     | R_AARCH64_TLSLE_ADD_TPREL_HI12        |
  +-----------------------+-------------+---------------------------------------+
  | ``tprel_lo12_nc``     | ``add``     | R_AARCH64_TLSLE_ADD_TPREL_LO12_NC     |
  +-----------------------+-------------+---------------------------------------+
  | ``tprel_lo12_nc``     | ``ldr``     | R_AARCH64_TLSLE_LDST64_TPREL_LO12_NC  |
  +-----------------------+-------------+---------------------------------------+
  | ``tprel_g2``          | ``mov[nz]`` | R_AARCH64_TLSLE_MOVW_TPREL_G2         |
  +-----------------------+-------------+---------------------------------------+
  | ``tprel_g1``          | ``mov[nz]`` | R_AARCH64_TLSLE_MOVW_TPREL_G1         |
  +-----------------------+-------------+---------------------------------------+
  | ``tprel_g1_nc``       | ``movk``    | R_AARCH64_TLSLE_MOVW_TPREL_G1_NC      |
  +-----------------------+-------------+---------------------------------------+
  | ``tprel_g0``          | ``mov[nz]`` | R_AARCH64_TLSLE_MOVW_TPREL_G0         |
  +-----------------------+-------------+---------------------------------------+
  | ``tprel_g0_nc``       | ``movk``    | R_AARCH64_TLSLE_MOVW_TPREL_G0_NC      |
  +-----------------------+-------------+---------------------------------------+

.. note::

   Relocations are defined in AAELF64_.

Memory Models
-------------

The AArch64 A64 instruction set has a number of features and
constraints which make it desirable to use different code models for
different sizes of executable or dynamic shared object, to improve
performance and reduce static code size. The relevant constraints are:

* The LDR (literal) and ADR instructions generate a PC-relative address
  with a range of +/- 1MiB.

* The ADRP instruction generates a PC-relative, page aligned address
  with a range of +/- 4GiB (where page = 4KiB).

* The LDR and STR instructions accept a 12-bit unsigned immediate
  offset, scaled by the access size.

* The B and BL instructiond have a range of +/-128MiB. This is
  typically used for function / procedure calls.

* Static linkers may insert a veneer (a sequence of instructions) to
  implement a relocated B or BL to a destination further away than the
  +/-128MiB range. The size of executable sections must be limited to
  127 MiB to leave space for veneers to be inserted after the section.

The following code models are defined

.. table::

  +-------+---------+----------------------+-------------------+
  | Code  | PIC     | Max Segment Size     | Max GOT size      |
  | Model | support |                      |                   |
  +=======+=========+======================+===================+
  | tiny  | yes     | text+got+data < 1MiB | 1MiB              |
  +-------+---------+----------------------+-------------------+
  | small | yes     | text+got+data < 4GiB | 32KiB base+offset |
  |       |         |                      | 4GiB  direct      |
  +-------+---------+----------------------+-------------------+
  | large | no      | no assumptions for   | see notes         |
  |       |         | static linking       |                   |
  |       |         |                      |                   |
  +-------+---------+----------------------+-------------------+

.. note::

  The max segment size column describes the total span of the
  statically allocated text and data, for example (``__end`` -
  ``__text_start``). It says nothing about the base address of the
  program or shared object, which may be located anywhere within the
  AArch64 virtual address space.

  The text segment includes the sharable PLT, code and read-only data
  sections.

  The data segment contains the statically defined, writeable,
  per-process data sections. In all models dynamically allocated data
  and stack can make use of the full virtual address space, dependent
  on operating system addressing limits.

  While designing the memory models it was estimated that only 2.6% of
  load modules (executables and dynamic shared objects) have a total
  static text+got+data size greater than 1MiB; the rest would all fit
  into the tiny model. However to avoid Makefile changes, it is
  recommended that the small model should be the default, with an
  explicit option to select the tiny model.

  Executables and shared objects may be linked dynamically with other
  shared objects which use a different code model.

  Linking of relocatable objects of different code models is possible
  as is linking of PIC/PIE and non-PIC relocatable objects. The result
  of the combination is always the most limited model. For example the
  combination of a tiny code model PIC object and small code model
  non-PIC object is a tiny non-PIC executable.

  The convention for command-line option to select code model is
  ``-mcmodel=<model>`` where code model is one of small, medium or
  large.


Code Model Examples
-------------------

The following section shows the same C program compiled with different
code-models. The code-models are illustrative of code produced by the
GCC and Clang compilers. They may not show optimal code-generation as
there may be alternative code-sequences that satisfy the limitations
of the code-models.

Example C program:

.. code-block:: c

  /* global */
  extern int src[65536];
  extern int dst[65536];
  extern int *ptr;

  void foo (void)
  {

    dst[0] = src[0];
    ptr = &dst[0];
    *ptr = src[0];
  }

  /* local, small */
  static int lsrc;
  static int ldst;
  static int *lptr;

  void bar (void)
  {
    ldst = lsrc;
    lptr = &ldst;
    *lptr = lsrc;
  }

  /* local, big */
  static int lbsrc[65536];
  static int lbdst[65536];

  void baz (void)
  {
    lbdst[0] = lbsrc[0];
    lptr = &lbdst[0];
    *lptr = lbsrc[0];
  }

  extern __attribute__((weak)) int weakref;
  int* getweakaddr()
  {
    return &weakref;
  }

Tiny Code Model
^^^^^^^^^^^^^^^

The example below shows code that could be generated for the tiny
memory model along with the relocations that would be produced for the
same. Code produced for the tiny memory model can use the ``ADR``
instruction to address data or functions all within a +/- 1MiB
range. The PC-relative ``load-literal`` instruction can also be used
to load directly from 64 and 32-bit static data, but not 16 or 8-bit
data.

.. code-block:: asm

  foo:
    adr     x0, dst       // R_AARCH64_ADR_PREL_LO21 dst
    adr     x1, src       // R_AARCH64_ADR_PREL_LO21 src
    ldr     w1, [x1]
    str     w1, [x0]
    adr     x1, ptr       // R_AARCH64_ADR_PREL_LO21 ptr
    str     x0, [x1]
    ret

  bar:
    adr     x0, .LANCHOR0 // R_AARCH64_ADR_PREL_LO21 .LANCHOR0
    ldr     w1, [x0, 4]
    str     w1, [x0]
    str     x0, [x0, 8]
    ret

  baz:
    adr     x0, lbdst     // R_AARCH64_ADR_PREL_LO21 lbdst
    adr     x1, lbsrc     // R_AARCH64_ADR_PREL_LO21 lbsrc
    ldr     w1, [x1]
    str     w1, [x0]
    adr     x1, .LANCHOR0 // R_AARCH64_ADR_PREL_LO21 .LANCHOR0
    str     x0, [x1, 8]
    ret

  getweak:
    ldr     x0, .LC0
    ret
    .align 3
  .LC0:
    .xword  weakref       // R_AARCH64_ABS64 weakref

  .bss
  .LANCHOR0
  ldst:
    .zero   4
  lsrc:
    .zero   4
  lptr:
    .zero   8
  lbdst:
    .zero   262144
  lbsrc:
    .zero   262144

.. note::

   Benefits over the small model are the ability to use the
   PC-relative loads of 32 and 64-bit data and a single ADR
   instruction to compute the address of any code or data symbol.

   An external symbol reference with a weak binding must always be
   output using the large absolute addressing model because if the
   program is linked to run at a virtual address higher than 1MiB,
   then it will not be possible to generate 0 as the address of an
   undefined weak symbol using the ADR instruction.

Tiny Code model PIC
^^^^^^^^^^^^^^^^^^^

Values can be loaded directly from the GOT with a single ``ldr``
instruction.

Code generation for extern weak references is the same as non-weak
external references as both cases are indirected via the GOT.

.. code-block:: asm

  foo:
    ldr     x0, :got:dst     // R_AARCH64_GOT_LD_PREL19 dst
    ldr     x1, :got:src     // R_AARCH64_GOT_LD_PREL19 src
    ldr     w1, [x1]
    str     w1, [x0]
    ldr     x1, :got:ptr     // R_AARCH64_GOT_LD_PREL19 ptr
    str     x0, [x1]
    ret

  bar:
    adr     x0, .LANCHOR0    // R_AARCH64_ADR_PREL_LO21 .LANCHOR0
    ldr     w1, [x0, 4]
    str     w1, [x0]
    str     x0, [x0, 8]
    ret

  baz:
    adr     x0, lbdst        // R_AARCH64_ADR_PREL_LO21 lbdst
    adr     x1, lbsrc        // R_AARCH64_ADR_PREL_LO21 lbsrc
    ldr     w1, [x1]
    str     w1, [x0]
    adr     x1, .LANCHOR0    // R_AARCH64_GOT_LD_PREL19 .LANCHOR0
    str     x0, [x1, 8]
    ret

  getweakaddr:
    ldr     x0, :got:weakref // R_AARCH64_GOT_LD_PREL19 weakref
    ret

  .bss
  .LANCHOR0:
  ldst:
    .zero   4
  lsrc:
    .zero   4
  lptr:
    .zero   8
  lbdst:
    .zero   262144
  lbsrc:
    .zero   262144


Small Code Model
^^^^^^^^^^^^^^^^

The small memory model uses the 2 instruction page + offset PC relative
addressing to access data which is all within +/- 4GiB of the code.

.. code-block:: asm

  foo:
    adrp    x0, dst                      // R_AARCH64_ADR_PREL_PG_HI21   dst
    add     x1, x0, :lo12:dst            // R_AARCH64_LDST64_ABS_LO12_NC dst
    adrp    x2, src                      // R_AARCH64_ADR_PREL_PG_HI21   src
    ldr     w2, [x2, #:lo12:src]         // R_AARCH64_LDST64_ABS_LO12_NC src
    str     w2, [x0, #:lo12:dst]         // R_AARCH64_LDST64_ABS_LO12_NC src
    adrp    x0, ptr                      // R_AARCH64_ADR_PREL_PG_HI21   ptr
    str     x1, [x0, #:lo12:ptr]         // R_AARCH64_LDST64_ABS_LO12_NC ptr
    ret

  bar:
    adrp    x1, .LANCHOR0                // R_AARCH64_ADR_PREL_PG_HI21   .LANCHOR0
    add     x0, x1, :lo12:.LANCHOR0      // R_AARCH64_LDST64_ABS_LO12_NC .LANCHOR0
    ldr     w2, [x0, 4]
    str     w2, [x1, #:lo12:.LANCHOR0]   // R_AARCH64_LDST64_ABS_LO12_NC .LANCHOR0
    str     x0, [x0, 8]
    ret

  baz:
    adrp    x0, lbdst                    // R_AARCH64_ADR_PREL_PG_HI21   lbdst
    add     x1, x0, :lo12:lbdst          // R_AARCH64_LDST64_ABS_LO12_NC lbdst
    adrp    x2, lbsrc                    // R_AARCH64_ADR_PREL_PG_HI21   lbsrc
    ldr     w2, [x2, #:lo12:lbsrc]       // R_AARCH64_LDST64_ABS_LO12_NC lbsrc
    str     w2, [x0, #:lo12:lbdst]       // R_AARCH64_LDST64_ABS_LO12_NC lbdst
    adrp    x0, .LANCHOR0+8              // R_AARCH64_ADR_PREL_PG_HI21   .LANCHOR0 + 8
    str     x1, [x0, #:lo12:.LANCHOR0+8] // R_AARCH64_LDST64_ABS_LO12_NC .LANCHOR0 + 8
    ret

  getweakaddr:
    adrp    x0, .LC0                     // R_AARCH64_ADR_PREL_PG_HI21   .LC0
    ldr     x0, [x0, #:lo12:.LC0]        // R_AARCH64_LDST64_ABS_LO12_NC .LC0
    ret
    .align 3
  .LC0:
    .xword  weakref                      // R_AARCH64_ABS64 weakref

  .bss
  .LANCHOR0
  ldst:
    .zero   4
  lsrc:
    .zero   4
  lptr:
    .zero   8
  lbdst:
    .zero   262144
  lbsrc:
    .zero   262144

Small Code model PIC
^^^^^^^^^^^^^^^^^^^^

The base address of the GOT, rounded down to a 4KiB page boundary is
loaded into a register. GOT entries can be loaded as offsets from the
GOT using an ``ldr`` instruction. The GOT size is limited by the 2\
:sup:`15` range of the ldr.

The address of a variable is a combination of ``adrp`` and ``add``

.. code-block:: asm

  foo:
    adrp    x0, _GLOBAL_OFFSET_TABLE_    // R_AARCH64_ADR_PREL_PG_HI21  _GLOBAL_OFFSET_TABLE_
    ldr     x1, [x0, #:gotpage_lo15:dst] // R_AARCH64_LD64_GOTPAGE_LO15 dst
    ldr     x2, [x0, #:gotpage_lo15:src] // R_AARCH64_LD64_GOTPAGE_LO15 src
    ldr     w2, [x2]
    str     w2, [x1]
    ldr     x0, [x0, #:gotpage_lo15:ptr] // R_AARCH64_LD64_GOTPAGE_LO15 ptr
    str     x1, [x0]
    ret

  bar:
    adrp    x1, .LANCHOR0                // R_AARCH64_ADR_PREL_PG_HI21  .LANCHOR0
    add     x0, x1, :lo12:.LANCHOR0      // R_AARCH64_ADD_ABS_LO12_NC   .LANCHOR0
    ldr     w2, [x0, 4]
    strb    w2, [x1, #:lo12:.LANCHOR0]   // R_AARCH64_LDST8_ABS_LO12_NC .LANCHOR0
    str     x0, [x0, 8]
    ret

  baz:
    adrp    x0, lbdst                    // R_AARCH64_ADR_PREL_PG_HI21  lbdst
    add     x1, x0, :lo12:lbdst          // R_AARCH64_ADD_ABS_LO12_NC   lbdst
    adrp    x2, lbsrc
    ldr     w2, [x2, #:lo12:lbsrc]       // R_AARCH64_ADD_ABS_LO12_NC   lbsrc
    str     w2, [x0, #:lo12:lbdst]       // R_AARCH64_ADD_ABS_LO12_NC   lbdst
    adrp    x0, .LANCHOR0+8              // R_AARCH64_ADR_PREL_PG_HI21  .LANCHOR0
    str     x1, [x0, #:lo12:.LANCHOR0+8] // R_AARCH64_ADD_ABS_LO12_NC   .LANCHOR0
    ret

  getweakaddr:
    adrp    x0, _GLOBAL_OFFSET_TABLE_
    ldr     x0, [x0, #:gotpage_lo15:weakref]
    ret

  .bss
  .LANCHOR0:
  ldst:
    .zero   4
  lsrc:
    .zero   4
  lptr:
    .zero   8
  lbdst:
    .zero   262144
  lbsrc:
    .zero   262144

Alternate small code model PIC GOT access
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Instead of loading the page base of the GOT into a register and
loading a GOT entry as an offset from the page base, an ``adrp`` and
``ldr`` pair can be used to directly load an entry. Each unique GOT
entry requires a pair of instructions to access, but the size of the
GOT is now limited by the range of the ``adrp`` used to access the
GOT.

.. code-block:: asm

  foo:
    adrp    x8, :got:src              // R_AARCH64_ADR_GOT_PAGE	    src
    ldr     x8, [x8, :got_lo12:src]   // R_AARCH64_LD64_GOT_LO12_NC src
    adrp    x9, :got:ptr              // R_AARCH64_ADR_GOT_PAGE	    ptr
    adrp    x10, :got:dst             // R_AARCH64_ADR_GOT_PAGE	    dst
    ldr     w8, [x8]
    ldr     x9, [x9, :got_lo12:ptr]   // R_AARCH64_LD64_GOT_LO12_NC ptr
    ldr     x10, [x10, :got_lo12:dst] // R_AARCH64_LD64_GOT_LO12_NC dst
    str     x10, [x9]
    str     w8, [x10]
    ret

Large Code Model
^^^^^^^^^^^^^^^^

The large model makes no assumptions about the size of the static code
and data segments, and therefore uses absolute 64-bit addresses in all
cases. As well as massive GNU/Linux executables, the large code model
would also be suitable for bare-metal programs where a linker script
causes sections to be mapped sparsely within the virtual address
space, or where a high-level code references absolute symbols defined
in a linker script.

Note that even if all code is compiled with the large code model,
limitations on the size of the program may still exist due to code
generated at link time or included from libraries. For example linker
generated PLT sequences and veneers may use the small code model.

.. code-block:: asm

  foo:
    adrp    x0, .LC0              // R_AARCH64_ADR_PREL_PG_HI21   .LC0
    ldr     x0, [x0, #:lo12:.LC0] // R_AARCH64_LDST64_ABS_LO12_NC .LC0
    adrp    x1, .LC1              // R_AARCH64_ADR_PREL_PG_HI21   .LC1
    ldr     x1, [x1, #:lo12:.LC1] // R_AARCH64_LDST64_ABS_LO12_NC .LC1
    ldr     w1, [x1]
    str     w1, [x0]
    adrp    x1, .LC2              // R_AARCH64_ADR_PREL_PG_HI21   .LC2
    ldr     x1, [x1, #:lo12:.LC2] // R_AARCH64_LDST64_ABS_LO12_NC .LC2
    str     x0, [x1]
    ret
    .align 3
  .LC0:
    .xword  dst                   // R_AARCH64_ABS64 .LC0
  .LC1:
    .xword  src                   // R_AARCH64_ABS64 .LC1
  .LC2:
    .xword  ptr                   // R_AARCH64_ABS64 .LC2

  bar:
    adrp    x0, .LC3              // R_AARCH64_ADR_PREL_PG_HI21 .LC3
    ldr     x0, [x0, #:lo12:.LC3] // R_AARCH64_LDST64_ABS_LO12_NC .LC3
    ldr     w1, [x0, 4]
    str     w1, [x0]
    str     x0, [x0, 8]
    ret
    .align  3
  .LC3:
    .xword  .LANCHOR0             // R_AARCH64_ABS64 .LANCHOR0

  baz:
    adrp    x0, .LC4              // R_AARCH64_ADR_PREL_PG_HI21 .LC4
    ldr     x0, [x0, #:lo12:.LC4] // R_AARCH64_LDST64_ABS_LO12_NC .LC4
    adrp    x1, .LC5              // R_AARCH64_ADR_PREL_PG_HI21 .LC5
    ldr     x1, [x1, #:lo12:.LC5] // R_AARCH64_LDST64_ABS_LO12_NC .LC5
    ldrb    w1, [x1]
    strb    w1, [x0]
    adrp    x1, .LC6              // R_AARCH64_ADR_PREL_PG_HI21 .LC6
    ldr     x1, [x1, #:lo12:.LC6] // R_AARCH64_LDST64_ABS_LO12_NC .LC6
    str     x0, [x1, 8]
    ret
    .align  3
  .LC4:
    .xword  lbdst                 // R_AARCH64_ABS64 lbdst
  .LC5:
    .xword  lbsrc                 // R_AARCH64_ABS64 lbsrc
  .LC6:
    .xword  .LANCHOR0             // R_AARCH64_ABS64 .LANCHOR0

  getweakaddr:
    adrp    x0, .LC7              // R_AARCH64_ADR_PREL_PG_HI21 .LC7
    ldr     x0, [x0, #:lo12:.LC7] // R_AARCH64_LDST64_ABS_LO12_NC .LC7
    ret
  .LC7:
    .align 3
    .xword  weakref               // R_AARCH64_ABS64 weakref

  .bss
  .LANCHOR0
  ldst:
    .zero   4
  lsrc:
    .zero   4
  lptr:
    .zero   8
  lbdst:
    .zero   262144
  lbsrc:
    .zero   262144

Alternate large code model using mov instructions
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Instead of loading an address from a literal pool, a 64-bit address
can be constructed from a series of movz and movk instructions. This
approach does not interleave code and data and avoids a load
instruction.

.. code-block:: asm

  foo:
    movz    x8, #:abs_g0_nc:src     // R_AARCH64_MOVW_UABS_G0_NC
    movk    x8, #:abs_g1_nc:src     // R_AARCH64_MOVW_UABS_G1_NC
    movk    x8, #:abs_g2_nc:src     // R_AARCH64_MOVW_UABS_G2_NC
    movk    x8, #:abs_g3:src        // R_AARCH64_MOVW_UABS_G3
    movz    x9, #:abs_g0_nc:ptr     // R_AARCH64_MOVW_UABS_G0_NC
    movz    x10, #:abs_g0_nc:dst    // R_AARCH64_MOVW_UABS_G0_NC
    ldr     w8, [x8]
    movk    x9, #:abs_g1_nc:ptr     // R_AARCH64_MOVW_UABS_G1_NC
    movk    x10, #:abs_g1_nc:dst    // R_AARCH64_MOVW_UABS_G1_NC
    movk    x9, #:abs_g2_nc:ptr     // R_AARCH64_MOVW_UABS_G2_NC
    movk    x10, #:abs_g2_nc:dst    // R_AARCH64_MOVW_UABS_G2_NC
    movk    x9, #:abs_g3:ptr        // R_AARCH64_MOVW_UABS_G3
    movk    x10, #:abs_g3:dst       // R_AARCH64_MOVW_UABS_G3
    str     x10, [x9]
    str     w8, [x10]
    ret

  bar:
    movz    x8, #:abs_g0_nc:lsrc    // R_AARCH64_MOVW_UABS_G0_NC
    movk    x8, #:abs_g1_nc:lsrc    // R_AARCH64_MOVW_UABS_G1_NC
    movk    x8, #:abs_g2_nc:lsrc    // R_AARCH64_MOVW_UABS_G2_NC
    movk    x8, #:abs_g3:lsrc       // R_AARCH64_MOVW_UABS_G3
    movz    x9, #:abs_g0_nc:lptr    // R_AARCH64_MOVW_UABS_G0_NC
    movz    x10, #:abs_g0_nc:ldst   // R_AARCH64_MOVW_UABS_G0_NC
    ldr     w8, [x8]
    movk    x9, #:abs_g1_nc:lptr    // R_AARCH64_MOVW_UABS_G1_NC
    movk    x10, #:abs_g1_nc:ldst   // R_AARCH64_MOVW_UABS_G1_NC
    movk    x9, #:abs_g2_nc:lptr    // R_AARCH64_MOVW_UABS_G2_NC
    movk    x10, #:abs_g2_nc:ldst   // R_AARCH64_MOVW_UABS_G2_NC
    movk    x9, #:abs_g3:lptr       // R_AARCH64_MOVW_UABS_G3
    movk    x10, #:abs_g3:ldst      // R_AARCH64_MOVW_UABS_G3
    str     x10, [x9]
    str     w8, [x10]
    ret

  baz:
    movz    x8, #:abs_g0_nc:lbsrc   // R_AARCH64_MOVW_UABS_G0_NC
    movk    x8, #:abs_g1_nc:lbsrc   // R_AARCH64_MOVW_UABS_G1_NC
    movk    x8, #:abs_g2_nc:lbsrc   // R_AARCH64_MOVW_UABS_G2_NC
    movk    x8, #:abs_g3:lbsrc      // R_AARCH64_MOVW_UABS_G3
    movz    x9, #:abs_g0_nc:lptr    // R_AARCH64_MOVW_UABS_G0_NC
    movz    x10, #:abs_g0_nc:lbdst  // R_AARCH64_MOVW_UABS_G0_NC
    ldr     w8, [x8]
    movk    x9, #:abs_g1_nc:lptr    // R_AARCH64_MOVW_UABS_G1_NC
    movk    x10, #:abs_g1_nc:lbdst  // R_AARCH64_MOVW_UABS_G1_NC
    movk    x9, #:abs_g2_nc:lptr    // R_AARCH64_MOVW_UABS_G2_NC
    movk    x10, #:abs_g2_nc:lbdst  // R_AARCH64_MOVW_UABS_G2_NC
    movk    x9, #:abs_g3:lptr       // R_AARCH64_MOVW_UABS_G3
    movk    x10, #:abs_g3:lbdst     // R_AARCH64_MOVW_UABS_G3
    str     x10, [x9]
    str     w8, [x10]
    ret

  getweakaddr:
    movz    x0, #:abs_g0_nc:weakref // R_AARCH64_MOVW_UABS_G0_NC
    movk    x0, #:abs_g1_nc:weakref // R_AARCH64_MOVW_UABS_G1_NC
    movk    x0, #:abs_g2_nc:weakref // R_AARCH64_MOVW_UABS_G2_NC
    movk    x0, #:abs_g3:weakref    // R_AARCH64_MOVW_UABS_G3
    ret

Large Code model PIC
^^^^^^^^^^^^^^^^^^^^

Arm does not currently define the large code-model for position
independent code.

Object Files
============

These follow the AAELF64_ base definition from Arm.

Program Linking and Dynamic Linking
===================================

TBD

Libraries
=========

Not applicable

Development Environment
=======================

Not applicable

Fortran
=======

Not applicable

C++
===

Refer to CPPABI64_

Linux Implementation Notes
==========================
TBD

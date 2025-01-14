..
   Copyright (c) 2021, Arm Limited and its affiliates.  All rights reserved.
   CC-BY-SA-4.0 AND Apache-Patent-License
   See LICENSE file for details

.. |release| replace:: 2021Q2
.. |date-of-issue| replace:: 7th June 2021
.. |copyright-date| replace:: 2021
.. |footer| replace:: Copyright © |copyright-date|, Arm Limited and its
                      affiliates. All rights reserved.

.. _MORELLO_DESC: https://github.com/ARM-software/abi-aa/blob/master/descabi-morello/descabi-morello.rst
.. _MORELLO_ARM: https://developer.arm.com/documentation/ddi0606/latest
.. |morello-arm-url| replace:: https://developer.arm.com/documentation/ddi0606/latest
.. |morello-pcs-url| replace:: https://github.com/ARM-software/abi-aa/blob/master/aapcs64-morello/aapcs64-morello.rst
.. _MORELLO_PCS: https://github.com/ARM-software/abi-aa/blob/master/aapcs64-morello/aapcs64-morello.rst
.. |morello-elf-url| replace:: https://github.com/ARM-software/abi-aa/blob/master/aaelf64-morello/aaelf64-morello.rst
.. _MORELLO_ELF: https://github.com/ARM-software/abi-aa/blob/master/aaelf64-morello/aaelf64-morello.rst

Morello Descriptor ABI for the  Arm\ :sup:`®` 64-bit Architecture (AArch64)
***************************************************************************

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

Morello alpha
-------------
This document is an alpha proposal for the Morello descriptor ABI for AArch64.

Abstract
--------

This document describes the use of the Morello Descriptor ABI for the Arm 64-bit
architecture.

Keywords
--------

ELF, AArch64 ELF, PCS, Morello, C64, ...

Latest release and defects report
---------------------------------

Please check `Application Binary Interface for the Arm® Architecture
<https://github.com/ARM-software/abi-aa>`_ for the latest
release of this document.

Please report defects in this specification to the `issue tracker page
on GitHub
<https://github.com/ARM-software/abi-aa/issues>`_.

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

Copyright (c) |copyright-date|, Arm Limited and its affiliates.  All rights
reserved.

.. raw:: pdf

   PageBreak

.. contents::
   :depth: 3

.. raw:: pdf

   PageBreak

About this document
===================

Change control
--------------

Current status and anticipated changes
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

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

This document is a draft and all content is at the **Alpha** quality level.
The relocation codes in `Relocation`_ in particular are expected to change.

Change history
^^^^^^^^^^^^^^

.. class:: morello-desc-change

.. table::

  +---------------+--------------------+-----------------------------------------+
  | Issue         | Date               | Change                                  |
  +===============+====================+=========================================+
  | 00alpha       | 7th June 2021      | Document released on GitHub.            |
  +---------------+--------------------+-----------------------------------------+

References
----------

This document refers to, or is referred to by, the following documents.

.. class:: morellodesc-references

.. table::

  +-------------------+----------------------------+------------------------------------------------+
  | Ref               | External reference or URL  | Title                                          |
  +===================+============================+================================================+
  | MORELLO_DESC_     | This document              | Morello Descriptor ABI for the Arm 64-bit      |
  |                   |                            | Architecture (AArch64).                        |
  +-------------------+----------------------------+------------------------------------------------+
  | MORELLO_ELF_      | |morello-elf-url|          | ELF for the Arm 64-bit Architecture (AArch64). |
  +-------------------+----------------------------+------------------------------------------------+
  | MORELLO_PCS_      | |morello-pcs-url|          | ELF for the Arm 64-bit Architecture (AArch64). |
  +-------------------+----------------------------+------------------------------------------------+
  | MORELLO_ARM_      | |morello-arm-url|          | Arm Architecture Reference Manual Supplement   |
  |                   |                            | Morello for A-profile Architecture.            |
  +-------------------+----------------------------+------------------------------------------------+

Terms and abbreviations
-----------------------

The ABI for the Morello extensions to the Arm 64-bit Architecture uses the
following terms and abbreviations.

C64
  The instruction set available when the Morello extensions are used.

A64
  The instruction set available when in AArch64 state.

Other terms may be defined when first used.

.. raw:: pdf

   PageBreak

About This Specification
========================

This specification provides the Morello Descriptor ABI specification for the
Arm 64-bit Architecture (AArch64), and is expected to be used along with MORELLO_ELF_
and MORELLO_PCS_.

Morello Descriptor ABI
======================

The Morello Descriptor ABI is a variant of the pure capability ABI which decouples code and
global data addresses, allowing the same code to be used with multiple instances of global data.
This allows compartments to share code in the same address space, while having separata data
instances.

Morello Descriptor ABI Procedure Call Standard
==============================================

The Morello Descriptor ABI Procedure Call Standard deviates from AAPCS64-cap
in the following ways:

- The general purpose register roles have been changed to allow C28 to be used as a temporary in cross-DSO function calls.

- Executable capabilities are now split into Function and Code capabilities.

- The set of callee-saved registers is changed to allow saving and restoring the Capability Private Data Addressing Register (``c28``) on function calls.


.. _General purpose registers and usage for the Morello descriptor ABI:

.. class:: aapcs64-morello-desc-gp-registers-usage

.. table:: General purpose registers and usage for the Morello descriptor ABI
    :widths: 12, 10, 78

    +------------+----------+----------------------------------------------------------------------------------------------------+
    | Register   | Special  | Role in AAPCS64-cap                                                                                |
    +============+==========+====================================================================================================+
    | r31        | CSP      | The Capability Stack Pointer.                                                                      |
    +------------+----------+----------------------------------------------------------------------------------------------------+
    | r30        | CLR      | The Capability Link Register.                                                                      |
    +------------+----------+----------------------------------------------------------------------------------------------------+
    | r29        | CIP1     | The second intra-procedure-call temporary register (can be used by call veneers and PLT code).     |
    +------------+----------+----------------------------------------------------------------------------------------------------+
    | r28        |          | The Capability Private Data Addressing Register (caller-saved).                                    |
    +------------+----------+----------------------------------------------------------------------------------------------------+
    | r19-r27    |          | Registers r19-r27 (c19-c27) are callee-saved.                                                      |
    +------------+----------+----------------------------------------------------------------------------------------------------+
    | r18        |          | The Platform Register, if needed; otherwise a temporary register.                                  |
    +------------+----------+----------------------------------------------------------------------------------------------------+
    | r17        |          | The Capability Frame Register.                                                                     |
    +------------+----------+----------------------------------------------------------------------------------------------------+
    | r16        | CIP0     | The first intra-procedure-call scratch register (can be used by call veneers and PLT code).        |
    +------------+----------+----------------------------------------------------------------------------------------------------+
    | r9-r15     |          | Temporary registers.                                                                               |
    +------------+----------+----------------------------------------------------------------------------------------------------+
    | r8         |          | The capability indirect result location register.                                                  |
    +------------+----------+----------------------------------------------------------------------------------------------------+
    | r0-r7      |          | Parameter/result registers.                                                                        |
    +------------+----------+----------------------------------------------------------------------------------------------------+


Function entry points
---------------------

The first instruction of a function (symbol with type STT_FUNC) is ``mov c28, c29``.
After this the execution falls through to the local entry point of the function.
The purpose of this instruction is to set up the Capability Private Data Addressing
Register.

DSO-local direct calls to a function will resolve to its local entry point.

This is an example of a code sequence that implements a function for a symbol ``sym``:

.. code-block:: text

   sym:
       mov c28, c29
   _sym_local:
       add c0, c0, #1
       ret c30

Capabilities
------------

The Descriptor ABI executable capabilities are categorized as Function capabilities and Code capabilities.

Code Capabilities
^^^^^^^^^^^^^^^^^

Code capabilities have object type ``RB``, executable permissions and can be used for indirect branches
restricted to the current DSO. Code capabilities are not used for function calls.

Function Capabilities
^^^^^^^^^^^^^^^^^^^^^

Function capabilities have object type ``LPB``. The value of the capability will point to
a memory location which contains two capabilities:

- The first capability is the Capability Private Data Addressing Register value for the called function.

- The second capability is a code capability which contains the address of the called function.

Function capabilities must be called using a ``ldpb(l)r c29, [cN]`` instruction.

Byte size and byte alignment of capability types
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. _Byte size and byte alignment of Morello-specific fundamental data types:

.. table:: Byte size and byte alignment of Morello-specific fundamental data types


    +------------------------+-------------------------+------------+---------------------------+----------------------------------------+
    | Type Class             | Machine Type            | Byte size  | Natural Alignment (bytes) | Note                                   |
    +========================+=========================+============+===========================+========================================+
    | Capability             | Function capability     | 16         | 16                        | Object type LPB, called using          |
    |                        |                         |            |                           | ldpb(l)r c29, [Cn] to branch to the    |
    |                        |                         |            |                           | symbol.                                |
    |                        +-------------------------+------------+---------------------------+----------------------------------------+
    |                        | Code capability         | 16         | 16                        | Object type RB, called using br Cn.    |
    |                        +-------------------------+------------+---------------------------+----------------------------------------+
    |                        | Data capability         | 16         | 16                        |                                        |
    +------------------------+-------------------------+------------+---------------------------+----------------------------------------+


Types Varying by Data Model and Procedure Calling Standard
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. _C/C++ type variants by data model and PCS:

.. class:: aapcs64-morello-desc-c-cpp-type-variants

.. table:: C/C++ type variants by data model and PCS

    +-----------------------------+-------------------------------------+------------------------------+
    | C/C++ Type                  | Machine Type                        | Notes                        |
    +=============================+=====================================+==============================+
    | ``T *``                     | Data Capability                     | Any data type ``T``.         |
    +-----------------------------+-------------------------------------+------------------------------+
    | ``T (*F)()``                | Function Capability                 | Any function type ``F``.     |
    +-----------------------------+-------------------------------------+------------------------------+
    | ``T&``                      | Data Capability                     | C++ reference.               |
    +-----------------------------+-------------------------------------+------------------------------+
    | ``T * __capability``        | Function Capability                 | Any data type ``T``.         |
    +-----------------------------+-------------------------------------+------------------------------+
    | ``T (* __capability F)()``  | Function Capability                 | Any function type ``F``.     |
    +-----------------------------+-------------------------------------+------------------------------+
    | ``T& __capability``         | Data Capability                     | C++ reference.               |
    +-----------------------------+-------------------------------------+------------------------------+
    | ``&&T``                     | Code Capability                     | Any label T.                 |
    +-----------------------------+-------------------------------------+------------------------------+

Morello Descriptor ABI ELF Extensions
=====================================


Private data sections
---------------------

The following sections are now part of a ``PT_MORELLO_DESC`` segment with the ``p_type`` value 0x70001000:

- ``.desc.data.rel.ro``

- ``.got``

- ``.data``

- ``.bss``


The value of the Capability Private Data Addressing Register (c28) points to the start of the ``PT_MORELLO_DESC``
segment, is read-only and can be used to access the ``.desc.data.rel.ro`` and ``.got`` sections.

The PT_MORELLO_DESC segment is similar to a TLS segment and can be moved to a different address by
the runtime of dynamic linker.

PLT sequence
------------

The PLT sequence for the Morello Descriptor ABI is:

.. code-block:: text

    adrp c16, :got:foo
    add c16, c16. :got_lo12:foo
    ldr c29, [c16]
    ldpbr c29, [c29]

Relocation
----------

Relocation operations
^^^^^^^^^^^^^^^^^^^^^

The following nomenclature is used in the descriptions of relocation operations:

- ``S`` (when used on its own) is the address of the symbol.

- ``A`` is the addend for the relocation.

- ``P`` is the address of the place being relocated (derived from ``r_offset``).

- ``D`` is the start of the section if the relocated symbol is the PT_MORELLO_DESC segment or equal to ``P`` otherwise

- ``C`` is 1 if the target symbol ``S`` has type ``STT_FUNC`` and the symbol
  addresses a C64 instruction; it is 0 otherwise.

- ``X`` is the result of a relocation operation, before any masking or
  bit-selection operation is applied

- ``Page(expr)`` is the page address of the expression expr, defined as (``expr &
  ~0xFFF``). This applies even if the machine page size supported by the platform
  has a different value.

- ``GOT`` is the address of the Global Offset Table, the table of code and data
  addresses to be resolved at dynamic link time. The ``GOT`` and each entry in it
  must be aligned to the pointer-size.

- ``GDAT(S+A)`` represents a pointer-sized entry in the ``GOT`` for address
  ``S+A``. The entry will be relocated at run time with relocation
  ``R_MORELLO_GLOB_DAT(S+A)``.

- ``G(expr)`` is the address of the GOT entry for the expression expr.

- ``CAP_INIT`` generates a capability with all required information. This performs
  the operation required to resolve a ``R_MORELLO_CAPINIT`` relocation (see MORELLO_ELF_).

- ``CAP_DESC_INIT`` generates a capability with all required information. This operation
  is descriptor-ABI-aware. When applied to symbols with type ``STT_FUNC`` this will produce
  a capability sealed with type ``LPB`` to the symbol. The resulting capability can be used
  with an ``ldpblr`` instruction to perform a call.

- ``CAP_SIZE`` is the size of the underlying memory region that the capability can
  reference. This may not directly map to the symbol size.

- ``CAP_PERM`` is the permission of the capability. This may not directly map to
  the type of the symbol.

- ``[msb:lsb]`` is a bit-mask operation representing the selection of bits in a
  value. The bits selected range from ``lsb`` up to ``msb`` inclusive. For
  example, ‘bits [3:0]’ represents the bits under the mask 0x0000000F. When
  range checking is applied to a value, it is applied before the masking
  operation is performed.

Static Morello Descriptor ABI Relocations
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. warning:: The ELF64 Code of the relocations are subject to change.

.. class:: aaelf64-morello-desc-static-relocations

.. table:: Relocations to generate 19, 21, and 33 bit PC-relative addresses
    :widths: 10, 42, 13, 35

    +-------+----------------------------------------+-----------------+-------------------------------------------------------------------------+
    | ELF64 | Name                                   | Operation       | Comment                                                                 |
    | Code  |                                        |                 |                                                                         |
    +=======+========================================+=================+=========================================================================+
    | 57860 | ``R_MORELLO_DESC_ADR_PREL_PG_HI20``    |  ``Page(S+A)``  | Set an ADR(D)P immediate value to bits [31:12] of the X. Set bit 23     |
    |       |                                        |  ``- Page(D)``  | of the relocated instruction to 0 if the symbol is in the segments or 1 |
    |       |                                        |                 | otherwise.                                                              |
    |       |                                        |                 | Check that -2\ :sup:`31` <= X < 2\ :sup:`31`.                           |
    +-------+----------------------------------------+-----------------+-------------------------------------------------------------------------+
    | 57861 | ``R_MORELLO_DESC_ADR_PREL_PG_HI20_NC`` | ``Page(S+A)``   | Set an ADR(D)P immediate value to bits [31:12] of the X. Set bit 23     |
    |       |                                        | ``- Page(D)``   | of the relocated instruction to 0 if the symbol in the segments or 1    |
    |       |                                        |                 | otherwise.                                                              |
    |       |                                        |                 | No overflow check.                                                      |
    |       |                                        |                 | Although overflow must not be checked, a linker should check that the   |
    |       |                                        |                 | value of X is aligned to a multiple of the datum size.                  |
    +-------+----------------------------------------+-----------------+-------------------------------------------------------------------------+

.. class:: aaelf64-morello-desc-control-flow-relocations

.. table:: Relocations for control-flow instructions - all offsets are a multiple of 4
    :widths: 10, 42, 13, 35

    +-------+------------------------------------+------------------+-------------------------------------------------+
    | ELF64 | Name                               | Operation        | Comment                                         |
    | Code  |                                    |                  |                                                 |
    +=======+====================================+==================+=================================================+
    | 57856 | ``R_MORELLO_DESC_GLOBAL_CALL26``   | ``((S+A)|C)-P``  | Set a BL immediate field to bits [27:2] of X+4  |
    |       |                                    |                  | if the symbol type is STT_FUNC or X otherwise.  |
    |       |                                    |                  | Check that -2\ :sup:`27` <= X < 2\ :sup:`27`    |
    |       |                                    |                  | See `Call and Jump relocations`_.               |
    +-------+------------------------------------+------------------+-------------------------------------------------+
    | 57857 | ``R_MORELLO_DESC_GLOBAL_JUMP26``   | ``((S+A)|C)-P``  | Set a B immediate field to bits [27:2] of X+4   |
    |       |                                    |                  | if the symbol type is STT_FUNC or X otherwise.  |
    |       |                                    |                  | Check that -2\ :sup:`27` <= X < 2\ :sup:`27`    |
    |       |                                    |                  | See `Call and Jump relocations`_.               |
    +-------+------------------------------------+------------------+-------------------------------------------------+
    | 57858 | ``R_AARCH64_DESC_GLOBAL_CALL26``   | ``((S+A)|C)-P``  | Set a BL immediate field to bits [27:2] of X+4  |
    |       |                                    |                  | if the symbol type is STT_FUNC or X otherwise.  |
    |       |                                    |                  | Check that -2\ :sup:`27` <= X < 2\ :sup:`27`    |
    |       |                                    |                  | See `Call and Jump relocations`_.               |
    +-------+------------------------------------+------------------+-------------------------------------------------+
    | 57859 | ``R_AARCH64_DESC_GLOBAL_JUMP26``   | ``((S+A)|C)-P``  | Set a BL immediate field to bits [27:2] of X+4  |
    |       |                                    |                  | if the symbol type is STT_FUNC or X otherwise.  |
    |       |                                    |                  | Check that -2\ :sup:`27` <= X < 2\ :sup:`27`    |
    |       |                                    |                  | See `Call and Jump relocations`_.               |
    +-------+------------------------------------+------------------+-------------------------------------------------+

.. class:: aaelf64-morello-desc-got-relative-relocations

.. table:: GOT-relative instruction relocations
    :widths: 9, 40, 24, 27

    +-------+--------------------------------------+------------------------+-----------------------------------------------------------+
    | ELF64 | Name                                 | Operation              | Comment                                                   |
    | Code  |                                      |                        |                                                           |
    +=======+======================================+========================+===========================================================+
    | 57862 | ``R_MORELLO_DESC_ADR_GOT_PAGE``      | ``Page(G(GDAT(S+A)))`` | Set the immediate value of an ADRP to bits [31:12] of X.  |
    |       |                                      | ``- Page(D)``          | Check that -2\ :sup:`31` <= X < 2\ :sup:`31`.             |
    |       |                                      |                        | Additionally clears bit 23 of the relocated instruction.  |
    +-------+--------------------------------------+------------------------+-----------------------------------------------------------+
    | 57863 | ``R_MORELLO_DESC_LD128_GOT_LO12_NC`` | ``G(GDAT(S+A))``       | Set the LD/ST immediate field to bits [11:4] of X.        |
    |       |                                      |                        | No overflow check. Check that X&15 = 0.                   |
    +-------+--------------------------------------+------------------------+-----------------------------------------------------------+

Call and Jump relocations
~~~~~~~~~~~~~~~~~~~~~~~~~

The call and jump relocation have the same semantics as ``R_MORELLO_CALL26``, ``R_MORELLO_JUMP26``,
``R_AARCH64_CALL26`` and ``R_AARCH64_JUMP26`` respectively (see MORELLO_ELF_).

Dynamic Relocations
^^^^^^^^^^^^^^^^^^^

.. _Dynamic relocations table:

.. class:: aaelf64-morello-desc-dynamic-relocations

.. table:: Dynamic relocations
    :widths: 9, 35, 38, 18


    +-------+----------------------------------+----------------------------------------------+------------------------------------------+
    | ELF64 | Name                             | Operation                                    | Comment                                  |
    | Code  |                                  |                                              |                                          |
    +=======+==================================+==============================================+==========================================+
    | 59408 | ``R_MORELLO_DESC_CAPINIT``       | ``CAP_DESC_INIT(S, A, CAP_SIZE, CAP_PERM)``  | See note below.                          |
    |       |                                  |                                              |                                          |
    +-------+----------------------------------+----------------------------------------------+------------------------------------------+
    | 59409 | ``R_MORELLO_DESC_GLOB_DAT``      | ``CAP_DESC_INIT(S, A, CAP_SIZE, CAP_PERM)``  | See note below.                          |
    |       |                                  |                                              |                                          |
    +-------+----------------------------------+----------------------------------------------+------------------------------------------+
    | 59410 | ``R_MORELLO_DESC_JUMP_SLOT``     | ``CAP_DESC_INIT(S, A, CAP_SIZE, CAP_PERM)``  | See note below.                          |
    |       |                                  |                                              |                                          |
    +-------+----------------------------------+----------------------------------------------+------------------------------------------+
    | 59411 | ``R_MORELLO_DESC_RELATIVE``      | ``CAP_DESC_INIT(S, A, CAP_SIZE, CAP_PERM)``  | See note below.                          |
    |       |                                  |                                              |                                          |
    +-------+----------------------------------+----------------------------------------------+------------------------------------------+
    | 59412 | ``R_MORELLO_DESC_DAT_RELATIVE``  | ``CAP_DESC_INIT(S, A, CAP_SIZE, CAP_PERM)``  | See note below.                          |
    |       |                                  |                                              |                                          |
    +-------+----------------------------------+----------------------------------------------+------------------------------------------+
    | 59413 | ``R_MORELLO_DESC_FUNC_RELATIVE`` | ``CAP_DESC_INIT(S, A, CAP_SIZE, CAP_PERM)``  | See note below.                          |
    |       |                                  |                                              |                                          |
    +-------+----------------------------------+----------------------------------------------+------------------------------------------+
    | 59414 | ``R_MORELLO_DESC_IRELATIVE``     | ``CAP_DESC_INIT(S, A, CAP_SIZE, CAP_PERM)``  | See note below.                          |
    |       |                                  |                                              |                                          |
    +-------+----------------------------------+----------------------------------------------+------------------------------------------+

.. note::

  ``R_MORELLO_DESC_CAPINIT`` instructs the runtime or dynamic loader to create a 16-byte
  capability at ``r_offset``. ``r_offset`` must be 16-byte aligned. Creates a function
  capability if the type of ``S`` is ``STT_FUNC``.

  ``R_MORELLO_DESC_GLOB_DAT`` instructs the runtime or dynamic loader to create a 16-byte
  capability in the GOT entry identified by ``r_offset``. The capability holds the
  address of a data symbol which must be resolved at load time when dynamic
  linking.

  ``R_MORELLO_DESC_JUMP_SLOT`` instructs the dynamic loader to create a 16-byte capability
  in the GOT entry identified by r_offset. The capability holds the address of a
  function symbol which must be resolved at load time. Creates a function capability.

  ``R_MORELLO_DESC_RELATIVE`` represents an optimization of ``R_MORELLO_DESC_GLOB_DAT``.
  It can be used when the symbol resolves to the current shared object or executable and
  the relocation result is not in the ``PT_MORELLO_DESC`` segment. ``S`` must be the ``Null``
  symbol (Index 0). The address and permissions must be written to the fragment.
  Creates a code or data capability.

  ``R_MORELLO_DESC_DAT_RELATIVE`` - similar to ``R_MORELLO_DESC_RELATIVE`` and should
  be used when the relocated value is in the ``PT_MORELLO_DESC`` segment. Creates
  a data capability.

  ``R_MORELLO_DESC_FUNC_RELATIVE`` represents an optimization of ``R_MORELLO_DESC_JUMP_SLOT``.
  It can be used when the symbol resolves to the current shared object or executable. ``S``
  must be the ``Null`` symbol (Index 0). The address and permissions must be written
  to the fragment. Creates a function capability.

  ``R_MORELLO_DESC_IRELATIVE`` is used by the linker when transforming ``IFUNC`` s. The
  rest are the same as ``R_MORELLO_DESC_RELATIVE``

All of the above relocations are against the ``PT_MORELLO_DESC segment``. The fragment encoding
is the same as for the ``R_MORELLO_RELATIVE`` relocation (see MORELLO_ELF_).

.. _RELATIVE relocation usage:

.. class:: aaelf64-morello-desc-relative-relocation-usage

.. table:: RELATIVE relocation usage


    +---------------------------+----------------------------------+---------------------------------+
    |                           | P is in the PT_MORELLO_DESC      | P is not in the PT_MORELLO_DESC |
    |                           | segment                          | segment                         |
    +===========================+==================================+=================================+
    | Data Capability with      | ``R_MORELLO_DESC_DAT_RELATIVE``  | Invalid use case                |
    | S in the PT_MORELLO_DESC  |                                  |                                 |
    | segment                   |                                  |                                 |
    |                           |                                  |                                 |
    +---------------------------+----------------------------------+---------------------------------+
    | Data Capability with      | ``R_MORELLO_DESC_RELATIVE``      | ``R_MORELLO_RELATIVE``          |
    | S not in the              |                                  |                                 |
    | PT_MORELLO_DESC segment   |                                  |                                 |
    |                           |                                  |                                 |
    +---------------------------+----------------------------------+---------------------------------+
    | Code Capability           | ``R_MORELLO_DESC_RELATIVE``      | ``R_MORELLO_RELATIVE``          |
    |                           |                                  |                                 |
    +---------------------------+----------------------------------+---------------------------------+
    | Function Capability       | ``R_MORELLO_DESC_FUNC_RELATIVE`` | Invalid use case                |
    |                           |                                  |                                 |
    +---------------------------+----------------------------------+---------------------------------+


When creating function capabilities the runtime or dynamic linker will allocate space for two capabilities:

- The first capability is the value of the Capability Private Data Addressing Register corresponding
  to the DSO of the function. The address and base of this capability are the start of the
  ``.desc.data.rel.ro`` section. This capability is read-only and has the bounds of the
  ``.desc.data.rel.ro`` section.

- The second capability is a code capability pointing to the address of the function.


The runtime or dynamic linker must guarantee that function capabilities produced by relocations
are bitwise equal if and only if the virtual address of the location that would be jumped to using
``ldpblr`` instruction is the same.


Static linking
^^^^^^^^^^^^^^

The linker will emit ``R_MORELLO_RELATIVE``, ``R_MORELLO_DESC_RELATIVE``, ``R_MORELLO_DESC_FUNC_RELATIVE``
and ``R_MORELLO_DESC_IRELATIVE`` dynamic relocations. These relocations need to be processed by the
runtime at program start-up.

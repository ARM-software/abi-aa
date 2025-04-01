..
   Copyright (c) 2020-2025, Arm Limited and its affiliates.  All rights reserved.
   CC-BY-SA-4.0 AND Apache-Patent-License
   See LICENSE file for details

.. |release| replace:: 2025Q1
.. |date-of-issue| replace:: 07\ :sup:`th` April 2025
.. |copyright-date| replace:: 2020-2025
.. |footer| replace:: Copyright © |copyright-date|, Arm Limited and its
                      affiliates. All rights reserved.

.. _AAPCS64: https://github.com/ARM-software/abi-aa/releases

Morello extensions to Procedure Call Standard for the Arm® 64-bit Architecture (AArch64)
****************************************************************************************

.. class:: version

|release|

.. class:: issued

Date of Issue: |date-of-issue|

.. class:: logo

.. image:: Arm_logo_blue_RGB.svg
   :scale: 30%

.. section-numbering::

.. raw:: pdf

   PageBreak oneColumn

Preamble
========

Morello alpha
-------------
This document is an alpha proposal for Morello extensions to Procedure Call Standard for
AArch64.

Abstract
--------

This document describes the Morello additions to the Procedure Call Standard used by the Application Binary Interface (ABI) for the Arm 64-bit architecture.

Keywords
--------

Procedure call, function call, calling conventions, data layout

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

Change history
^^^^^^^^^^^^^^

If there is no entry in the change history table for a release, there are no
changes to the content of the document for that release.

.. class:: aapcs64-morello-change

.. table::

    +----------+------------------------------+----------------------------------------+
    | Issue    | Date                         | Change                                 |
    +==========+==============================+========================================+
    | 00alpha  | 1st October 2020             | Alpha release.                         |
    +----------+------------------------------+----------------------------------------+
    | 2020Q4   | 21\ :sup:`st` December 2020  | Document released on Github.           |
    +----------+------------------------------+----------------------------------------+
    | 2022Q1   | 1\ :sup:`st` April 2022      | Fix up rule C.8 on capability passing. |
    +----------+------------------------------+----------------------------------------+
    | 2022Q3   | 20\ :sup:`th` October 2022   | Rework varargs for Morello.            |
    +----------+------------------------------+----------------------------------------+


References
----------

This document refers to, or is referred to by, the following documents.

.. class:: aapcs64-morello-references

.. table::

    +------------------+--------------------------+--------------------------------------------------------------------------------------------+
    | Ref              | URL or other reference   | Title                                                                                      |
    +------------------+--------------------------+--------------------------------------------------------------------------------------------+
    | AAPCS64-morello  | This document            | Morello extensions to Procedure Call Standard for the Arm® 64-bit Architecture (AArch64).  |
    +------------------+--------------------------+--------------------------------------------------------------------------------------------+
    | AAPCS64_         | IHI 005D                 | Procedure Call Standard for the Arm 64-bit Architecture.                                   |
    +------------------+--------------------------+--------------------------------------------------------------------------------------------+

Terms and Abbreviations
-----------------------

The ABI for the Arm 64-bit Architecture uses the following terms and abbreviations in addition
to the terms and abbreviations used in the AAPCS64_ document.

AAPCS64-cap
    The pure capability Procedure Call Standard for the Arm 64-bit
    Architecture (AArch64)

C64
    Execution state where PSTATE.C64 is set.

A64
    Execution state where PSTATE.C64 is cleared.

Capability
    The capability data type is an unforgeable token of authority which provides
    a foundation for fine grained memory protection and strong compartmentalisation.

Deriving a capability
    A capability value CV2 is said to be derived from a capability value CV1
    when CV2 is a copy of CV1 with optionally removed permissions and/or
    optionally narrowed bounds (base increased or limit reduced).

More specific terminology is defined when it is first used.

.. raw:: pdf

   PageBreak

Scope
=====

This document extends the AAPCS64 calling convention described in
the AAPCS64_ document in order to add support for capabilities, and adds an
additional Procedure Calling Standard (AAPCS64-cap). AAPCS64-cap is identical to AAPCS64,
except for the differences documented here.

.. raw:: pdf

   PageBreak

Introduction
============

The AAPCS64 is the first revision of Procedure Call standard for the Arm 64-bit Architecture. It forms part of the complete ABI specification for the Arm 64-bit Architecture.

The AAPCS64-cap is a Procedure Call standard for the Arm 64-bit Architecture designed to implement a software environment where all memory accesses are performed using capabilities.

Design Goals
------------

AAPCS64 and AAPCS64-cap have the same design goals as described in the AAPCS64_ document.

An additional design goal for the capability-aware AAPCS64 is to support interworking with legacy AAPCS64 code, following only the Procedure Calling Standard described in the AAPCS64_                 document.

Conformance
-----------

The AAPCS64 and AAPCS64-cap have the same conformance rules as defined in AAPCS64_, with the additional requirement that:

- At each call where the control transfer instruction is subject to a BL-type relocation at static link time, rules on the use of r16 and r17 (CIP0, CIP1, IP0, IP1) are observed (`Use of CIP0 and CIP1 by the linker`_).

.. raw:: pdf

   PageBreak


Data Types and Alignment
========================

Fundamental Data Types
----------------------

`Byte size and byte alignment of Morello-specific fundamental data types`_ shows the additional fundamental data types (Machine Types) of the machine that
are available in AAPCS64 and AAPCS64-cap, in addition to the fundamental data types shown in the AAPCS64_ document.

.. _Byte size and byte alignment of Morello-specific fundamental data types:

.. table:: Byte size and byte alignment of Morello-specific fundamental data types

    +------------------------+-------------------------+------------+---------------------------+-----------------------------------------------+
    | Type Class             | Machine Type            | Byte size  | Natural Alignment (bytes) | Note                                          |
    +========================+=========================+============+===========================+===============================================+
    | Capability             | Data capability         | 16         | 16                        |  See `Capabilities`_.                         |
    |                        +-------------------------+------------+---------------------------+                                               |
    |                        | Code capability         | 16         | 16                        |                                               |
    +------------------------+-------------------------+------------+---------------------------+-----------------------------------------------+


Capabilities
------------

Capabilities are 129-bit types which encode a 64 bit value and extra information such as the bounds of the allocation the value is addressing and access permissions.
Each capability has a single-bit tag associated with it that is tracked by the hardware, used to guarantee that the capability is unforgeable. The size of the capability in memory is 16
bytes, with the tag bit being stored separately at the corresponding capability tag location. A capability must be stored in memory at a 16-byte aligned address.

A NULL capability is represented by a capability with all bits zero, and the tag bit cleared.

A comparison between two capabilities will be performed by comparing the value fields of the two capabilities.

.. raw:: pdf

   PageBreak

The Base Procedure Call Standard
================================

The base standard defines a machine-level calling standard for the A64 instruction set. It assumes the availability of the vector registers for passing floating-point and SIMD arguments.


Machine Registers
-----------------

The Arm 64-bit architecture defines two mandatory register banks:

- A general-purpose register bank which can be used for scalar integer processing and pointer arithmetic.

- A SIMD and Floating-Point register bank.

General-purpose Registers
^^^^^^^^^^^^^^^^^^^^^^^^^

There are thirty-one, 128 bit (with one additional tag bit), general-purpose (capability) registers visible to the A64 and C64 states; these are labelled r0-r30.

- In a 64-bit context these registers are normally referred to using the names x0-x30.

- In a 32-bit context the registers are specified by using w0-w30.

- In a capability context the registers are specified by using c0-c30.

Additionally, a stack-pointer register, SP in a 64-bit context or CSP in a capability context, can be used with a restricted number of instructions. Register names may appear in assembly language in either upper case or lower case. In this specification when the register has a fixed role in this procedure call standard, upper case is used.

- `General purpose registers and AAPCS64-cap usage`_ summarize the uses of the general-purpose registers for AAPCS64-cap.

- `General purpose registers and AAPCS64 usage`_ summarize the uses of the general-purpose registers for AAPCS64.

.. _General purpose registers and AAPCS64-cap usage:

.. class:: aapcs64-morello-gp-registers-usage

.. table:: General purpose registers and AAPCS64-cap usage

    +------------+----------+----------------------------------------------------------------------------------------------------+
    | Register   | Special  | Role in AAPCS64-cap                                                                                |
    +============+==========+====================================================================================================+
    | r31        | CSP      | The Capability Stack Pointer.                                                                      |
    +------------+----------+----------------------------------------------------------------------------------------------------+
    | r30        | CLR      | The Capability Link Register.                                                                      |
    +------------+----------+----------------------------------------------------------------------------------------------------+
    | r29        | CFP      | The Capability Frame Pointer.                                                                      |
    +------------+----------+----------------------------------------------------------------------------------------------------+
    | r19-r28    |          | Registers r19-r28 (c19-c28) are callee-saved.                                                      |
    +------------+----------+----------------------------------------------------------------------------------------------------+
    | r18        |          | The Platform Register, if needed; otherwise a temporary register. See notes.                       |
    +------------+----------+----------------------------------------------------------------------------------------------------+
    | r17        | CIP1     | The second intra-procedure-call temporary register (can be used by call veneers and PLT code).     |
    +------------+----------+----------------------------------------------------------------------------------------------------+
    | r16        | CIP0     | The first intra-procedure-call scratch register (can be used by call veneers and PLT code).        |
    +------------+----------+----------------------------------------------------------------------------------------------------+
    | r10-r15    |          | Temporary registers.                                                                               |
    +------------+----------+----------------------------------------------------------------------------------------------------+
    | r9         |          | Parameter register for variadic calls, temporary register otherwise.                               |
    +------------+----------+----------------------------------------------------------------------------------------------------+
    | r8         |          | The capability indirect result location register.                                                  |
    +------------+----------+----------------------------------------------------------------------------------------------------+
    | r0-r7      |          | Parameter/result registers.                                                                        |
    +------------+----------+----------------------------------------------------------------------------------------------------+

.. _General purpose registers and AAPCS64 usage:

.. class:: aapcs64-morello-gp-registers-usage

.. table:: General purpose registers and AAPCS64 usage

    +-----------+----------+----------------------------------------------------------------------------------------------------+
    | Register  | Special  | Role in AAPCS64                                                                                    |
    +===========+==========+====================================================================================================+
    | r31       | SP       | The Stack Pointer.                                                                                 |
    +-----------+----------+----------------------------------------------------------------------------------------------------+
    | r30       | LR       | The Link Register.                                                                                 |
    +-----------+----------+----------------------------------------------------------------------------------------------------+
    | r29       | FP       | The Frame Pointer.                                                                                 |
    +-----------+----------+----------------------------------------------------------------------------------------------------+
    | r19-r28   |          | The lower 64 bits of the registers (x19-x28) is callee-saved.                                      |
    +-----------+----------+----------------------------------------------------------------------------------------------------+
    | r18       |          | The Platform Register, if needed; otherwise a temporary register. See notes.                       |
    +-----------+----------+----------------------------------------------------------------------------------------------------+
    | r17       | IP1      | The second intra-procedure-call temporary register (can be used by call veneers and PLT code).     |
    +-----------+----------+----------------------------------------------------------------------------------------------------+
    | r16       | IP0      | The first intra-procedure-call scratch register (can be used by call veneers and PLT code).        |
    +-----------+----------+----------------------------------------------------------------------------------------------------+
    | r9-r15    |          | Temporary registers.                                                                               |
    +-----------+----------+----------------------------------------------------------------------------------------------------+
    | r8        |          | The indirect result location register.                                                             |
    +-----------+----------+----------------------------------------------------------------------------------------------------+
    | r0-r7     |          | Parameter/result registers.                                                                        |
    +-----------+----------+----------------------------------------------------------------------------------------------------+


The first eight registers, r0-r7, are used to pass argument values into a subroutine and to return result values from a function. They may also be used to hold intermediate values within a routine (but, in general, only between subroutine calls).

In AAPCS64-cap the r9 register is used to pass anonymous arguments in variadic calls.

Registers r16 (IP0/CIP0) and r17 (IP1/CIP1) may be used by a linker as a scratch register between a routine and any subroutine it calls (for details, see `Use of CIP0 and CIP1 by the linker`_). They can also be used within a routine to hold intermediate values between subroutine calls.

The role of register r18 is platform specific. If a platform ABI has need of a dedicated general purpose register to carry inter-procedural state (for example, the thread context) then it should use this register for that purpose. If the platform ABI has no such requirements, then it should use r18 as an additional temporary register. The platform ABI specification must document the usage for this register.

In AAPCS64-cap a subroutine invocation must preserve the contents of the registers r19-r29 and CSP. All 128 bits and the tag bit of each value stored in r19-r29 must be preserved.

In AAPCS64 a subroutine invocation must preserve the contents of the lower 64 bits of registers r19-r29 and SP. There is no requirement to preserve the tag bit.

.. note::

    In AAPCS64 c19-c30 and CSP are not callee-saved, although x19-x30 and SP are callee-saved. It is therefore the responsibility of the caller to save any of the c19-c30 and CSP registers before any call, if these registers are used by the caller.

In all variants of the procedure call standard, registers r16, r17, r29 and r30 have special roles. In these roles they are labelled IP0, IP1, FP and LR when being used for holding addresses (that is, the special name implies accessing the register as a 64-bit entity).

.. note::

    The special register names (IP0/CIP0, IP1/CIP1, FP/CFP and LR/CLR) should be used only in the context in which they are special. It is recommended that disassemblers always use the architectural names for the registers.

Processes, Memory and the Stack
-------------------------------

The Stack in AAPCS64-cap
^^^^^^^^^^^^^^^^^^^^^^^^

The stack is a contiguous area of memory that may be used for storage of local variables and, when there are insufficient argument registers available, for passing additional arguments to subroutines .

The stack implementation is full-descending, with the current extent of the stack held in the special-purpose register CSP. The stack will  have both a base and a limit, and an application can get these values by observing the base and limit of CSP.

The size of the stack is fixed in AAPCS64-cap. This size is encoded in CSP.

AAPCS64-cap has the same rules and constraints for maintenance of the stack as AAPCS64, with the following additional constraints:

- CSP must be a valid capability with the tag set, zero type (unsealed), and the bounds set to stack-base and stack-limit. In this case, stack-base and stack-limit are defined as being the bounds of the CSP capability. The values of stack-base and stack-limit are constrained such that they can form the upper and lower bound of a representable capability.

- CSP must have the Load, Store, LoadCap, StoreCap and MutableLoad permission bits set.

- CSP must have enough permission to be used to store capabilities derived from CSP. This means that CSP should either have at least one of the Global and StoreLocalCap permissions.


The Frame Pointer in AAPCS64-cap
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Conforming code shall construct a linked list of stack-frames. Each
frame shall link to the frame of its caller by means of a frame record
of two capability values on the stack. The frame record for the
innermost frame (belonging to the most recent routine invocation) shall
be pointed to by the Capability Frame Pointer register (CFP).  The lowest
addressed capability shall point to the previous frame record and the
highest addressed capability shall contain the value passed in CLR on
entry to the current function. The end of the frame record chain is
indicated by the NULL capability in the address for the previous frame.
The location of the frame record within a stack frame is not specified.

.. note::
   There will always be a short period during construction or destruction of each frame record during which the frame pointer will point to the caller’s record.

A platform shall mandate the minimum level of conformance with respect to the maintenance of frame records, with the same choices as for AAPCS64.


Subroutine Calls
----------------

The A64 and C64 states contain primitive subroutine call instructions, BL and BLR, which performs a branch-with-link operation. The effect of executing BL is to transfer the sequentially next value of the program counter - the return address - into the link register (LR or CLR) and the destination address into the program counter.  The effect of executing BLR is similar except that the new PC value is constructed from the specified register.


Use of CIP0 and CIP1 by the linker
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The A64 and C64 branch instructions are unable to reach every destination in the address space, so it may be necessary for the linker to insert a veneer between a calling routine and a called subroutine. Veneers may also be needed to support dynamic linking and interworking between A64 and C64. Any veneer inserted must preserve the contents of all registers except CIP0, CIP1 (r16, r17) and the condition code flags; a conforming program must assume that a veneer that alters CIP0 and/or CIP1 may be inserted at any branch instruction that is exposed to a relocation that supports long branches.


Parameter Passing
-----------------

The base standard provides for passing arguments in general-purpose registers (r0-r7), SIMD/floating-point registers (v0-v7) and on the stack. For subroutines that take a small number of small parameters, only registers are used.

Parameter Passing Rules
^^^^^^^^^^^^^^^^^^^^^^^

The parameter passing rules are modified from those shown in the AAPCS64_ document to take into account capabilities.
The marshalling of machine types is the same for AAPCS64 and AAPCS64-cap.

The differences in language bindings used for AAPCS64 and AAPCS64-cap are described in `Types Varying by Data Model and Procedure Calling Standard`_.

.. rubric:: Stage A – Initialization

.. class:: aapcs64-morello-parameter-passing

.. table::

    +------------------------------+------------------------------------------------------------------------------------------+
    |                              | The Next General-purpose Register Number (NGRN) is set to zero.                          |
    |                              |                                                                                          |
    | A.1                          |                                                                                          |
    +------------------------------+------------------------------------------------------------------------------------------+
    |                              | The Next SIMD and Floating-point Register Number (NSRN) is set to zero.                  |
    |                              |                                                                                          |
    | A.2                          |                                                                                          |
    +------------------------------+------------------------------------------------------------------------------------------+
    |                              | The next stacked argument address (NSAA) is set to the current stack-pointer value (SP). |
    |                              |                                                                                          |
    | A.3                          |                                                                                          |
    +------------------------------+------------------------------------------------------------------------------------------+
    |                              | If the callee is variadic in AAPCS64-cap, the Anonymous Arguments Memory area is         |
    |                              | allocated in memory with a size of at least 16 * (number of Anonymous arguments) bytes.  |
    |                              | The Anonymous Arguments Memory area is 16-byte aligned. The Anonymous Arguments          |
    |                              | Capability points to the Anonymous Arguments Memory area and is copied to C9. If there   |
    | A.4                          | are no Anonymous arguments passed, C9 is set to NULL.                                    |
    +------------------------------+------------------------------------------------------------------------------------------+
    |                              | The Anonymous Arguments Index (AArgsIdx) is set to zero.                                 |
    |                              |                                                                                          |
    | A.5                          |                                                                                          |
    +------------------------------+------------------------------------------------------------------------------------------+


.. rubric:: Stage B – Pre-padding and extension of arguments

.. class:: aapcs64-morello-parameter-passing

.. table::

    +------------------------------+----------------------------------------------------------------------------------------+
    |                              | If the argument type is a Composite Type whose size cannot be statically determined by |
    |                              | both the caller and the callee, the argument is copied to memory and the argument is   |
    | B.1                          | replaced by a pointer to the copy in AAPCS64 or a capability to the copy in            |
    |                              | AAPCS64-cap. (There are no such types in C/C++ but they exist in other languages or in |
    |                              | language extensions).                                                                  |
    +------------------------------+----------------------------------------------------------------------------------------+
    |                              | If the argument is Anonymous in AAPCS64-cap and the size or alignment of the argument  |
    |                              | is larger than 16, the argument is copied to memory and the argument is replaced by a  |
    | B.2                          | capability to the copy.                                                                |
    |                              |                                                                                        |
    |                              |                                                                                        |
    |                              |                                                                                        |
    +------------------------------+----------------------------------------------------------------------------------------+
    |                              | If the argument is Anonymous in AAPCS64 and the argument type is a capability or       |
    | B.3                          | the argument type is a Composite Type which contains capabilities, the argument is     |
    |                              | copied to memory and the argument is replaced by a pointer to the copy.                |
    +------------------------------+----------------------------------------------------------------------------------------+
    |                              | If the argument type is an HFA or an HVA, then the argument is used unmodified.        |
    |                              |                                                                                        |
    | B.4                          |                                                                                        |
    +------------------------------+----------------------------------------------------------------------------------------+
    |                              | If the argument type is a Composite Type which does not contain capabilities that is   |
    |                              | larger than 16 bytes, then the argument is copied to memory allocated by the caller    |
    |                              | and the argument is replaced by a pointer to the copy in AAPCS64 or a capability to    |
    | B.5                          | the copy in AAPCS64-cap.                                                               |
    +------------------------------+----------------------------------------------------------------------------------------+
    |                              | If the argument type is a Composite Type then the size of the argument is rounded up   |
    |                              | to the nearest multiple of 8 bytes.                                                    |
    | B.6                          |                                                                                        |
    +------------------------------+----------------------------------------------------------------------------------------+
    |                              | If the argument is a Composite Type containing Capabilities and the size is larger     |
    |                              | than 32 bytes or there are addressable members which are not Capabilities that overlap |
    | B.7                          | bytes 8-15 or 24-31 of the argument (if such bytes exist) then the argument is copied  |
    |                              | to memory allocated by the caller and the argument is replaced by a pointer to the     |
    |                              | copy in AAPCS64 or a capability to a copy in AAPCS64-cap.                              |
    +------------------------------+----------------------------------------------------------------------------------------+
    |                              | If the argument is an alignment adjusted type its value is passed as a copy of the     |
    |                              | actual value. The copy will have an alignment defined as follows.                      |
    | B.8                          |                                                                                        |
    |                              | - For a Fundamental Data Type, the alignment is the natural alignment of that type,    |
    |                              |   after any promotions.                                                                |
    |                              |                                                                                        |
    |                              | - For a Composite Type, the alignment of the copy will have 8-byte alignment if its    |
    |                              |   natural alignment is <= 8 and 16-byte alignment if its natural alignment is >= 16.   |
    |                              |                                                                                        |
    |                              | The alignment of the copy is used for applying marshalling rules.                      |
    +------------------------------+----------------------------------------------------------------------------------------+


.. rubric:: Stage C – Assignment of arguments to registers and stack

.. class:: aapcs64-morello-parameter-passing

.. table::

    +-------------------------------+----------------------------------------------------------------------------------------+
    | C.1                           | If the argument is Anonymous in AAPCS64-cap and its size is less than 16 bytes, the    |
    |                               | size of the argument is set to 16 bytes. The effect is as if the argument was copied   |
    |                               | to the least significant bits of a 128-bit register and the remaining bits filled with |
    |                               | unspecified values.                                                                    |
    +-------------------------------+----------------------------------------------------------------------------------------+
    |                               | If the argument is Anonymous in AAPCS64-cap the argument is copied to memory at an     |
    | C.2                           | offset of (AArgsIdx * 16) bytes into the Anonymous Arguments Memory area. The          |
    |                               | Anonymous Arguments Index is incremented by one. The argument has now been allocated.  |
    +-------------------------------+----------------------------------------------------------------------------------------+
    |                               | If the argument is a Half-, Single-, Double- or Quad- precision Floating-point or      |
    |                               | Short Vector Type and the NSRN is less than 8, then the argument is allocated to the   |
    | C.3                           | least significant bits of register v[NSRN]. The NSRN is incremented by one. The        |
    |                               | argument has now been allocated.                                                       |
    +-------------------------------+----------------------------------------------------------------------------------------+
    |                               | If the argument is an HFA or an HVA and there are sufficient unallocated SIMD and      |
    |                               | Floating-point registers (NSRN + number of members <= 8), then the argument is         |
    | C.4                           | allocated to SIMD and Floating-point Registers (with one register per member of the    |
    |                               | HFA or HVA). The NSRN is incremented by the number of registers used. The argument has |
    |                               | now been allocated.                                                                    |
    +-------------------------------+----------------------------------------------------------------------------------------+
    |                               | If the argument is an HFA or an HVA then the NSRN is set to 8 and the size of the      |
    |                               | argument is rounded up to the nearest multiple of 8 bytes.                             |
    | C.5                           |                                                                                        |
    +-------------------------------+----------------------------------------------------------------------------------------+
    |                               | If the argument is an HFA, an HVA, a Quad-precision Floating-point or Short Vector     |
    |                               | Type then the NSAA is rounded up to the larger of 8 or the Natural Alignment of the    |
    | C.6                           | argument type.                                                                         |
    +-------------------------------+----------------------------------------------------------------------------------------+
    |                               | If the argument is a Half- or Single- precision Floating Point type, then the size of  |
    |                               | the argument is set to 8 bytes. The effect is as if the argument had been copied to    |
    | C.7                           | the least significant bits of a 64-bit register and the remaining bits filled with     |
    |                               | unspecified values.                                                                    |
    +-------------------------------+----------------------------------------------------------------------------------------+
    |                               | If the argument is an HFA, an HVA, a Half-, Single-, Double- or Quad- precision        |
    |                               | Floating-point or Short Vector Type, then the argument is copied to memory at the      |
    | C.8                           | adjusted NSAA. The NSAA is incremented by the size of the argument. The argument has   |
    |                               | now been allocated.                                                                    |
    +-------------------------------+----------------------------------------------------------------------------------------+
    |                               | If the argument is an Integral or Pointer Type, the size of the argument is less than  |
    |                               | or equal to 8 bytes and the NGRN is less than 8, the argument is copied to the least   |
    | C.9                           | significant bits in x[NGRN]. The NGRN is incremented by one. The argument has now been |
    |                               | allocated.                                                                             |
    +-------------------------------+----------------------------------------------------------------------------------------+
    |                               | If the argument is a Capability Type or a Composite Type containing Capabilities, and  |
    |                               | the size of the argument in bytes is less than or equal to 16 * (8 minus NGRN), the    |
    | C.10                          | argument is passed as though it had been loaded into capability registers starting     |
    |                               | from a 16-byte aligned address with an appropriate sequence of capability loading      |
    |                               | instructions loading consecutive capability values from memory, starting from c[NGRN]. |
    |                               | The NGRN is incremented by the number of capability registers used to hold the         |
    |                               | argument. The argument has now been allocated.                                         |
    +-------------------------------+----------------------------------------------------------------------------------------+
    |                               | If the argument is not a Capability Type and is not a Composite Type containing        |
    |                               | Capability Types and has an alignment of 16 then the NGRN is rounded up to the next    |
    | C.11                          | even number.                                                                           |
    |                               |                                                                                        |
    +-------------------------------+----------------------------------------------------------------------------------------+
    |                               | If the argument is an Integral Type, the size of the argument is equal to 16 and the   |
    |                               | NGRN is less than 7, the argument is copied to x[NGRN] and x[NGRN+1]. x[NGRN] shall    |
    | C.12                          | contain the lower addressed double-word of the memory representation of the argument.  |
    |                               | The NGRN is incremented by two. The argument has now been allocated.                   |
    +-------------------------------+----------------------------------------------------------------------------------------+
    |                               | If the argument is a Composite Type which does not contain Capability Types and the    |
    |                               | size in double-words of the argument is not more than 8 minus NGRN, then the argument  |
    | C.13                          | is copied into consecutive general-purpose registers, starting at x[NGRN]. The         |
    |                               | argument is passed as though it had been loaded into the registers from a double-word- |
    |                               | aligned address with an appropriate sequence of LDR instructions loading consecutive   |
    |                               | registers from memory (the contents of any unused parts of the registers are           |
    |                               | unspecified by this standard). The NGRN is incremented by the number of registers      |
    |                               | used. The argument has now been allocated.                                             |
    +-------------------------------+----------------------------------------------------------------------------------------+
    |                               | The NGRN is set to 8.                                                                  |
    |                               |                                                                                        |
    | C.14                          |                                                                                        |
    +-------------------------------+----------------------------------------------------------------------------------------+
    |                               | The NSAA is rounded up to the larger of 8 or the Natural Alignment of the argument's   |
    |                               | type.                                                                                  |
    | C.15                          |                                                                                        |
    +-------------------------------+----------------------------------------------------------------------------------------+
    |                               | If the argument is a composite type then the argument is copied to memory at the       |
    |                               | adjusted NSAA. The NSAA is incremented by the size of the argument. The argument has   |
    | C.16                          | now been allocated.                                                                    |
    +-------------------------------+----------------------------------------------------------------------------------------+
    |                               | If the size of the argument is less than 8 bytes then the size of the argument is set  |
    |                               | to 8 bytes. The effect is as if the argument was copied to the least significant bits  |
    | C.17                          | of a 64-bit register and the remaining bits filled with unspecified values.            |
    +-------------------------------+----------------------------------------------------------------------------------------+
    |                               | The argument is copied to memory at the adjusted NSAA.  The NSAA is incremented by the |
    |                               | size of the argument. The argument has now been allocated.                             |
    | C.18                          |                                                                                        |
    +-------------------------------+----------------------------------------------------------------------------------------+

.. note::

    In AAPCS64-cap if the callee is variadic and there are fewer than 4096 Anonymous arguments, the length of C9 divided by 16 is equal to the number of Anonymous arguments. The length of C9 divided by 16 is always greater or equal to the number of Anonymous arguments.

Result Return
-------------

The manner in which a result is returned from a function is determined by the type of that result:

- If the type, T, of the result of a function is such that

  ``void func(T arg)``

  would require that arg be passed as a value in a register (or set of registers) according to the rules in `Parameter Passing`_, then the result is returned in the same registers as would be used for such an argument.

- Otherwise, the caller shall reserve a block of memory of sufficient size and alignment to hold the result. The address of the memory block shall be passed as an additional argument to the function in x8 in AAPCS64 and c8 in AAPCS64-cap. The callee may modify the result memory block at any point during the execution of the subroutine (there is no requirement for the callee to preserve the value stored in r8).


Interworking
------------

Interworking between the 32-bit AAPCS and the AAPCS64 or AAPCS64-cap is not supported within a single process. (In AArch64, all inter-operation between 32-bit and 64-bit machine states takes place across a change of exception level).

Interworking between data model variants of AAPCS64 (although technically possible) is not defined within a single process.

Interworking between AAPCS64 and AAPCS64-cap is not supported.

Interworking between A64 and C64 states is supported. The linker will insert a veneer at direct branches between different states. The veneer will perform both the state switch and range extensions. It is the responsibility of the callee to switch state on return.

.. raw:: pdf

   PageBreak

Arm C AND C++ Language Mappings
===============================

This section describes how Arm compilers map C language features onto the machine-level standard. To the extent that C++ is a superset of the C language it also describes the mapping of C++ language features.

Data Types
----------

Types Varying by Data Model and Procedure Calling Standard
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The AAPCS64-cap uses different language mappings for any C/C++ Type that would be a code or data pointer in AAPCS64, while keeping
other data types the same.

These differences, and new Morello-specific data types are shown in `C/C++ type variants by data model and PCS`_.

.. _C/C++ type variants by data model and PCS:

.. class:: aapcs64-morello-c-cpp-type-variants

.. table:: C/C++ type variants by data model and PCS

    +-----------------------------+--------------------------------------------------------------+------------------------------+
    | C/C++ Type                  | Machine Type                                                 | Notes                        |
    +-----------------------------+-------------------------------------+------------------------+------------------------------+
    |                             | AAPCS64-cap                         | AAPCS64                |                              |
    +=============================+=====================================+========================+==============================+
    | ``T *``                     | Data Capability                     | 64-bit data pointer    | Any data type ``T``.         |
    +-----------------------------+-------------------------------------+------------------------+------------------------------+
    | ``T (*F)()``                | Code Capability                     | 64-bit code pointer    | Any function type ``F``.     |
    +-----------------------------+-------------------------------------+------------------------+------------------------------+
    | ``T&``                      | Data Capability                     | 64-bit data pointer    | C++ reference.               |
    +-----------------------------+-------------------------------------+------------------------+------------------------------+
    | ``T * __capability``        | Data Capability                     | 64-bit data pointer    | Any data type ``T``.         |
    +-----------------------------+-------------------------------------+------------------------+------------------------------+
    | ``T (* __capability F)()``  | Code Capability                     | 64-bit code pointer    | Any function type ``F``.     |
    +-----------------------------+-------------------------------------+------------------------+------------------------------+
    | ``T& __capability``         | Data Capability                     | 64-bit data pointer    | C++ reference.               |
    +-----------------------------+-------------------------------------+------------------------+------------------------------+


Definition of va_list in AAPCS64-cap
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The definition of ``va_list`` has implications for the internal implementation in the compiler. An AAPCS64-cap conforming object must use the definitions shown in `va\_list definition`_.

.. _va\_list definition:

.. table:: va_list definition

    +-------------------+------------------------+------------------------------------------------------------+
    | Typedef           | Base type              | Notes                                                      |
    +===================+========================+============================================================+
    |                   | .. code-block:: c      |                                                            |
    |                   |                        |                                                            |
    |  ``va_list``      |    void *              | A ``va_list`` may address any object in a parameter list.  |
    |                   |                        | In C++, ``__va_list`` is in namespace ``std``.             |
    |                   |                        | See `APPENDIX Variable argument Lists in AAPCS64-cap`_.    |
    |                   |                        |                                                            |
    +-------------------+------------------------+------------------------------------------------------------+


.. raw:: pdf

   PageBreak

APPENDIX Variable argument Lists in AAPCS64-cap
===============================================

Languages such as C and C++ permit routines that take a variable number of arguments (that is, the number of parameters is controlled by the caller rather than the callee). Furthermore, they may then pass some or even all of these parameters as a block to further subroutines to process the list. If a routine shares any of its optional arguments with other routines then a parameter control block needs to be created. The remainder of this appendix is informative.


The va_list type
----------------

The ``va_list`` type may refer to any parameter in a parameter list. All Anonymous parameters are passed on the stack in AAPCS64-cap.

.. code-block:: c

    typedef void * va_list;

The va_start() macro
--------------------

The ``va_start`` macro shall initialize the ``va_list`` argument to the value of C9 as seen in the entry of the callee.

The va_arg() macro
------------------

The algorithm to implement the generic ``va_arg(ap,type)`` macro is then most easily described using a C-like "pseudocode", as follows:

.. code-block:: c

    type va_arg (va_list ap, type)
    {
        void *arg = ap;
        if (alignof(type) > 16 || sizeof(type) > 16)
            arg = *(void **)arg;
        ap = (void **)ap + 1;
        return *(type *)arg;
    }

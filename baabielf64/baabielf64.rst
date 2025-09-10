..
   Copyright (c) 2025, Arm Limited and its affiliates.  All rights reserved.
   CC-BY-SA-4.0 AND Apache-Patent-License
   See LICENSE file for details

.. |release| replace:: 2025Q1
.. |date-of-issue| replace:: 07\ :sup:`th` April 2025
.. |copyright-date| replace:: 2025
.. |footer| replace:: Copyright © |copyright-date|, Arm Limited and its
                      affiliates. All rights reserved.

.. _AAELF64: https://github.com/ARM-software/abi-aa/releases
.. _SYSVABI64: https://github.com/ARM-software/abi-aa/releases
.. footer::

   ###Page###

   |

   Copyright © |copyright-date|, Arm Limited and its affiliates. All rights
   reserved.

AArch64 ELF Conventions for Binary Analysis
*******************************************

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

Abstract
--------

This document specifies code patterns and ELF conventions for AArch64 binaries, enabling Binary Analysis tools to recognize them more easily.

Keywords
--------

ELF, AArch64 ELF, Binary Analysis tools

Latest release and defects report
---------------------------------

Please check `AArch64 ELF Conventions for Binary Analysis
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
   Arm considers this specification to have enough
   implementations, which have received sufficient testing, to verify
   that it is correct. The details of these criteria are dependent on
   the scale and complexity of the change over previous versions:
   small, simple changes might only require one implementation, but
   more complex changes require multiple independent implementations,
   which have been rigorously tested for cross-compatibility. Arm
   anticipates that future changes to this specification will be
   limited to typographical corrections, clarifications and compatible
   extensions.

**Beta**
   Arm considers this specification to be complete, but existing
   implementations do not meet the requirements for confidence in its release
   quality. Arm may need to make incompatible changes if issues emerge from its
   implementation.

**Alpha**
   The content of this specification is a draft, and Arm considers the
   likelihood of future incompatible changes to be significant.

This document is at **Alpha** release quality.

Change history
^^^^^^^^^^^^^^

If there is no entry in the change history table for a release, there are no
changes to the content of the document for that release.

.. table::

  +------------+------------------------------+------------------------------------------------------------------+
  | Issue      | Date                         | Change                                                           |
  +============+==============================+==================================================================+
  | 0.1        | 10\ :sup:`st` September 2025 | Alpha draft release.                                             |
  +------------+------------------------------+------------------------------------------------------------------+

References
----------

This document refers to the following documents.

.. table::

  +---------------------+--------------------------------------------------------------+----------------------------------------------------------------------------+
  | Ref                 | URL or other reference                                      | Title                                                                       |
  +=====================+=============================================================+=============================================================================+
  | AAELF64_            | IHI 0056                                                    | ELF for the Arm 64-bit Architecture                                         |
  +---------------------+-------------------------------------------------------------+-----------------------------------------------------------------------------+
  | SYSVABI64_          | sysvabi64                                                   | System V Application Binary Interface (ABI) for the Arm 64-bit Architecture |
  +---------------------+-------------------------------------------------------------+-----------------------------------------------------------------------------+

Terms and abbreviations
-----------------------

AArch64 ELF Conventions for Binary Analysis document uses the following terms
and abbreviations:

GOT
   Global offset table. It holds addresses of symbols referenced from code,
   containing both link-time constants and entries updated by dynamic relocation.

.got.plt
   The part of GOT containing symbol addresses referenced by
   Procedure Linkage Table (PLT) entries.

R_AARCH64_PREL64
   The 64-bit PC-relative relocation defined by AAELF64_, computes S + A – P,
   where S denotes the symbol address, A the addend, and P the address of the
   relocation place. It is widely used to refence symbols through literal pool.

Other terms may be defined when first used.

.. raw:: pdf

   PageBreak

AArch64 Veneer Types Recognized by Binary Analysis Tools
========================================================

As described in AAELF64_, section Call and Jump relocations, the linker may insert veneers (also referred to as thunks, stubs or trampolines) to implement call and jump relocations. This section defines the commonly used types and instruction sequences for such veneers on AArch64, enabling better recognition by binary analysis tools.

Toolchains are encouraged to follow these patterns to ensure veneers can be reliably recognized during binary analysis. These pattern sets are intended to remain open, and toolchains may introduce new veneer forms.

Additionally, if veneers emit static relocations, they become indistinguishable from regular code. In such cases, binary analysis tools should rely on relocation information to identify veneer targets.

__AArch64AbsLongThunk_ Long-Range Veneers
-----------------------------------------

A 64-bit absolute target address is loaded from a literal pool into a register, and an indirect branch is used to transfer control to the target::

  <caller>:
    B/BL __AArch64AbsLongThunk_<target>

  __AArch64AbsLongThunk_<target>:
    LDR X16, =<target>
    BR  X16

Where ``<target>`` denotes the ultimate branch destination.

Position independent version may also be used::

  <caller>:
    B/BL __<target>_veneer

  __<target>_veneer:
    LDR X16, 1f
    ADR X17, #0
    ADD X16, X16, X17
    BR  X16
  1:
    .xword R_AARCH64_PREL64(<target>) + 12

__AArch64AbsXOLongThunk_ and Execute-Only Compatible Veneers
------------------------------------------------------------

For sections containing only program instructions and no program data, an absolute 64-bit target address is constructed using immediate instructions::

  <caller>:
    B/BL __AArch64AbsXOLongThunk_<target>

  __AArch64AbsXOLongThunk_<target>:
    MOVZ X16, #:abs_g0_nc:<target>
    MOVK X16, #:abs_g1_nc:<target>, LSL #16
    MOVK X16, #:abs_g2_nc:<target>, LSL #32
    MOVK X16, #:abs_g3:<target>,    LSL #48
    BR   X16

Note that some of the MOVK instructions may be omitted if their corresponding 16-bit segments of the address are zero and do not need to be explicitly set.

The following alternative instruction sequence may be emitted to materialize an absolute 64-bit address::

  <caller>:
    B/BL $thunk<decimal suffix>

  $thunk<decimal suffix>:
    ADR  X16, #:abs_g0_nc:<target>
    MOVK X17, #:abs_g1_nc:<target>, LSL #16
    MOVK X17, #:abs_g2_nc:<target>, LSL #32
    MOVK X17, #:abs_g3:<target>,    LSL #48
    ADD  X16, X16, X17
    BR   X16

__AArch64Abs[XO]LongThunk_ Short-Range Veneers
----------------------------------------------

When the target is within range of a direct branch, the linker may generate a simple short-range branch veneer under the same name. The optional infix ``XO`` identifies execute-only variants::

  __AArch64Abs[XO]LongThunk_<target>:
    B <target>

__AArch64ADRPThunk_ Position-Independent Veneers
------------------------------------------------

PC-relative veneer is generated using ADRP and ADD::

  <caller>:
    B/BL __AArch64ADRPThunk_<target>

  __AArch64ADRPThunk_<target>:
    ADRP X16, <target>
    ADD  X16, X16, :lo12:<target>
    BR   X16

Recognized by alternative names: ``__<target>_veneer``, ``$thunk<decimal suffix>``, ``<hexadecimal prefix>-tramp<decimal suffix>``

When the .got.plt entry for the <target> is known to exist an direct load from GOT may be used::

  <caller>:
    B/BL <hexadecimal prefix>-tramp<decimal suffix>

  <hexadecimal prefix>-tramp<decimal suffix>:
    ADRP X16, :got:<target>
    LDR  X16, [X16, :got_lo12:<target>]
    BR   X16


__AArch64BTIThunk_ BTI Landing Pad Veneers
------------------------------------------

When Branch Target Identification (BTI) is enabled, any of the veneers above may route through an additional landing pad veneer ``__AArch64BTIThunk_<target>``. The rules governing generation of these veneers are specified in SYSVABI64_, section Tool Requirements for generating BTI instructions. Landing pad veneer begins with a BTI instruction to ensure a valid landing and then branches to the target::

  __AArch64BTIThunk_<target>:
    BTI C
    B <target>

In cases where the veneer is placed immediately before the target, the B instruction may be omitted::

  __AArch64BTIThunk_<target>:
    BTI C
  <target>:

Recognized by alternative names: ``__<target>_bti_veneer``
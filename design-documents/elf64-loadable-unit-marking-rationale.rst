..
   Copyright (c) 2023, Arm Limited and its affiliates.  All rights reserved.
   CC-BY-SA-4.0 AND Apache-Patent-License
   See LICENSE file for details

.. |copyright-date| replace:: 2023

.. _AAELF32: https://github.com/ARM-software/abi-aa/releases
.. _AAELF64: https://github.com/ARM-software/abi-aa/releases
.. _ACLEMULTIVERSION: https://arm-software.github.io/acle/main/acle.html#function-multi-versioning
.. _ARMARM: https://developer.arm.com/documentation/ddi0487/latest
.. _ADDENDA32: https://github.com/ARM-software/abi-aa/releases
.. _ARMV8V9: https://developer.arm.com/documentation/102378/0201/Armv8-x-and-Armv9-x-extensions-and-features
.. _BUILDATTR64: https://github.com/ARM-software/abi-aa/releases
.. _GCCOPTS: https://gcc.gnu.org/onlinedocs/gcc/AArch64-Options.html
.. _LINUX_ABI: https://github.com/hjl-tools/linux-abi/wiki/Linux-Extensions-to-gABI
.. _HWCAPS: https://docs.kernel.org/arch/arm64/elf_hwcaps.html
.. _PAUTHABI64: https://github.com/ARM-software/abi-aa/releases
.. _SYSVABI64: https://github.com/ARM-software/abi-aa/
.. _X86_64PSABI: https://raw.githubusercontent.com/wiki/hjl-tools/x86-psABI/x86-64-psABI-draft.pdf

Design Rationale for Loadable-unit marking for Arm 64-bit Architecture (AARCH64)
********************************************************************************

Preamble
========

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

.. raw:: pdf

   PageBreak

.. contents::
   :depth: 3

.. raw:: pdf

   PageBreak

Copyright
---------

Copyright (c) |copyright-date|, Arm Limited and its affiliates.  All rights reserved.

Change history
^^^^^^^^^^^^^^

If there is no entry in the change history table for a release, there are no
changes to the content of the document for that release.

.. table::

  +------------+---------------------+------------------------------------------------------------------+
  | Issue      | Date                | Change                                                           |
  +============+=====================+==================================================================+
  | 0.1        | 24th October 2023   | First draft                                                      |
  +------------+---------------------+------------------------------------------------------------------+

References
----------

This document refers to, or is referred to by, the following documents.

.. table::

  +-----------------------------------------------------------------------------------------+-------------------------------------------------------------+-------------------------------------------------------------------------------+
  | Ref                                                                                     | URL or other reference                                      | Title                                                                         |
  +=========================================================================================+=============================================================+===============================================================================+
  | ADDENDA32_                                                                              | IHI 0045                                                    | Addenda to, and errata in, the ABI for the Arm Architecture                   |
  +-----------------------------------------------------------------------------------------+-------------------------------------------------------------+-------------------------------------------------------------------------------+
  | ARMARM_                                                                                 | ddi0487                                                     | Arm Architecture Reference Manual for A-profile architecture                  |
  +-----------------------------------------------------------------------------------------+-------------------------------------------------------------+-------------------------------------------------------------------------------+
  | AAELF32_                                                                                |                                                             | ELF for the Arm 32-bit Architecture                                           |
  +-----------------------------------------------------------------------------------------+-------------------------------------------------------------+-------------------------------------------------------------------------------+
  | AAELF64_                                                                                | IHI 0056                                                    | ELF for the Arm 64-bit Architecture                                           |
  +-----------------------------------------------------------------------------------------+-------------------------------------------------------------+-------------------------------------------------------------------------------+
  | ACLEMULTIVERSION_                                                                       |                                                             | Arm C Library Extensions function-multi-versioning                            |
  +-----------------------------------------------------------------------------------------+-------------------------------------------------------------+-------------------------------------------------------------------------------+
  | ARMV8V9_                                                                                |                                                             | Armv8.x and Armv9.x extensions and features                                   |
  +-----------------------------------------------------------------------------------------+-------------------------------------------------------------+-------------------------------------------------------------------------------+
  | BUILDATTR64_                                                                            |                                                             | Build Attributes for the Arm 64-bit Architecture                              |
  +-----------------------------------------------------------------------------------------+-------------------------------------------------------------+-------------------------------------------------------------------------------+
  | GCCOPTS_                                                                                |                                                             | GCC AArch64 Options                                                           |
  +-----------------------------------------------------------------------------------------+-------------------------------------------------------------+-------------------------------------------------------------------------------+
  | HWCAPS_                                                                                 |                                                             | ARM64 ELF hwcaps                                                              |
  +-----------------------------------------------------------------------------------------+-------------------------------------------------------------+-------------------------------------------------------------------------------+
  | LINUX_ABI_                                                                              |                                                             | Linux extensions to GABI                                                      |
  +-----------------------------------------------------------------------------------------+-------------------------------------------------------------+-------------------------------------------------------------------------------+
  | PAUTHABI64_                                                                             | DDI 0487                                                    | PAuth ABI Extension to ELF for the 64-bit Architecture                        |
  +-----------------------------------------------------------------------------------------+-------------------------------------------------------------+-------------------------------------------------------------------------------+
  | SYSVABI64_                                                                              |                                                             | System V Application Binary Interface (ABI) for the Arm 64-bit Architecture   |
  +-----------------------------------------------------------------------------------------+-------------------------------------------------------------+-------------------------------------------------------------------------------+
  | X86_64PSABI_                                                                            |                                                             | System V Application Binary Interface AMD64 Architecture Processor Supplement |
  +-----------------------------------------------------------------------------------------+-------------------------------------------------------------+-------------------------------------------------------------------------------+

. raw:: pdf

   PageBreak

Scope
=====

This document contains the design rationale for using GNU properties
in ELF loadable-units on SystemV platforms as a means to communicate
requirements on the execution unit, or the compatibility of the
loadable-unit with optional platform features. It also contains some
guidelines for future use of GNU properties.

Nothing in this document is part of the specification. Any
contradictions between this rationale and the specification shall be
resolved in favor of the specification.

This document assumes that the reader is familiar with GNU properties
as defined by (LINUX_ABI_), and the AArch64 specific properties
defined in (SYSVABI64_).

.. raw:: pdf

   PageBreak

Introduction
============

In a SystemV environment, programs are made up of one of more ELF
files, an executable and zero or more shared-libraries which may be
registered as dependencies via ``DT_NEEDED`` tags or may be loaded at
run time as a result of a ``dlopen`` call.

The 64-bit ABI assumes that the majority of AArch64 software is
deployed on software platforms running a rich OS such as those
described in (SYSVABI64_). Software platforms have a stable platform
interface and run on a wide variety of hardware with different
capabilities. AArch64 software frequently uses runtime feature
detection so that it can run everywhere, but take advantage of newer
hardware features when they are available. This can be accomplished by
existing ELF features such as GNU indirect functions without the
program loader taking any additional action.

A number of features require that a property is enforced across one or
more loadable-units where a loadable-unit is defined to be a single
executable or shared library before a feature can be enabled.

An example of a feature that must enforce a property across a
loadable-unit is branch target identification (BTI). When this feature
is enabled for a loadable-unit all indirect branch targets in the
loadable-unit must have a BTI compatible landing pad.

A feature may also require use of an architectural extension in a
sufficient number of functions that would make runtime selection of
function implementations impractical. For example an implementation of
the pointer authentication ABI (PAuthABI64_) requires all functions in
the program to agree on the signing schema.

To permit an ELF loader to reason about feature compatibility and take
extra actions as a result of features some additional metadata must be
recorded in the ELF file. This document will use the team ELF
loadable-unit marking scheme to describe the metadata.

Design Goals
============

The design goals of an ELF marking scheme are:

- Utilize existing ELF marking standards where possible.  Platforms
  may already have an implementation existing standards that can be
  adapted.

- The ELF loadable-unit marking scheme must be easy for a program
  loader to locate.

- The ELF loadable-unit marking scheme must be simple and fast for a
  program loader to process.

- The ELF loadable-unit marking scheme must be easy for a static
  linker to write given a relocatable-object marking scheme, or a
  command-line options.

- Separate out the requirements on the execution environment such as
  hardware requirements from compatibility with optional features that
  may be enabled.

Executive Summary
=================

The SystemV ABI for the Arm 64-bit architecture (SYSVABI64_) will use
GNU program properties in executables and shared-libraries to
communicate architectural and ABI properties to the execution
environment.

GNU program properties
======================

GNU program properties are a linux extension defined in
(``LINUX_ABI_``). They are encoded in ``SHT_NOTE`` sections with a
name of ``.note.GNU.property``. There are generic properties common to
all targets defined in (``LINUX_ABI_``) as well as processor specific
properties with values between ``GNU_PROPERTY_LOPROC`` and
``GNU_PROPERTY_HIPROC``.

A static linker is expected to read in each in ``.note.GNU.property``
section which contains an array of program properties. The data format
and combination rules for each program property is specified by the
program property itself.

Program properties in the output ELF file may also be set by other
means.  For example a static linker command line option may be used to
override or influence the combination rules. Furthermore information
to set the output program properties may come from another relocatable
object property description format like build attributes
(BUILDATTR64_).

If program properties are present in the output ELF file static
linkers are expected to create a ``PT_GNU_PROPERTY`` program header
that desribes the location of the program properties to a program
loader. See (``LINUX_ABI_``) for details.

Scope of GNU program properties in the AArch64 ABI
--------------------------------------------------

As a Linux extension defined by (``LINUX_ABI_``) the AArch64 use of
program properties is required for the Linux platform. Other platforms
can choose their own alternative method of encoding program
properties. The SystemV ABI for the Arm 64-bit Architecture
(SYSVABI64_) will be used to document the properties rather than ELF
for the 64-bit Arm Architecture (AAELF64_) as this document is more
specific to platforms that load ELF files directly.

Relocatable objects may use a different way to encode properties such
as build attributes (BUILDATTR64_).

Guidance on defining AArch64 GNU program properties
---------------------------------------------------

The scope of this guidance is AArch64 program properties in the range
``GNU_PROPERTY_LOPROC`` to ``GNU_PROPERTY_HIPROC``.

For reference the x86_64 program properies are defined in
``X86_64PSABI_``.

Data format
^^^^^^^^^^^

The data format for each program property is implementation
defined. It can be as simple as an integer containing feature bits, to
a ULEB128 encoded format like the Arm Build Attributes.

To limit the overhead of processing by the dynamic linker, keeping the
program properties as simple as possible is recommended. For example a
single integer containing feature bits.

Modelling features in program properties
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

AArch64 Architectural features
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The baseline for AArch64 Linux programs is the 64-bit Arm v8
architecture. Additional features on top of Arm v8 are described by
the ``ARMARM_`` as features, which may be optional or mandatory for a
particular architecture extension like Arm v8.2-A. Features can be
back-ported to older extensions so it is not possible to just record
the architecture extension. The baseline and additional features is
sufficient.

This includes Arm v9-A which is not always a superset of Arm v8-A. For
example Armv8.8-A may have features that Armv9.0-A does not. See
(ARMV8V9_) for a mapping of Arm v8.x to Arm v9.y.

The architectural features need to be modelled as a baseline + list of
features.

At some future point a new baseline for Linux may be agreed upon that
can be recorded in a property.

Focus on userspace architectural features
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Userspace programs are expected to be portable between software
platforms running on different hardware.  Platform specific software
can be customized for the hardware that it runs on.

Only require features that can't be tested at runtime
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

A majority of AArch64 features are amenable to runtime testing, with
different functions in a program being called based on the
capabilities of the platform. On linux userspace programs can test for
features using ``HWCAPS_``. If a program has used runtime testing to
check that a feature is available then we must not record in a program
property that the feature is required.

A corollary is that we do not need to model all of the AArch64
architectural features. Only those that are not amenable to runtime
testing and are actively needed by userspace software.

Hint space optional features
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Some features, usually security features, can be implemented in a
backwards compatible way using the HINT space. If the feature is not
present or not enabled the HINT space instructions execute as a NOP.

A feature that only uses the HINT space, by definition, does not have
any hardware requirements. The feature may require that the program
loader take some action such as enabling the Guard Page (GP) bit for
programs that have the ``GNU_PROPERTY_AARCH64_FEATURE_1_BTI`` set.

A separate program property is required for features that can be
optionally enabled.

Representing features in properties
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

There are a number of possible sources of architectural features that
a GNU property could be based on:

- The Arm Architecture Reference Manual (``ARMARM_``) describes
  features individually in the form of FEAT_<feature> such as
  ``FEAT_BTI`` and ``FEAT_PAUTH``. Some features are independent and
  some are linked, for example ``FEAT_FPAC`` can only be implemented
  if ``FEAT_PAUTH2`` is implemented.

- Linux HWCAPS (HWCAPS_). These often map to functionality exposed by
  a particular ID register.

- Compiler command line ``-march`` and ``-mcpu`` features such as
  ``+sve`` (GCCOPTS_).

- Function multi-versioning attributes (ACLEMULTIVERSION_). This uses
  similar names to compiler ``-march`` and ``-mcpu`` features.

While the ``ARMARM_`` is the canonical reference for the
architecture. Many of the features have no effect on
code-generation. Choosing a model that is as close to the compiler
command line ``-march`` and ``-mcpu`` will be easiest for a software
developer to understand.

Arm v8-R
~~~~~~~~

Armv8-R is based on Arm v8.4-A. For linux user space programs this can
be modelled as the Arm v8 baseline with the additional features
required by Armv8-R. In the future if v8-R and v8-A diverge in
incompatible ways the profile will need to be recorded.

GNU_PROPERTY_AARCH64_FEATURE_1_AND
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

This property describes a set of processor features with which an ELF
object or executable image is compatible, but does not require in
order to execute correctly.  Each processor feature is represented by
a feature bit. The static linker sets a bit in the output ELF file's
``GNU_PROPERTY_AARCH64_FEATURE_1_AND`` if all the input files contain
a ``GNU_PROPERTY_AARCH64_FEATURE_1_AND`` with the bit set.

Only processor features that can be optionally enabled by the
platform, with the program able to run correctly if the feature is not
available or enabled can be added to
``GNU_PROPERTY_AARCH64_FEATURE_1_AND``. In practice this means the
processor features can been implemented in the hint space such as BTI,
or features that are implicit such as the guarded control stack GCS.

If a processor feature is required for a program to run correctly a
new program property is required to describe it.

The static linker performs a logical AND when combining
``GNU_PROPERTY_AARCH64_FEATURE_1_AND``.  If the logical operation is
an OR (set the feature bit if at least one relocatable object has the
bit) then a new program property is required.

GNU_PROPERTY_AARCH64_FEATURE_PAUTH
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The (PAUTHABI64_) ELF extension requires a (platform, version number)
tuple to uniquely identify a signing schema with both platform and
version number needing to match across the program to be sure that all
parts of the program are using the same signing schema.  This cannot
be represented as a feature bit so an additional
``GNU_PROPERTY_AARCH64_FEATURE_PAUTH`` is required that records
platform and version number.  The (0,0) tuple is synthesized for
loadable-units without the property and is defined to be incompatible
with all other versions.

Alternatives considered
=======================

Platform architecture compatibility data
----------------------------------------

The ELF for the Arm Architecture (AAELF32_) contains a number of
program headers with an encoding for the 32-bit architecture profile
and version in the format of ``Tag_CPU_Arch`` from (ADDENDA32_). This
part of the ABI is not known to have been implemented by any toolchain
or platform.

The ELF for the 64-bit Arm Architecture (AAELF64_) has reserved
``PT_AARCH64_ARCHEXT`` which could contain similar information defined
for AArch64.

This approach was rejected for the following reasons:

- The Armv8-A architecture permits optional extensions and backports
  of features from later architecture releases. An ordered list of
  numbers like ``Tag_CPU_Arch`` is not sufficient to describe required
  architecture features.

- There is no way to describe optional features that can be enabled
  such as BTI. Only required architecture features for the program to
  run.

- GNU properties have already been used for BTI and this can be
  extended rather than introduce a new mechanism.

Dynamic section tag, value pairs
--------------------------------

The dynamic section ``.dynamic`` contains an array of tag, value pairs
that communicate information like the location of the dynamic symbol
table, and number of dynamic symbols to the dynamic loader. The range
of tags from ``DT_LOPROC`` to ``DT_HIPROC`` is reserved for the
processor, and ``DT_LOOS`` to ``DT_HIOS`` for the execution
environment.

While dynamic tag, value pairs are sufficient to encode data for the
execution environment, they have the major weakness that they are only
present in dynamically linked loadable-units and are only read by
dynamic loaders.

This implies that dynamic tags can only be used for metadata when the
feature requires dynamic loading.

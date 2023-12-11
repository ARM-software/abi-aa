..
   Copyright (c) 2023, Arm Limited and its affiliates.  All rights reserved.
   CC-BY-SA-4.0 AND Apache-Patent-License
   See LICENSE file for details

.. |copyright-date| replace:: 2023

.. _AAELF64: https://github.com/ARM-software/abi-aa/releases
.. _ARMARM: https://developer.arm.com/documentation/ddi0487/latest
.. _ADDENDA32: https://github.com/ARM-software/abi-aa/releases
.. _BUILDATTR64: https://github.com/ARM-software/abi-aa/releases
.. _CPPABI64: https://github.com/ARM-software/abi-aa/releases
.. _LINUX_ABI: https://github.com/hjl-tools/linux-abi/wiki/Linux-Extensions-to-gABI
.. _PAUTHABI64: https://github.com/ARM-software/abi-aa/releases
.. _SYSVABI64: https://github.com/ARM-software/abi-aa/
.. _X86_64PSABI: https://raw.githubusercontent.com/wiki/hjl-tools/x86-psABI/x86-64-psABI-draft.pdf

Design Rationale for Build Attributes for the Arm 64-bit Architecture (AARCH64)
*******************************************************************************

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
  | 0.1        | 18th October 2023   | Alpha draft release to accompany Build Attributes specification  |
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
  | AAELF64_                                                                                | IHI 0056                                                    | ELF for the Arm 64-bit Architecture                                           |
  +-----------------------------------------------------------------------------------------+-------------------------------------------------------------+-------------------------------------------------------------------------------+
  | BUILDATTR64_                                                                            |                                                             | Build Attributes for the Arm 64-bit Architecture                              |
  +-----------------------------------------------------------------------------------------+-------------------------------------------------------------+-------------------------------------------------------------------------------+
  | CPPABI64_                                                                               | IHI 0059                                                    | C++ ABI for the Arm 64-bit Architecture                                       |
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

This document contains the design rationale for build attributes for
64-bit ELF files defined in (BUILDATTR64_). Nothing in this document
is part of the specification. The purpose is to record the rationale
for the specification as well as alternatives that were considered.
Any contradictions between this rationale and the specification shall
be resolved in favor of the specification.

This document assumes that the reader is familiar with (BUILDATTR64_)
and the 32-bit build attributes defined in (ADDENDA32_) and will use
concepts defined in these documents.

.. raw:: pdf

   PageBreak

Introduction
============

The 32-bit ABI in (ADDENDA32_) defines build attributes as a means to
record data that a linker needs to reason mechanically about the
compatibility, or incompatibility of a set of relocatable object
files. An extensive set of build attributes is required for AArch32
due to the number of architecture options, toolchain differences and
procedure call standard variants.

The 64-bit ABI assumes that the majority of AArch64 software is
deployed on software platforms running a rich OS such as those
described in (SYSVABI64_). Software platforms have a stable platform
interface and run on a wide variety of hardware with different
capabilities. AArch64 software frequently uses runtime feature
detection so that it can run everywhere, but take advantage of newer
hardware features when they are available. A stable platform interface
and runtime feature detection limits the need for the static linker to
reason about software compatibility on a particular platform as this
work is deferred to runtime.

A small number of features are either not amenable to runtime checking
either due to the cost of runtime checking being excessive, or the
feature requiring a property be enforced across a loadable unit
(defined as an executable or shared-library) or a whole program
(defined as an executable and all the shared-libraries it loads). For
these features loadable-units need additional metadata that a platform
can use to enable or disable a feature. In many cases the
loadable-unit metadata relies on metadata in the relocatable object
files that make up the loadable-unit. AArch64 build attributes provide
the encoding for the metadata in relocatable object files.

An example of a feature that is not amenable to runtime checking is
use of pointer authentication instructions outside of the hint space.
These could be present in all non-leaf functions so testing and
providing alternative implementations would be prohibitively
expensive.

An example of a feature that must enforce a property across a
loadable-unit is branch target identification (BTI). When this feature
is enabled for a loadable-unit all indirect branch targets in the
loadable-unit must have a BTI compatible landing pad.

Design Goals
============

The goals of the AArch64 build attributes specification are to:

- Define the encoding for AArch64 build attributes in relocatable
  object files.

- Define the relationship between build attributes and the existing
  GNU program properties.

- Reuse as much of what worked well from the AArch32 Build Attributes
  in (ADDENDA32_).

- Make it easier for a build attributes consumer to skip a subsection
  or attribute that it does not understand without giving a warning
  message.

- Separate architectural requirements from software ABI requirements.

Build Attributes or GNU properties?
===================================

There are many ways that attributes about a program can be
represented, both in the abstract and in the concrete way that they
are encoded in an ELF file. GNU properties the most likely alternative
as they are already used in (SYSVABI64_) for
``GNU_PROPERTY_AARCH64_FEATURE_1_BTI`` and are extensively used in the
(X86_64PSABI_). GNU properties could be extended for all relocatable
object file marking instead of Build Attributes.

From an encoding perspective the GNU property format as defined by
(LINUX_ABI_) permits any data in the program property array. There could
be a ``GNU_PROPERTY_AARCH64_ATTRIBUTES`` property which contain the
same information as (BUILDATTR64_) defines for the ``SHT_AARCH64_ATTRIBUTES``
section. This would essentially be using GNU properties as a build attributes
wrapper.

From a modelling perspective GNU properties are present in both
relocatable object files and loadable-units which influences the
design of the properties with a simple combination rule per property
for the static linker to transfer the relocatable object file
properties to the loadable-unit. For example:

- ``GNU_PROPERTY_STACK_SIZE`` has the static linker copy the maximum
  value of all the relocatable object file inputs
  ``GNU_PROPERTY_STACK_SIZE`` to the output property.

- ``GNU_PROPERTY_AARCH64_FEATURE_1_AND`` transfers the ``AND`` of all
  the feature bits from the relocatable object file inputs to the output
  property. In practice an additional input for some the feature bits
  has come from the static linker, making the implementation less
  generic than it could be.

The major differences between build attributes and GNU properties are:

- Build attributes are relocatable file object only and have an
  encoding that is optimized for size.  The results of a build
  attributes combination can be transferred to GNU properties or some
  platform specific format in the loadable unit.

- Build attributes have one combination operation ``join`` with the
  partial order of the tag determining whether attributes accumulate
  or diminish under ``join``.

- There is a well defined partial order across a set of build
  attributes. With compatibility represented by the ≤ operator.

For independent binary attributes such as whether a particular
architecture feature is required or not, build attributes offer no
advantage over the feature bits provided in GNU properties. Build
attributes can have advantages when modelling properties that:

- can be represented by a value where the order of values represents
  the degree to which the property has the value. For example if there
  is a monotonically increasing set of hardware capabilities this can
  be represented as a single attribute with a single value rather than
  multiple feature bits with forcing functions. A concrete example is
  ``FEAT_LSE2`` which can only exist if ``FEAT_LSE`` exists.

- require more than one attribute to describe. For example the
  (PAUTHABI64_) describes signing schema as a tuple of (vendor,
  version). This would require two attributes to completely describe.

Perhaps the strongest claim for build attributes is the ability to
form a partial order between two independent sets of build attributes.
This can be used as the basis of finding the best set of pre-compiled
libraries out of a selection of pre-compiled alternatives. Intuitively
the best candidate library makes the most demands of the execution
environment without exceeding the capabilities of the exception
environment. More formally:

- The build attributes of the input objects form the selection
  attributes.

- Each pre-compiled library contains relocatable object files with the
  same build attributes.

- A library is compatible with the selection attributes if the library
  build attributes ≤ selection build attributes.

- When comparing two compatible libraries L1 and L2 with build
  attributes B1 and B2 then L1 is preferred to L2 if L2 ≤ L1.

Differences from the 32-bit ABI Build Attributes
================================================

- Only file scope build attributes are supported. Section and symbol
  scope build attributes are deprecated and optional in (ADDENDA32_).

- Related attributes with similar properties and compatibility model
  are grouped into subsections. In (ADDENDA32_) all public attributes
  are present in a single ``"aeabi"`` subsection.

- Every subsection has all of its tags encoded as ULEB128 or all of
  its tags as encoded as NTBS. In (ADDENDA32_) this is determined by
  whether the tag is even or odd.

- A reference partial order is defined for every attribute. In
  (ADDENDA32_) this is implementation defined.

Build attributes at file scope only
===================================

Limiting the encoding to file scope reflects the practical experience
of AArch32 implementations.

The (ADDENDA32_) defined encodings for per section and per function
attributes as well as file scope attributes. Assigning attributes to
finer grained entities permits toolchains to do more precise
compatibility checks. For example:

- Section level build attributes permit a partial (also known as
  relocatable) link to preserve the build attributes from the
  relocatable object files by propagating the file scope attributes
  from the input relocatable object files as section level attributes in
  the output relocatable object file.

- Functions ``F1`` and ``F2`` with incompatible procedure call
   attributes may be able to coexist in the same program providing
   that ``F1`` does not call, or take the address of ``F2``.

The downside of symbol and section build attributes is increased
implementation complexity.  The number of sections and symbols in a
loadable-unit is sufficiently large that caching and deduplication of
attributes is often required to avoid the performance and memory usage
overheads.

In practice only Arm's proprietary toolchain made use of per symbol
and per section build attributes for a small number of use cases. In
(ADDENDA32_) support for per-symbol and per-section build attributes
was made optional and not encouraged.

Limitations of file scope attributes
------------------------------------

The scenarios where file scope attributes have limitations are as
follows:

- Per function differences from the files command line options. Some
  assemblers and compiler have extensions such as pragmas and
  attributes that permit individual functions to use different
  architecture and procedure call standards from the rest of the
  file. For example the compiler
  ``__attribute__((target("branch-protection=<protection>")))``. An
  object producer can either leave the file-scope build attributes
  unchanged, or attempt to merge the functions attributes into the
  file-scope build attributes using the combination rules given in
  (BUILDATTR64_). Given that a common use case for functions with
  different properties is for runtime selection, we recommend object
  producers leave the file-scope attributes unchanged in this case. It
  is the user's responsibility to maintain compatibility at run-time.

- Relocatable links such as ``ld -r``. A relocatable link takes one or
  more relocatable object files, producing a single output relocatable
  object file. The static linker can merge the build attributes of
  each input relocatable object file.


Multiple subsections with similar properties
============================================

Grouping related build attributes into a sub-section permits:

- The same encoding to be used for all tags within the subsection.

- The subsection can be marked as optional without affecting other
  subsections.  This makes it easy for consumers to skip multiple tags
  from an optional subsection at once if they don't recognize the
  subsection name.

- Subsections may share common implementation properties such as all
  tags having the same partial order which could make them easier to
  process. For example if all tags in a subsection have the value 0
  or 1, and have a partial order that is identical or reverse of the
  tags arithmetic value, then an implementation can represent this as
  a bit vector and use the binary ``or`` or ``and`` operator to do the
  join.

Alternative: one .aeabi_attributes section
------------------------------------------

Instead of grouping attributes with similar properties into their own
subsection, we follow (ADDENDA32_) and have one single public
.aeabi_attributes section that contains all the public attributes. Or
have one public .aeabi_attributes section for ULEB128 and one for
NTBS.

This would be simpler to encode in assembly, with only one directive
required, but would make the specification harder to understand
and maintain consistency over time.

All tags ULEB128 or NTBS
========================

A build attributes consumer can more easily skip tags it doesn't
understand if the encoding for the value is known ahead of time. The
rule in (ADDENDA32_) that used whether the tag was even or odd was
error prone as the rule is not widely known. Moreover almost all
tags are ULEB128 so the even odd rule wastes almost half the encoding
space for tags.

Reference Partial Order
=======================

A majority of build attributes have the partial order either matching
or reversing the build attribute arithmetic order. As (ADDENDA32_)
states it is usually obvious when this is the case. However there are
more complex cases and in these cases it can help to state what the
reference intention is for the tag.

Appendix: Recommended Tool Interface for aeabi subsections
==========================================================

Compiler
--------

Build attributes are set by the compiler based on command-line
options.  For example the clang and gcc ``-mbranch-protection`` option
can be used to derive ``Tag_Feature_BTI`` and ``Tag_Feature_PAC`` and
``Tag_Feature_GCS``.

Individual functions can be given different values from the file scope
command-line options. The file scope build attributes should still be
derived from the file scope command-line options, or module level encodings
of the file scope command-line options in the case of link time optimization.
It is the user's responsibility that the individual functions are used in a
compatible way to the file scope build attributes.

Assembler
---------

Where possible the assembler can derive build attributes from the
assembler's command line options in the same way as the compiler.  For
options that cannot be derived the following directives can be used to
construct "aeabi" prefixed subsections.

::
   .aeabi_subsection name [optional] [, parameter type]


*name*

Create or switch the current subsection to *name*.

*optional*

This field is optional and only applies to subsection names with a
prefix of "aeabi".  The default value is 1 for optional.

*parameter type*

This field is an integer 0 or 1 that determines whether the
subsection value is ULEB128 or a NTBS. It only applies to subsection
names with a prefix of "aeabi".  The default value is 0 for ULEB128.

::

   .aeabi_attribute tag, value

* *tag* is either an attribute number or one of the following
  Tag_Feature_BTI, Tag_Feature_PAC or Tag_Feature_GCS.

* *value* is either a number or "string" depending on <parameter type>
  of the current subsection.

In the current active subsection, set *tag* to *value*.

Appendix: Alternatives to Build Attributes
==========================================

Use GNU Properties for relocatable object files
-----------------------------------------------

(SYSVABI64_) defines the ``GNU_PROPERTY_AARCH64_FEATURE_1_AND`` program
property for relocatable object files. Each program property is akin to a
subsection in build attributes. While the existing
``GNU_PROPERTY_AARCH64_FEATURE_1_AND`` is only suitable for a small
number of optional properties that can be represented as feature bits,
additional properties could be defined with more complex
representations. In fact the entirety of build attributes could be
encoded within a ``GNU_PROPERTY_AARCH64_BUILD_ATTRIBUTES`` program
property.

With a GNU property focused design, instead of using build attributes
Arm would define new GNU properties in addition to
``GNU_PROPERTY_AARCH64_FEATURE_1_AND``. Of the attributes described
in (BUILDATTR64_) ``Tag_Feature_GCS`` could be added as a feature
bit of ``GNU_PROPERTY_AARCH64_FEATURE_1_AND`` however a new property
``GNU_PROPERTY_AARCH64_FEATURE_PAUTH`` with a custom combination rule
would be required for the (PAUTHABI64_).

Human readable build attributes
-------------------------------

Build attributes, and GNU properties have a dense binary encoding that
a user cannot easily add to a toolchain that does not have sufficient
support for writing them.

A human readable format such as JSON could be used instead. A user
could then write their own build attributes using standard assembler
directives.

Similarly there would not need to be tool support for decoding and
printing build attributes.

There are several downsides:

- Humans make textual errors, requiring validation and error handling.

- Textual formats are slower to parse and take up more space.

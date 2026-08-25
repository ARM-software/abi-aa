..
   Copyright (c) 2026, Arm Limited and its affiliates.  All rights reserved.
   CC-BY-SA-4.0 AND Apache-Patent-License
   See LICENSE file for details

.. _MEMTAGABIELF64: https://github.com/ARM-software/abi-aa/tree/main/memtagabielf64/memtagabielf64.rst
.. _PAUTHABIELF64: https://github.com/ARM-software/abi-aa/tree/main/pauthabielf64/pauthabielf64.rst
.. _RELATIVE_RELOCATION_TABLE: https://gabi.xinuos.com/elf/06-reloc.html#relative-relocation-table

Alternative encoding for relative relocation metadata stored in place
*********************************************************************

Preamble
========

Background
----------

This document contains a design exploration for an AArch64 ELF
extension that stores addtional dynamic relocation metadata in a form
suitable for a self-relocating ELF file. Additional dynamic relocation
metadata is required the `PAUTHABIELF64`_ and `MEMTAGABIELF64`_
extensions.

Nothing in this document is part of the ABI. The purpose is to record
the rationale for the ABI as well as alternatives that were
considered.  Any contradictions between this document and the ABI
shall be resolved in favor of the ABI.

Relative relocations
--------------------

Position independent ELF files require relocation when executing at a
different location than their statically-linked address. In most cases
the relocation is performed by an external program interpreter
specified by the ``PT_INTERP`` program-header. A fully
statically-linked program, and a program-interpreter that does not run
at its statically linked address, like ld.so, must self-relocate.

Self-relocation in most programs reduces to resolving the
``R_AARCH64_RELATIVE`` dynamic relocations. For each
``R_AARCH64_RELATIVE`` relocation the address in the contents of the
place ``*P`` is formed by adding the displacement from the static link
address to the relocation addend ``A``. The self-relocating program
must take care not to use a location requiring relocation before or
during relocation resolution.

``R_AARCH64_RELATIVE`` dynamic relocations can be encoded in several
ways:

* ``SHT_RELA`` the addend is stored in the dynamic relocation.

* ``SHT_REL`` the addend is stored in contents of the place ``*P``.

* ``SHT_RELR`` the addend is stored in the contents of the place
  ``*P``. A ``SHT_RELR`` section only contains the place ``P`` of
  ``R_AARCH64_RELATIVE`` relocations, using a compressed encoding.

The GNU ld and lld command-line option ``-z apply-dynamic-relocs``
uses ``SHT_RELA`` relocations but with the addend also stored in the
place ``P``. When the program executes at its statically-linked
address no dynamic relocation is necessary.

ELF extensions and additional metadata
--------------------------------------

The `PAUTHABIELF64`_ and `MEMTAGABIELF64`_ ELF extensions require
additional metadata, stored in the contents of the place ``*P`` that
restrict how dynamic relocations can be encoded.

The `PAUTHABIELF64`_ ELF extension introduces the
``R_AARCH64_AUTH_RELATIVE`` dynamic relocation. This signs the result
of a ``R_AARCH64_RELATIVE`` relocation. To sign the result the
relocation resolver needs to know the signing-schema to apply to the
relocation. The signing-schema is recorded in the contents of the
place ``*P``. Quoting from the `PAUTHABIELF64`_ the following table
describes the encoding of the signing-schema:

.. table:: Signing schema encoding

  +-------------------+----------+----------+----------+---------------+---------------------+
  | 63                | 62       | 61:60    | 59:48    |  47:32        | 31:0                |
  +===================+==========+==========+==========+===============+=====================+
  | address diversity | reserved | key      | reserved | discriminator | reserved for addend |
  +-------------------+----------+----------+----------+---------------+---------------------+

The ``reserved for addend`` field is for a ``SHT_REL`` or ``SHT_RELR``
like encoding called ``SHT_AUTH_RELR``, it is unused when ``SHT_RELA``
encoding is used.

The `MEMTAGABIELF64`_ ELF extension does not introduce any new dynamic
relocation types but when in operation it extends the semantics of
existing dynamic relocations like ``R_AARCH64_RELATIVE``. The
relocation resolver tags the result of a ``R_AARCH64_RELATIVE`` with
the tag of the memory pointed to by the address calculated by
``R_AARCH64_RELATIVE``. Out of bounds accesses require an additional
offset needs to be applied to the address calculated by
``R_AARCH64_RELATIVE`` to obtain the correct tag. This offset is
encoded in the contents of the place ``*P``. Relocations requiring the
additional offset require ``SHT_RELA`` encoding and are excluded from
``SHT_RELR`` sections.

When the `MEMTAGABIELF64`_ is combined with the ``PAUTHABIELF64`_ the
semantics of the ``R_AARCH64_AUTH_RELATIVE`` dynamic relocation are
extended. In this case the output of ``R_AARCH64_AUTH_RELATIVE``. When
an additional offset is used it is encoded in the ``reserved for
addend`` field of the signing-schema. ``R_AARCH64_AUTH_RELATIVE``
relocations requiring the additional offset require ``SHT_RELA``
encoding and are execluded from ``SHT_AUTH_RELR`` sections.

When the contents of the place ``P`` is used for metadata the static
linker `-z apply-dynamic-relocs` cannot be applied as it will
overwrite the metadata with the static-link time address of the
destination.

Additional Metadata and idempotency
===================================

The additional metadata is stored in the contents of the place of the
relocation ``*P``. When the relocation is resolved the contents of the
place will be overwritten by the result of the relocation. A
``R_AARCH64_AUTH_*`` dynamic relocation or a `MEMTAGABIELF64`_
extended semantics ``R_*_RELATIVE`` dynamic relocation with an
additional offset can only be resolved once.

Problem Statement
-----------------

A self-relocating program using the `PAUTHABIELF64`_ and/or the
`MEMTAGABIELF64`_ may encounter a situation where a dynamic-relocation
may need to be resolved more than once. For example, consider a
self-relocating bare-metal program that executes after reset. The
program is responsible for initializing the MMU, caches, setting up
pointer authentication keys and other device specific hardware
initialization. After initialization the program copies itself to a
new location, for address space randomization purposes, and resolves
the relative-relocations. If any of the code that runs prior to the
ASLR copying and subsequent relocation needs to access a global
variable that is signed or has a tagged offset, which includes any
variable accessed via a signed GOT, then the program will need to
resolve the relocations twice.

Desired program flow of a self-relocating bare-metal system:

1 Program start at static-link time address.

2 Minimal hardware initialization not using signed locations.

3 1st pass of relocation resolution of signed relocations at
  static-link address.

4 Completion of hardware initialization using signed locations.

5 Copying of program to execution address.

6 2nd pass of relocations at execution address.

7 Rest of program executes at execution address.

As the 1st pass of the relocations will destroy the metadata stored in
the contents of the place ``*P``. The 2nd pass of the relocations
cannot be performed with the current encoding.

Potential solutions
-------------------

Require a separate loader
=========================

Instead of a single ELF file that self-relocates, a program can be
split into two ELF files that do not share data:

* A position-dependent ELF file that does steps 1 to 5 of the `Problem
  Statement`_ above. Copies the second ELF file to its ASLR location
  and relocates it.

* A position-independent ELF file that does not self-relocate.

The dynamic-relocations are partitioned into two sets, each of which
only needs to be relocated once.

Pros:

* No changes to ABI or existing tools.

Cons:

* Limits the architecture choices of self-relocating programs.

Code running prior to ASLR must not require relocations with metadata
=====================================================================

If the code that does steps 1 to 5 of the `Problem Statement`_ above
does not use a location that requires a dynamic relocation with
metadata then these relocations only need to be resoved once. This can
be achieved by:

* Write initialization code that avoids using the GOT, which may be
  signed. For a self-relocating executable this can be done by using
  hidden visibility, which allows the compiler to use PC-relative
  addressing.

* Write initialization code that does not use signed code-pointers,
  such as calling virtual-functions.

* Use ``SHT_RELR`` which exclude any R_AARCH64_relocation with
  metadata stored in the contents of the place ``*P``. These
  relocations can be resolved multiple times.

* The `MEMTAGABIELF64`_ requires tagged globals to be accessed via the
  GOT. Global Variables used prior to relocation-resolution must be
  untagged.

* Very few high-level diagnostics available for cases that will fail
  at runtime.

Pros:

* No changes to ABI or existing tools.

Cons:

* Requires programmer effort to create and maintain. This is
  reasonable for a self-relocating dynamic loader which can be written
  once and reused transparently by all programs on the
  platform. However is it too much to expect from every
  self-relocating bare-metal project?

Preserve the metadata at runtime
================================

A program can allocate a buffer to store the metadata when doing a
relocation pass. The metadata can be restored or accessed directly
from the buffer in subsequent passes.

Pros:

* No changes to ABI or existing tools.

Cons:

* Requires allocating memory, or a good estimate from the programmer
  of how many dynamic relocations will be used.

* Overhead in copying to buffer, and restoring afterwards.

* Buffer will be in read-write memory, which could be tampered with
  unless remapped as read-only after copying.

Encoding the metadata into the relocation addend
================================================

The addend field of a ``SHT_RELA`` relocation is 64-bits, yet for many
position independent programs a 32-bit addend is sufficient. In such
cases the addend can be redefined to include the signing-schema, as
defined in `ELF extensions and additional metadata`_.

With the current signing-schema encoding, using the relocation addend
cannot handle the `MEMTAGABIELF64`_ extension of
``R_AARCH64_AUTH_RELATIVE`` when an additional offset is needed to
recover the correct Tag as the additional offset and the relocation
addend can't both use the ``reserved for addend`` field.

A possible mitigation for the conflict over ``reserved for addend``
field is to restrict the values that an offset to recover the tag can
take. In the majority of cases the access will be to the limit of an
array. Using the example from `MEMTAGABIELF64`_:

.. code-block:: c

  int* foo[32];
  int* foo_end = &foo[32];

Instead of using a tag offset to the start of the array, we only need
to use a tag offset into the array, which could be a hard-coded
offset.

A hard-coded offset could represented by a bit in the signing-schema
or a new relocation code like ``R_AARCH64_AUTH_RELATIVE_TAG``. However
it won't work for pointer to integer conversions that go out of
bounds, but are not undefined behavior in C. Taking the example from
https://github.com/ARM-software/abi-aa/issues/399

.. code-block:: c

  uint64_t x = 42;
  // uint64_t* ub = &x + 0x1000; // UB
  uintptr_t y = ((uintptr_t)&x) + 0x1000; // ALLOWED

  uint64_t get_x() {
    uint64_t* x_ptr = (uint64_t*)(y - 0x1000); // ALLOWED
    return *x_ptr; // ALLOWED
  }

Pros:

* Existing ``SHT_RELA`` relocations can be simply modified by a
  post-linker tool.

Cons:

* Incompatibility with the `MEMTAGABIELF64`_ using the current
  signing-schema encoding. Would have to use most of the reserved bits
  to add support for the offset needed by `MEMTAGABIELF64`_.

* Bare-metal programs sometimes need to start at high addresses, it is
  not guaranteed that a 32-bit addend will be sufficient.

Extending ELF with a relocation metadata section
================================================

Introduce a new ELF section type, ``SHT_AARCH64_REL_METADATA`` that
contains an array of values containing metadata. The ``sh_link`` field
holds the section header index of the relocation section that it
augments. Each value corresponds one to one with a relocation and
appears in the same order as the relocation entry in the section
containing the relocations. Use of ``SHT_AARCH64_REL_METADATA`` is not
required if a platform can use the contents of the place to store
metadata.

The size of the metadata value is by default an ``Elf64_Word`` as that
matches the size of the contents of the place ``*P``.

If a relocation section is augmented with a
``SHT_AARCH64_REL_METADATA`` section (type ``0x70000009``) and the
relocation resolver opts to use it then the relocation Operations are
altered as follows:

* ``METADATA(idx)`` extracts the value from the array
  at ``idx``, where ``idx`` is the index of the relocation entry in
  linked relocation section.

* ``\*P`` becomes ``(METADATA(idx))`` for example ``SIGN(Delta + A,
  SCHEMA(\*P))`` becomes ``SIGN(Delta + A, SCHEMA(METADATA(idx)))``.

For the ``SHT_RELR`` and ``SHT_AUTH_RELR`` sections the ``idx`` can be
derived by counting the number of relocations processed starting
from 0. The ``SHT_RELR`` section is not expected to have a
``SHT_AARCH64_REL_METADATA`` section as it contains dynamic
relocations that do not require additional metadata (the
`MEMTAGABIELF64`_ excludes entries that require additional metadata).


ELF files may have up to 4 dynamic relocation sections, 3 of which may
have a linked ``SHT_AARCH64_REL_METADATA`` section:

.. table:: Relocation sections

  +----------------+-----------------+-------------------------+-------------------+
  | Name           | Metadata name   | Relocations             | Need metadata     |
  +----------------+-----------------+-------------------------+-------------------+
  | .relr.dyn      | Not applicable  | R_AARCH64_RELATIVE      | No                |
  +----------------+-----------------+-------------------------+-------------------+
  | .relr.auth.dyn | .relr.auth.meta | R_AARCH64_AUTH_RELATIVE | Yes               |
  +----------------+-----------------+-------------------------+-------------------+
  | .rela.dyn      | .rela.meta      | Any dynamic relocation  | Yes               |
  +----------------+-----------------+-------------------------+-------------------+
  | .rela.plt      | .rela.plt.meta  | R_AARCH64_JUMP_SLOT     | Yes if signed GOT |
  +----------------+-----------------+-------------------------+-------------------+

The following dynamic tags can be used to locate the corresponding
``SHT_AARCH64_REL_METADATA``

.. table:: Additional AArch64 specific dynamic array tags

  +-----------------------------------+------------+--------+------------+---------------+
  | Name                              | Value      | d\_un  | Executable | Shared Object |
  +===================================+============+========+============+===============+
  | DT\_AARCH64\_AUTH\_RELR\_META_SZ  | 0x70000015 | d\_val | optional   | optional      |
  +-----------------------------------+------------+--------+------------+---------------+
  | DT\_AARCH64\_AUTH\_RELR\_META     | 0x70000016 | d\_ptr | optional   | optional      |
  +-----------------------------------+------------+--------+------------+---------------+
  | DT\_AARCH64\_AUTH\_RELR\_METAENT  | 0x70000017 | d\_val | optional   | optional      |
  +-----------------------------------+------------+--------+------------+---------------+
  | DT\_AARCH64\_RELA\_META_SZ        | 0x70000019 | d\_val | optional   | optional      |
  +-----------------------------------+------------+--------+------------+---------------+
  | DT\_AARCH64\_RELA\_META           | 0x70000020 | d\_ptr | optional   | optional      |
  +-----------------------------------+------------+--------+------------+---------------+
  | DT\_AARCH64\_RELA\_METAENT        | 0x70000021 | d\_val | optional   | optional      |
  +-----------------------------------+------------+--------+------------+---------------+
  | DT\_AARCH64\_RELA\_PLT\_META_SZ   | 0x70000023 | d\_val | optional   | optional      |
  +-----------------------------------+------------+--------+------------+---------------+
  | DT\_AARCH64\_RELA\_PLT\_META      | 0x70000024 | d\_ptr | optional   | optional      |
  +-----------------------------------+------------+--------+------------+---------------+
  | DT\_AARCH64\_RELA\_PLT\_METAENT   | 0x70000025 | d\_val | optional   | optional      |
  +-----------------------------------+------------+--------+------------+---------------+

Design alternative. Size specific encoding of metadata

The size of the metadata value could be varied to save space, or
permit larger metadata than offered by the contents of the place. For
example, the metadata for just `PAuthABIELF64`_ can be described in
32-bits as the `reserved for addend` field would always be 0. It could
also be larger to permit more than one piece of metadata. To
accomodate different sizes ``METADATA(idx)`` is expanded to:

* ``METADATA(code, entsz, idx)`` extacts the metadata for relocation ``code`` from an ``entsz`` field in ``SHT_AARCH64_REL_METADATA``.

.. table:: metadata size encoding for relative relocation codes.

  +-------------------------+-------+---------------------------------------+
  | code                    | entsz | value in ``SHT_AARCH64_REL_METADATA`` |
  +=========================+=======+=======================================+
  | R_AARCH64_RELATIVE      | 4     | 32-bit tag offset                     |
  +-------------------------+-------+---------------------------------------+
  | R_AARCH64_AUTH_RELATIVE | 4     | signing-schema >> 32                  |
  +-------------------------+-------+---------------------------------------+
  | R_AARCH64_RELATIVE      | 8     | 64-bit tag offset                     |
  +-------------------------+-------+---------------------------------------+
  | R_AARCH64_AUTH_RELATIVE | 8     | signing-schema                        |
  +-------------------------+-------+---------------------------------------+
  | R_AARCH64_RELATIVE      | 16     | (signing-schema, 64-bit tag offset)   |
  +-------------------------+-------+---------------------------------------+
  | R_AARCH64_AUTH_RELATIVE | 16     | (0ull, 64-bit tag offset)             |
  +-------------------------+-------+---------------------------------------+

This would permit more flexibility at the expense of ABI and tool
complexity to handle the various sizes. There are some opportunities
and limitations to simplify based on use case:

* ``SHT_RELR`` Containing no tag offsets likely does not need an
  additional ``SHT_AARCH64_REL_METADATA`` as no signing-schema or tag
  offset is there to be overwritten.

* ``SHT_AUTH_RELR`` containing no tag offsets requires entsz of 8 to
  describe signing-schema and addend.

* ``SHT_RELA`` could use 4 for ``R_AARCH64_AUTH_RELATIVE`` with no tag
  offsets. It is likely that ``SHT_AUTH_RELR`` with an entsz 8
  ``R_AARCH64_AUTH_RELATIVE`` is likely to be smaller.

* ``SHT_RELA`` could use 4 for ``R_AARCH64_RELATIVE`` with a 32-bit
  tag offset. However such a section couldn't also represent a
  ``R_AARCH64_AUTH_RELATIVE`` with a tagged offset.

It seems like if ``SHT_AUTH_RELR`` is supported then there isn't much
need for entsz of 4.

Pros:

* One to one correspondence with the contents of the place ``*P``.

* The contents of the place ``*P`` are not used by a relocation
  resolver. On a platform that requires ``SHT_AARCH64_REL_METADATA``
  The contents of the place ``*P`` can contain the unsigned, untagged
  static-link time address if known (as if `-z
  apply-dynamic-relocs`). If use of ``SHT_AARCH64_REL_METADATA`` is
  optional the contents of the place ``*P`` can be the same if
  ``SHT_AARCH64_REL_METADATA`` were not used.

* Fast to process. Given an index into the dynamic relocations, we can
  easily find the metadata for that index.

* Works with ``SHT_RELA``, ``SHT_REL`` and ``SHT_AUTH_RELR``.

* Compatible with `MEMTAGABIELF64`_ extension. The ``reserved for
  addend`` field in the metadata can contain any offset needed to
  recover the tag.

Cons:

* An ELF extension requiring support in tools, and vulnerable to 3rd
  party ELF processing tools unaware of it.

* Wasteful in size. Many locations like the GOT have the same
  signing-schema.

* If ``SHT_RELR`` not used for ``R_AARCH64_RELATIVE``
  dynamic-relocations then all ``R_AARCH64_RELATIVE`` dynamic
  relocations will get 8-bytes of unused metadata.

Adding a new relative relocation compression format
===================================================

The `PAUTHABIELF64`_ defines the ``SHT_AARCH64_AUTH_RELR`` section
which acts like ``SHT_RELR`` but with the relocation code
``R_AARCH64_AUTH_RELATIVE`` and the signing-schema encoded in the
contents of the place ``*P``, with the signing-schema and the
``reserved for addend`` used to contain the addend. The contents of
the ``SHT_AARCH64_AUTH_RELR`` section is an encoding of where to apply
the ``SHT_AARCH64_AUTH_RELR`` relocations. Resolving these relocations
overwrites the signing-schema. The `MEMTAGABIELF64`_

We define an alternative relative relocation compression format that
includes the additional metadata in the relocation section.

Design goals

* ``R_AARCH64_RELATIVE`` relocations that require no additional
  metadata can be handled by ``SHT_RELR``.

* Does not require any additional metadata section like
  ``SHT_AARCH64_REL_METADATA``.

* Can coexist with a ``SHT_AUTH_REL`` and/or a ``SHT_RELA`` section
  with an accompanying ``SHT_AARCH64_REL_METADATA`` section.

* For a statically linked executable with a single ``SHT_RELA``
  section containing only ``R_AARCH64_RELATIVE`` and
  ``R_AARCH64_AUTH_RELATIVE`` relocations, a post-linker can overwrite
  the ``SHT_RELA`` section with the compressed format.

* Permit the relocations in the compressed relocation section to be
  skipped if the program executes at its static link time address, and
  PAC and MTE are not enabled.

* Reuse existing ``SHT_RELR`` and ``SHT_AUTH_RELR`` encoding method
  where possible.

* Exploit repeated relocations with the same signing-schema. For
  example, all the GOT relocations are signed using the same
  signing-schema.

* Do not try too hard to optimize ``R_AARCH64_RELATIVE`` with
  `MEMTAGABIELF64`_ offset as this is likely to be different for each
  instance, and there isn't likely to be a lot of these.

High-level design

Instead of storing the signing-schema and 32-bit addend in the
contents of the place ``*P``, store the unsigned and untagged addend
in the place as if the relocation code were ``R_AARCH64_RELATIVE`` and
the static linker ``-z apply-dynamic-relocs`` were applied. The
signing and tagging operations are reversible so if the relocations
need to be applied more than once the original address can be
recovered. Storing the full addend also permits the program to access
locations subject to dynamic relocation as long as the program is
executing at its static link time address with PAC and MTE disabled.

With the full addend written into the place the compressed relocation
section must store the relocation offsets and the metadata associated
with that offset.

To permit a post-linker to overwrite the ``SHT_RELA`` section there
needs to be a sentinel value that signifies the end of the
relocations, assuming the size of the overwritten ``SHT_RELA`` section
is larger than the compressed relocation section.

New section type ``SHT_AARCH64_META_RELR`` (``0x70000010``)

The contents of ``SHT_AARCH64_META_RELR`` is::

  [
    <uint32: relocation-code>
    <uint32: n-relocations-of-code>
    [ relocation-entry ]+
  ]*

*relocation-code* is one of three supported relocations
 ``R_AARCH64_RELATIVE``, ``R_AARCH64_AUTH_RELATIVE`` and
 ``R_AARCH64_NONE``. The ``R_AARCH64_NONE`` is used as an optional
 sentinel value that concludes relocation processing. All further
 contents of the ``SHT_AARCH64_META_RELR`` section are undefined. This
 is useful if ``SHT_AARCH64_META_RELR`` is overwriting a an existing
 ``SHT_RELA`` section.

*n-relocations-of-code* is the number of relocations of the code that
 follow in the ``relocation-entry`` fields.

A ``relocation-entry`` is defined as::

  uint64 relocation-code-specific-metadata+
  <uint32> n_relocations_of_metadata
  [ <uint64> address_or_bitmap ]+

*relocation-code-specific-metadata* is the metadata that would
 normally be stored in the contents of the place ``*P``. For
 ``R_AARCH64_NONE`` this is the tag-offset. For
 ``R_AARCH64_AUTH_RELATIVE`` it is the signing-schema as described in
 `ELF extensions and additional metadata`_. Future relocations could
 require more than one *relocation-code-specific-metadata*. The number
 of entries is defined by the *relocation-code*.

*n_relocations_of_metadata* is the number of relocations before the
 next *relocation-code-specific-metadata*

*address_or_bitmap* is the ``SHT_RELR`` and ``SHT_AUTH_RELR`` encoding
 of the relocation offsets as described in the ELF specification under
 `RELATIVE_RELOCATION_TABLE`_.

Dynamic relocations described by
``SHT_AARCH64_META_RELR`` can be sorted by relocation code, then by
metadata to minimise the number metadata and relocation code changes.

Example contents::

  R_AARCH64_AUTH_RELATIVE // Relocation code
  4                       // Number of R_AARCH64_AUTH_RELATIVE
  0xa000b1ea00000000      // Signing-schema
  3                       // Number of relocations with signing-schema
  0x400d7cd8              // Address
  0xa0000001              // Bitmap with 2 relocations
  0x8000cd9a00000000      // Signing-schema
  1                       // Number of relocations with signing-schema
  0x400d8630              // Address
  R_AARCH64_NONE          // Sentinel terminates

New dynamic tags

.. table:: Additional AArch64 specific dynamic array tags for ``SHT_AARCH64_META_RELR``

  +-------------------------------------+------------+--------+------------+---------------+
  | Name                                | Value      | d\_un  | Executable | Shared Object |
  +=====================================+============+========+============+===============+
  | DT\_AARCH64\_META\_RELR\_META_NRELS | 0x70000019 | d\_val | optional   | optional      |
  +-------------------------------------+------------+--------+------------+---------------+
  | DT\_AARCH64\_META\_RELR\_META       | 0x70000020 | d\_ptr | optional   | optional      |
  +-------------------------------------+------------+--------+------------+---------------+

The ``DT\_AARCH64\_META\_RELR\_META_NRELS`` is the number of relocations in the section.

Pros

* For a self relocatable bare-metal executable, can be implemented in
  a post-link transformation that overwrites the ``SHT_RELA``
  relocations.

* With the contents of the place ``*P`` containing the static-link
  time address, a self-relocating bare-metal system does not need to
  resolve any relocations prior to enabling PAC and/or MTE, or
  self-relocating itself.

* in many cases will be significantly smaller than ``SHT_RELA`` as
  many locations use the same signing-schema. With a low number of
  unique signing-schemas the existing ``SHT_AUTH_RELR`` with a
  ``SHT_AARCH64_REL_METADATA`` may be smaller.

Cons

* Larger than two separate ``SHT_RELR`` and ``SHT_AUTH_RELR``
  sections, only likely to be used when idempotency required.

* Yet another ``R_*_RELATIVE`` relocation compression scheme, with
  some interactions with ``SHT_RELR``, i.e. do we have just one
  ``SHT_AARCH64_META_RELR`` containing all ``R_AARCH64_RELATIVE``
  relocations, even those with a metadata of 0, or do we have both
  ``SHT_RELR`` and ``SHT_AARCH64_META_RELR`` dedicated to their use
  case.

* Does the use case justify a place in the ABI at this point? The main
  benefit of an ABI is portability between tools and platforms; if the
  only use case is bare-metal with no need for the new section in
  relocatable objects, this can be a private contract between the
  linker and the relocation resolver of the bare-metal system. We
  would need at least one bare-metal C-library to offer an embedded
  relocation resolver to require a fixed contract in the ABI.

Design alternatives
===================

Restrict compressed relocations to ``SHT_AUTH_RELR`` and rely on
``SHT_RELA`` with ``SHT_AARCH64_REL_METADATA`` for
``R_AARCH64_RELATIVE`` with `MEMTAGABIELF64`_ offset. This would
simplify the format and permit the removal of the Relocation Code as
it would be fixed to ``R_AARCH64_AUTH_RELATIVE``. The downside would
be that it would require tool support for
``SHT_AARCH64_REL_METADATA``.

Recommendation for ABI
----------------------

As the most natural ABI extension, and the most generally applicable
to all software platforms, document the ``SHT_AARCH64_REL_METADATA``
as an optional extension for self-relocating programs that require
idempotency. Platforms that do not require idempotency can ignore it.
A basic implementation could just support ``SHT_RELA``
relocations. Support for ``SHT_AUTH_RELR`` and ``SHT_RELR`` could come
later.

The ``SHT_AARCH64_META_RELR`` section can remain in a design-document
or in a non-normative appendix until there are at least two
independent components that require a fixed contract.

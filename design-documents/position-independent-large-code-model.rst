..
   Copyright (c) 2026, Arm Limited and its affiliates.  All rights reserved.
   CC-BY-SA-4.0 AND Apache-Patent-License
   See LICENSE file for details

.. _AAELF64: https://github.com/ARM-software/abi-aa/tree/main/aaelf64/aaelf64.rst
.. _EHFRAME: https://refspecs.linuxfoundation.org/LSB_3.0.0/LSB-PDA/LSB-PDA.junk/ehframechpt.html
.. _PHDRS: https://sourceware.org/binutils/docs/ld/PHDRS.html
.. _RFC: https://github.com/ARM-software/abi-aa/issues/441
.. _SYSVABI64: https://github.com/ARM-software/abi-aa/tree/main/sysvabi64/sysvabi64.rst
.. _X86_64: https://gitlab.com/x86-psABIs/x86-64-ABI/-/merge_requests/70

Position independent large code model for AArch64
*************************************************

Current status
--------------

This is at first draft, brain dump level of quality. Its purpose is to
share ideas for a position independent code model.

It contains a lot of implementation detail. The sections of most importance to the ABI are:

* `Requirements for a large position independent code model`_

* `Requirements for a large section`_

* `Requirements on code-generators for large code model sections`_

* `Requirements on static linkers for large code model sections`_

* `Requirements on loaders for large code model sections`_

The intent for the ABI is to write down the minimum set of
requirements so that toolchains can interoperate, without limiting
quality of implementation.

Review questions:

* Should an object producer be required to identify large code model
  sections, or must the static linker use relocations?

* For large code-model sections can we require optimisable instruction
  sequences to be emitted contiguously to simplify, and in some cases
  permit more linker optimisation?

* For AArch64 it would be better to interleave data as well as .got
  sections into large text sections. This document has left this as an
  optimisation, not a requirement. Could it be made a requirement?

Primitives
----------

Any code-model needs to be built from a combination of AArch64
instructions and their immediate formats. The following are adapted
from `SYSVABI64`_:

* The LDR (literal) and ADR instructions generate a PC-relative address
  with a range of +/- 1MiB.

* The ADRP instruction generates a PC-relative, page aligned address
  with a range of +/- 4GiB (where page = 4KiB).

* The LDR and STR instructions accept a 12-bit unsigned immediate
  offset, scaled by the access size.

* The B and BL instructions have a range of +/-128MiB. This is
  typically used for function / procedure calls.

* A series of MOVZ and up to 3 MOVK instructions can be used to
  construct a 64-bit value.

* An ADR, MOV and an ADD with immediate shifted left 22 can construct
  a 37-bit PC-relative address.

* Static linkers may insert a veneer (a sequence of instructions) to
  implement a relocated B or BL to a destination further away than the
  +/-128MiB range. The size of executable sections must be limited to
  127 MiB to leave space for veneers to be inserted after the section.

* The relative data relocations R_AARCH64_PLT32 and R_AARCH64_PREL32
  have a range of +/-2GiB.

Existing large code model
-------------------------

The existing large code model was designed for accessing large amounts
of data rather than a large amount of code from a position dependent
executable. The size of the executable .text section is limited to 2
GiB when .eh_frame (containing 32-bit offsets) is present.

There is no use of different section names such as .ltext or .ldata.

The two most common ways to generate a 64-bit address are:

Literal Pool within 4 GiB:

.. code-block:: asm

    adrp x0, .constpool.L0
    ldr x0, [x0, #:lo12: .constpool.L0]
    ...
    .balign8
  .constpool.L0
    .xword var

The `adrp` can be dropped if `.constpool.L0` is within 1 MiB.

Absolute using 4 instructions:

.. code-block:: asm

    movz    x0, # :abs_g0_nc: var
    movk    x0, # :abs_g1_nc: var
    movk    x0, # :abs_g2_nc: var
    movk    x0, # :abs_g3: var

If var is known to be within the first 48-bits then only 3
instructions are needed.

Requirements for a large position independent code model
--------------------------------------------------------

Since the large code model has been defined,
position-independent-executables (PIE) have become the default, and
the amount of code in programs has grown to the point that the 2 GiB
.eh_frame limit and the 4 GiB ADRP limit are being exceeded in a
single executable.

Coming from a small code-model ecosystem, with system libraries and
binary dependencies built with the small code model, as well as
assembly authors assumptions, it has proven difficult to ensure all
inputs are compiled/assembled to be compliant with the large code
model. There is a desire to be able to gracefully handle small amounts
of non large code model inputs within a program intending to use the
large code model.

Must have:

* Support at least 128 GiB of code and data.

* Support both position-independent executables and shared-libraries,
  although may be optimised for the former.

* Small code-model inputs are accepted if they can be placed within a
  contiguous section of memory that conforms to the limitations of the
  small code model.

* Compatible with existing large-code model objects (when linking
  position dependent).

* Can be handled by post-link optimisers such as BOLT.

Should have:

* No restrictions on size of code and data.

* Permit linker optimisation/relaxation of addresses within small
  code-model range.

* Be compatible with the target independent parts of the `X86_64`_
  large code model.

Forming a pc-relative address in a large code-model
---------------------------------------------------

Forming a 64-bit offset
=======================

The two existing large-code model sequences can be altered to
calculate an offset. These can be added to the PC, which can be found
with an `adr` instruction.

Literal Pool containing offset:

.. code-block:: asm

  .L0:
    adr x0, .
    ldr x1, [x0, #:lo12: .constpool.L0]
    add x0, x0, x1
    ...
    .balign8
  .constpool.L0
    .xword var - (. - .L0)

Offset using 4 instructions:

.. code-block:: asm

  .L0:
     adr     x0, .
     movz    x1, # :pcrel_g0_nc: var - (.L0 - .)
     movk    x1, # :pcrel_g1_nc: var - (.L0 - .)
     movk    x1, # :pcrel_g2_nc: var - (.L0 - .)
     movk    x1, # :pcrel_g3: var - (.L0 - .)
     add x0, x0, x1

Note that there are currently no `pcrel_g*` operators or associated
relocations, but these can be defined if necessary.

Forming a 37-bit offset
=======================

An `adr` instruction has a 21-bit offset. A single `mov` instruction
can calculate a further 16-bits and an `add` can shift this into place
to form a 37-bit (128 GiB) offset.

.. code-block:: asm

  .L0:
     adr    x0, :nc: var
     mov    x1, :pcrel_37_22_nc: var - (.L0 - .)
     add    x0, x0, x1, lsl 21

Note that there are no `:nc:` or `:pcrel_37_22_nc:` operators and
associated relocations, but these can be defined if necessary.

A `ldr` to access the variable can't be combined with the `add` due to
the large shift. To access a variable:

.. code-block:: asm

  .L0:
     adr    x0, :nc: var
     mov    x1, :pcrel_37_22_nc: var - (.L0 - .)
     add    x0, x0, x1, lsl 21
     ldr    x0, [x0]

Emitting all 4 instructions in one contiguous range with a pseudo
relocation on the ldr could permit an optimisation when var is within
4 GiB range to:

.. code-block:: asm

  adrp x0, var
  ldr  x0, [x0, :lo12: var]
  nop
  nop

Using the GOT
=============

The global offset table (GOT) is a table of absolute 64-bit addresses
that is relocated at load-time. If the GOT is within `adrp` range then
to obtain a 64-bit address we can use the small-code model access
sequence:

.. code-block:: asm

  adrp x0, :got: var
  ldr x0, [x0, :got_lo12: var]

If there is only one GOT per-program then we cannot guarantee that it
is in range. However if static linkers and dynamic-loaders are able to
support more than one GOT per program, so that there is always a GOT
within `adrp` range then we can use it in a large-code model.

A large-code model object using the GOT strategy will look very
similar to a small-code-model object, except that all references will
be via the GOT.

The creation of multiple GOT sections so that all large code model
sections, referred to as `.ltext` are within range of a GOT is similar
to veneer (AKA stub, AKA thunk) pool placement, with the additional
complication that a GOT section is RELRO so addtional program headers
are required. In this document we refer to a GOT interleaved into a
`.ltext` section as `.got.ltext`.

::
   .ltext (up to 4 GiB) of .ltext sections
   .got.ltext (on page boundary, size is multiple of page-size)
   .ltext (up to 8 GiB) of .ltext sections
   .got.ltext (on page boundary, size is multiple of page-size)
   ...

Single GOT only
^^^^^^^^^^^^^^^

If the static linker only supports one GOT, the tradional `.got`, then
the maximum program size using this strategy is 8 GiB with up to 4 GiB
before the `.got` and 4 GiB after it.

Using the addressing mode in `Forming a 37-bit offset`_ to access the
GOT results in something like:

.. code-block:: asm

  .L0:
     adr    x0, :got_nc: var
     mov    x1, :gotpcrel_37_22_nc: var - (.L0 - .)
     add    x0, x0, x1, lsl 21
     ldr    x0, [x0]

With the same note that the operators and corresponding relocations
are not yet defined by the ABI.

With optimisation when the GOT entry is within range to:

.. code-block:: asm

  adrp x0, :got: var
  ldr  x0, [x0, :got_lo12: var]
  nop
  nop

As most `.got` entries are pointers to code or data, it is common to
immediately load from the pointer. This could be rolled into the
optimisation if the load were immediataly after the GOT access.

With a potentially expensive operation to access the GOT, when there
are multiple `.got` accesses in a function it may be better to load the
base of the `.got` and use a pair of `movz`, `movk` to construct a 32-bit
offset from the base of the `.got`.

Assumptions made for the rest of this document
----------------------------------------------

* The preferred option for large code model is to use GOT addressing
  rather than making larger pc-relative offsets.

* The static linker will support multiple GOT sections in the same ELF
  file.

* The static linker will use the same layout as the x86_64 large code
  model. With a single consolidated section for each of the
  conventionally named large code model sections (like `.ltext`). This
  does not preclude a static linker using a more optimal layout
  permitting more optimisations.

Large code model sections
-------------------------

Identifying sections as large-model-sections, or just large sections
for short, enables the linker to separate out the large sections and
place them after sections that may have been compiled with the small
code model. Moreover it may permit a static linker to permit
additional optimisations if large sections obey additional
constraints.

Requirements for a large section
================================

A large section must follow the large code model conventions for
linker optimisation. See later section on `Linker Optimisation AKA
Relaxation`_ for details.

A large section must make no use of the following pc-relative
relocations:

* ``R_AARCH64_LD_PREL_LO19``
* ``R_AARCH64_ADR_PREL_LO21``
* ``R_AARCH64_ADR_PREL_PG_HI21``
* ``R_AARCH64_PREL32``

Nor may the large section be a relocation target of another section.

As an object producer is unaware of references from other translation
units, only the static linker can fully determine whether a section
fulfills the requirements of a large section. See the later section on
`Demotion of large code model sections`_ for what a static linker can do.

Identifying a large section
===========================

The naming convention for large sections has a .l prefix in the
section name. So .text becomes .ltext, .rodata becomes .lrodata etc.

The main purpose of naming conventions is pattern matching in linker
scripts.

These are the same conventions as the `X86_64`_ code model.

If adopted by ELF, large sections will be given the ``SHF_LARGE`` flag
https://github.com/xinuos/gabi/issues/14 this will permit the
static-linker to recognise arbitary section names as large sections.

For an output section, ``SHF_LARGE`` is only propagated if all the
input sections have ``SHF_LARGE``.

Linker Optimisation AKA Relaxation
==================================

For addresses in the same link-unit (executable or shared-library) the
static-linker is able to overwrite more expensive, longer-range,
code-sequences with faster shorter-range ones.

Existing optimisations are documented in `AAELF64`_. In particular a
GOT access can be optimised to a pc-relative access:

.. code-block:: asm

  adrp  x0, :got: symbol            // R_AARCH64_ADR_GOT_PAGE
  ldr   x0, [x0 :got_lo12: symbol]  // R_AARCH64_LD64_GOT_LO12_NC

  // after optimization:

  adrp  x0, symbol                  // R_AARCH64_ADR_PREL_PG_HI21
  add   x0, x0, :lo12: symbol       // R_AARCH64_ADD_ABS_LO12_NC

This can mitigate some of the expense of a GOT access.

With the exception of the `.tlsdescall` sequence the instruction
sequences presented so far do not have to be contiguous, and
code-generators may have branch targets into the middle of the
sequences. These conditions can inhibit optimisation as the static
linker can only optimise when it can prove the transformation is safe.

Requirements on code-generators for large code model sections
=============================================================

Lage code model sections using any optimisable sequence added for the
large code model must emit optimisable sequences contiguously, with
branches into the sequence not permitted.

Requiring that optimisation candidate instruction sequences are emited
contiguously and that there are no branch targets in the middle of the
instruction sequences, will maximise the amount of linker
optimisation, and open up the possibility of further
optimisations. For example, a common operation is to load an address
from the GOT and immediately load from that address.

.. code-block:: asm

      adrp  x0, :got: symbol            // R_AARCH64_ADR_GOT_PAGE
      ldr   x0, [x0 :got_lo12: symbol]  // R_AARCH64_LD64_GOT_LO12_NC
      ldr   x0, [x0]

      // after optimization:

      adrp  x0, symbol                  // R_AARCH64_ADR_PREL_PG_HI21
      ldr   x0, [x0, :lo12: symbol]     // R_AARCH64_LDST64_ABS_LO12_NC
      nop

An alternative way to inform static linkers that sequences are always
contiguous is to introduce new relocation directives that can only be
used if an instruction sequence meets the requirements for being
optimised.

Requirements on static linkers for large code model sections
============================================================

* Placing large code model sections in separate Output Sections,
  either by naming convention for recognised sections like `.ltext` or
  presence of `SHF_LARGE`.

* Inserting sufficient `.got.ltext` sections so that every `.ltext`
  section is within 4 GiB of a GOT. This may require

* The generated `.got.ltext` sections need to be max-page-size aligned
  and have a size that is a multiple of max-page-size.

* `PT_GNU_RELRO` headers need to be created for the `.got.ltext`
  sections, as well as `PT_LOAD` segments with `PF_R` and `PF_W`
  permissions.

Requirements on loaders for large code model sections
=====================================================

* Loaders must support more than one `PT_GNU_RELRO` program header.

Demotion of large code model sections
-------------------------------------

Relocatable objects built with the small-code-model may use
relocations to large-code-model sections that are prohibited by the
definition of large sections.

References from small to large-code-model sections can occur
unintentionally. In particular a COMDAT group that is instantiated by
both a small-code-model and large-code-model, with the
large-code-model appearing first and being selected by the linker will
result in references from small to large.

The recommended way of handling references from small-code-model to
large-code-model is for the static linker to demote any section that
an object producer has deemed large, to non-large, if there are any
prohibited relocations to that section.

Demoting a large section involves:

* Stripping any `.l` prefix so that `.ltext` becomes `.text`

* Removing the `SHF_LARGE` flag.

The demotion must occur before input sections are assigned to output
sections.

A static linker that does not support demotion of large code model
sections may not be able to link some inputs compiled with the
small-code-model.

A static linker that supports demotion, can also support promotion of
small-code-model sections to large, meaning that object producers
don't have to use section naming conventions or use
`SHF_LARGE`. However it is not certain that the ABI can require
demotion.

Efficient access to constants
-----------------------------

If all constants are placed in read-only data sections such as
`.ldata` then in a large program many accesses will need to be made
via the GOT which could be expensive.

Constants that are not address significant can be instanced alongside
the GOT, or potentially in the GOT!

If the ABI requires static-linker to guarantee the range to constants
then pc-relative addressing can be used. However it will be safer to
emit got-relative relocations and rely on linker optimisation to use
pc-relative when in range.

Option 1: AArch32 style literal pools
*************************************

AArch32 code prior to the introduction of `MOVT` and `MOVW`
instructions used literal pools for most constants. Literal pools are
inline literal data that is accessed pc-relative using the ldr
(literal) instruction.

AArch64 could make use of literal pools for numeric and string
constants. This would give quick access to local constants at the cost
of:

* Losing execute-only from code-sections. Pollution of icache with
  data.

* Duplication of constants between functions. Given range of AArch64
  (literal) a static linker could potentially merge constants.

A compiler can always choose to use literal pools, independently of
any of the other options. No GOT reference is required, and in many
cases a single ldr (literal) can be used to access.

Option 2: Instantiate SHF_MERGE sections alongside .got instance
****************************************************************

The normal way to deduplicate numeric and string constants at link is
to use `SHF_MERGE` and `SHF_STRINGS` sections. The linker is
permitted, but not required, to merge identical entries in `SHF_MERGE`
sections and tail share strings in `SHF_STRINGS` sections.

If each `SHF_MERGE` section were instantiated multiple times alongside
the local .got.ltext instantiation, with only the relocations in range
considered then we would retain the same speed of access as the small
code-model, with the downside of some data duplication.

If the duplicated `SHF_MERGE` sections were adjacent to the .got.ltext
then these could be included in the same RELRO page(s), at the cost of
losing shareability between processes.

.ltext.1 (executable)
.got.ltext.1 (RELRO)
.rodata.ltext.1 (read-only)
.ltext.2 (executable)
.got.ltext.2 (RELRO)
.rodata.ltext.2 (read-only)

This should work for any constant that can be placed in a mergeable
section. However it requires additional complexity in the linker that
upstream may not accept.

Option 3: Use the .got.ltext (for some constants)
*************************************************

The .got is an array of 64-bit entries. While it typically contains
pointers, in some cases such as with some TLS relocations the .got
entry contains arbitrary data.

With an appropriate relocation the static-linker could instantiate data
in a .got.ltext entry. Without a substantial ELF extension this would be
limited to what could fit into what we can describe with a new relocation
directive (64-bit Symbol Value, 64-bit Relocation Addend). As the .got
entries are 8-byte aligned this could be used for values that are at most
8-byte aligned.

To get a unique entry per .got.ltext the value of the constant would
need to be mangled into the symbol name as static linkers create one
entry per unique symbol.

A disadvantage of using the .got.ltext is that it is RELRO which
prevents sharing across processes.

Overall using the .got does not seem attractive as a general solution,
but if the majority of immediates are single 64-bit constants then
this is relatively cheap to implement in the linker.

Option 4: A linked .rodata section
**********************************

Using a similar idea to Option 2 and can be combined with it. We have
a `.ltext.rodata` instance adjacent to the `.got.ltext`. This
OutputSection will contain `.lrodata` sections that are linked to
.text sections (via the `sh_link` field). The compiler can create
linked `.rodata` sections and know that these will be placed within 4
GiB.

Will need to be an ELF extension so that the static linker knows where
to place the`.rodata` section.

A static linker can infer something similar from relocations
alone. For example, if the `.lrodata` is only reachable from a single
`.ltext` section via range limiting relocations then `.lrodata` must
be placed within 4 GiB of `.ltext`.

.eh_frame sections
------------------

See `EHFRAME`_ for `.eh_frame` specification.

The static linker collates all input `.eh_frame` sections into one
`.eh_frame` output section and generates a `.eh_frame_hdr` section
that acts as an accelerator table for the runtime.

The `.eh_frame` section data contains CIEs and FDEs. With the CIEs
containing information common to multiple FDEs, including the encoding
of the pointers in the FDEs.

Small-code-model objects may use a pointer encoding of a 32-bit
`DW_EH_PE_sdata4` offset. Large-code-model objects use a 64-bit
`DW_EH_PE_sdata8` offset. A `.eh_frame` output section may contain a
mixture of pointer encodings.

A `.eh_frame` section that contains 32-bit offsets, visible to the
static linker as ``R_AARCH64_PREL32`` relocations, then it must be
placed within range of the `.text` output section containing
small-code model sections. A smart static-linker may choose to
re-encode the 32-bit pointers to 64-bit offsets to remove this
restriction. However this may have a non-trivial impact on link-time.

If the `.eh_frame` contains 64-bit pointer encodings then the linker
generated `.eh_frame_hdr` section must also use 64-bit pointer
encodings.

Multiple .eh_frame sections?
============================

Instead of combining all `.eh_frame` input sections into a single
`.eh_frame` output section. A static linker could produce a
`.eh_frame` section containing 32-bit CIE/FDEs and a `.leh_frame`
section containing 64-bit CIE/FDEs. Each section would have its
corresponding `.eh_frame_hdr` section and program header.

The `.eh_frame` section would need to be placed within range of the
small-code-model `.text` sections, but the `.leh_frame` section would
have no restrictions.

The possible downsides of this are:

* Existing runtimes like LLVM libunwind are not expecting an ELF file
  to have two `.eh_frame` tables and would need to be updated.

* There is no guarantee that a `.eh_frame` input section will use a
  uniform 32 or 64-bit encoding, to be safe the static linker will
  need to check.

Appendix: Linker Scripts
------------------------

Internally to a linker, a single `.ltext` output section from a
linker script such as the following, adapted from the GNU ld default
linker script for .text:

::

  .ltext           :
  {
    *(.ltext.unlikely .ltext.*_unlikely .ltext.unlikely.*)
    *(.ltext.exit .ltext.exit.*)
    *(.ltext.startup .ltext.startup.*)
    *(.ltext.hot .ltext.hot.*)
    *(SORT(.ltext.sorted.*))
    *(.ltext .ltext.*)
    /* .gnu.warning sections are handled specially by elf.em.  */
    *(.gnu.warning)
  }

Will normally result in a single output section called `.ltext` in the
ELF file. When `.ltext`

The extra `.got.ltext` sections for the `.ltext` output sections are
linker generated and not represented in the linker script.

As long as the names for these extra GOT sections don't match `.got`,
`.got.plt` they won't be selected by existing linker-scripts

How could .ltext and .got.ltext sections be described manually with a linker script?
====================================================================================

In existing linker script syntax we would be looking for something like:

::

  .ltext.1 : {
    *(.ltext .ltext.*)
    ALIGN(PAGESIZE)
  }
  .got.ltext1 : {
    *(.got.ltext1)
    ALIGN(PAGESIZE)
  }
  .ltext.2 : {
    *(.text .ltext.*)
    ALIGN(PAGESIZE)
  }
  .got.ltext2 : {
    *(.got.ltext2)
    ALIGN(PAGESIZE)
  }
  ...

This would not work with current linker script syntax as the first
`*(.ltext .ltext.*)` pattern would match all the sections potentially
placing the `.got.ltext*` sections out of range.

LLD has a feature called section classes. These are used in embedded
systems to distribute input sections across more than one output
sections, with the first matching output section selected if it has
enough space in the MEMORY region it is assigned to. Section classes
could be adapted with an implicitly (or explicitly) defined 4 GiB
Memory region per-large-code model output section.

::

  class(largetext) : { *(.ltext .ltext.*) }
  .ltext.1 : {
    class(largetext)
    ALIGN(PAGESIZE)
  }
  .got.ltext1 : {
    *(.got.ltext1)
    ALIGN(PAGESIZE)
  }
  .ltext.2 : {
    class(largetext)
    ALIGN(PAGESIZE)
  }
  .got.ltext2 : {
    *(.got.ltext1)
    ALIGN(PAGESIZE)
  }
  ...

A disadvantage compared to the linker generating this from a single
`.ltext` output section is that the static linker knows how many
`.got.ltext` output sections it needs.

A further disadvantage is that incorrect user defined selection
patterns may match the `.got.ltext*` sections, putting them in a wrong
position.

Multiple .ltext output sections?
================================

With a single large-code-model output section containing the output
section size alone can be used to determine the placement of
`.got.ltext` sections.

However if there are several large-code-model output sectionsit is
possible that no single large-code-model output section will be over 4
GiB but collectively the large-code-model output sections are over 4
GiB. Furthermore, with a linker script the large-code-model output
sections may not be contiguous.

To avoid interacting with linker scripts, a static-linker may restrict
itself to adding `.got.ltext` sections as if it were splitting a > 4 GiB
large-code-model output section. In this situation no new orphan
sections are created and the placement of the `.got.ltext` is always the
end of the large code model section.

Interaction with the PHDRS command
==================================

In normal operation a static linker will automatically generate
suitable program headers. The linker script syntax permits a user to
manually specify the program headers with the `PHDRS`_ command.

Output sections can be assigned to more than one program header. RELRO
sections are assigned to a ``PT_LOAD`` and a ``PT_GNU_RELRO`` program
header.

With the static linker breaking up the `.ltext` output section into an
arbitrary number of smaller `.ltext` output sections interspersed with
RELRO `.got.ltext` output sections, it won't be possible to manually
map each individual output section as these generated Output Sections
won't be present in the linker script.

As a `.ltext` expanded into multiple smaller output sections, that are
necessarily contiguous in memory, the static linker should be able to
create the program headers for the individual output section, while
respecting the assignment.

::

  PHDRS {
    headers PT_PHDR PHDRS ;
    interp PT_INTERP ;
    text PT_LOAD FILEHDR PHDRS ;
    data PT_LOAD ;
    dynamic PT_DYNAMIC ;
    relro PT_GNU_RELRO
    ltext PT_LOAD ;
  }

  SECTIONS {
    ...
    .dynamic : { *(.dynamic) } :data :dynamic :relro
    .ltext : { *(.ltext) } :ltext
    ...
  }

The `ltext` program header assigned by PHDRS would be broken up by a
static linker into a contiguous range of smaller executable and RELRO
program headers.

If the split is manual, as in `How could .ltext and .got.ltext
sections be described manually with a linker script?`_ then no
alteration of `PHDRS` is needed as there is no splitting of output
section.

Recommendation
==============

The static linker should split large-code-model sections into `.ltext`
and `.got.ltext` and generate program headers automatically. There is
little, if any, benefit for the user to control the placement manually
and the risk of the link failing is high. If a genuine need arises
extra syntax can be defined.

Appendix: Alternative design, an executable as multiple shared objects
----------------------------------------------------------------------

Programs, if defined as the executable and their shared-library
dependencies can already exceed the limits of the small-code-model as
long as no single ELF file exceeds the limits.

An alternative for position independent executables is to layout the
ELF file as if it were multiple shared libries arranged consecutively
in memory.

::

  .text.1
  .plt.1
  .rodata.1
  .eh_frame.1
  .got.1
  .plt.got.1
  .data.1
  .bss.1

  .text.2
  .plt.2
  .rodata.2
  .eh_frame.2
  .got.2
  .plt.got.2
  .data.2
  .bss.2

  .text.3
  .plt.3
  .rodata.3
  .eh_frame.3
  .got.3
  .plt.got.3
  .data.3
  .bss.3
  ...

Each 2 GiB of code is within the limitations of the small code-model
so in theory we do not need to add a large-code-model to the compiler
and move all the work to the static linker. Or the small-code-model
objects would form the first set of sections, then the
large-code-model objects form the later sets.

Just using small-code-model has serious limitations:

* How does the static linker partition the sections? It must make sure
  that for each range-limited section, all the sections referenced
  from it are within range. There may be cases where there is no
  partitioning that can guarantee all relocations are in range.

* What about sections that an ELF file has at most one of? For
  example, expectations of runtimes for one `.eh_frame` section.

If we work on the assumption of mix of small and large-code-model
sections so that we can have a single instance of some output sections
then we end up with something like:

::

  .text.1
  .plt
  .rodata.1
  .eh_frame
  .got
  .plt
  .tdata
  .tbss
  .data.1
  .bss.1

  .ltext.2
  .lrodata.2
  .ltext.got.2
  .ldata.2
  .lbss.2

  .ltext.3
  .lrodata.3
  .ltext.got.3
  .ldata.3
  .lbss.3
  ...

This is not far from the existing proposal. The main difference is
.ldata and .bss output sections are interleaved with the `.ltext`
sections as well as the `.ltext.got` output sections.

More of the `.lrodata`, `.ldata` and `.lbss` would be within
optimisation range than with singular combined output sections. With
an opportunity for the static-linker to layout sections based on
maximising optimisation opportunities.

The main downside of this approach is extra complexity in the
linker. However this is quality of implementation in the linker and
not ABI.

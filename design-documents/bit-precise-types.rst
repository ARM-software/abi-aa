..
   Copyright (c) 2023, Arm Limited and its affiliates.  All rights reserved.
   CC-BY-SA-4.0 AND Apache-Patent-License
   See LICENSE file for details

Rationale Document for ABI related to the C23 _BitInt type.
***********************************************************

Preamble
========

Background
----------

This document describes the rationale behind the ABI choices made for using the
bit-precise integral types defined in C2x.  These are ``_BitInt(N)`` and
``unsigned _BitInt(N)``.  These are defined for integral ``N`` and each ``N`` is
a different type.

The proposal for these types can be found in following link.
https://www.open-std.org/jtc1/sc22/wg14/www/docs/n2763.pdf

As the rationale in that proposal mentioned, some applications have uses for a
specific bit-width type.  In the case of writing C code which can be used to
determine FPGA hardware these specific bit-width types can lead to large
performance and space savings.

From the perspective of the Arm ABI we have some trade-offs and decisions to
make:

- We need to choose a representation for these objects in registers.
- We need to choose a representation, size and alignment of these objects in memory.

The main trade-offs we have identified in this case are:

- Performance of different C-level operations.
- Whether certain hardware-level atomic operations are possible.
- Size cost of storing values in memory.
- General familiarity of programmers with the representation.

Since this is a new type there is large uncertainty on how it will be used by
programmers in the future.  Decisions we make here may also influence future
usage.  Nonetheless we must make trade-off decisions with this uncertainty.  The
below attempts to analyze possible use-cases to make our best guess as to how
these types may be used when targeting Arm CPU's.


Use-cases known of so far
-------------------------

There seem to be two different regimes for these types.  The "small" regime
where bit-precise types could be stored in a single general-purpose register,
and the "large" regime where bit-precise types must span multiple
general-purpose registers.

Here we discuss the use-cases for bit-precise integer types that we have
identified or been alerted to so far.


C code to describe FPGA behavior
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

A major motivating use-case for this new type is to aid writing C code which
describes the desired behavior of an FPGA.  Without the availability of the new
``_BitInt`` type such C code would semantically have much wider types than
necessary when performing operations, especially given that operations on small
integral types promote their operands to ``int``.

If these wider than necessary operations end up in the FPGA they would use many
more many more logic gates than necessary.  Using ``_BitInt`` allows programmers
to write code which directly expresses what is needed.  This can ensure the FPGA
description generated saves space and has better performance.

The notable thing about this use-case is that though the C code may be run on an
Arm architecture (e.g. for testing), the most critical use is when transferred
to an FPGA (i.e. not an Arm architecture).

That said, if the operation that this FPGA performs becomes popular there may be
a need to run the code directly on CPU's in the future.

The requirements on Arm ABI's from this use-case are relatively small since the
main focus is around running on an FPGA.  We believe it adds weight to both the
need for performance and familiarity of programmers.  This belief comes from the
estimate that this may lead to bit-precise types being used in performance
critical code in the future, and that it may mean that bit-precise types are
used on Arm architectures when testing FPGA descriptions (where ease of
debugging can be prioritized).


24-bit Color
~~~~~~~~~~~~~

Some image file-types use 24-bit color.  The new ``_BitInt`` type may be used to
hold such information.

As it stands we do not know of any specific reason to use a bit-precise integral
type as opposed to a structure of three bytes for these data types.

If used for 24-bit color we believe that the performance of standard arithmetic
operations would not be critical.  This because each 24-bit pixel usually
represents three 8-bit colors so operations would unlikely be performed on the
single value as a whole.

We also believe that if used for 24-bit color it would be helpful to specify a
size and alignment scheme such that an array of ``_BitInt(24)`` is well packed.


Networking Protocols
~~~~~~~~~~~~~~~~~~~~

Many networking protocols have packed structures in order to minimize data sent
over the wire.  In order to be perfectly packed the code will need to use
bit-fields rather than bit-precise types for storage, since the bit-precise types
must be accessible and hence at least byte-aligned.

The incentives to use bit-precise integral types for networking code would be in
order to maintain the best representation of the operation that is being
performed.

One negative of using bit-precise integral types for networking code would be
that idioms like ``if (x + y > max_representable)`` where ``x`` and ``y`` have
been loaded from small bit-fields would no longer be viable.  We have seen such
idioms for small values in networking code in the Linux kernel.  These are
intuitive to write but if ``x`` and ``y`` were to bit-precise types would not
work as expected.

If used in code handling networking protocols, our estimate is that the
arithmetic manipulation performed on such values will not be the main
performance bottleneck in networking protocols.  This estimation comes from the
belief that networking is often IO bound, and that small packed values in
networking protocols tend to have limited arithmetic performed on them.

Hence we believe that ease of debugging of values in registers may be more
critical than performance concerns in this use-case.


To help the compiler optimize (e.g. for auto vectorization)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The behavior that bit-precise types do not automatically promote to an ``int``
during operations could remove some casts which are necessary for C semantics
but can obscure the intention of a users code.  One place this may help is in
auto vectorization, where the compiler must be able to see through intermediate
casts in order to identify the operations being performed.

The incentive for this use-case is an increased likelihood of the compiler
generating optimal autovectorized code.

Points which might imply less take-up of this use-case are that the option to
use compiler intrinsics are there for programmers which want to put in extra
effort to ensure good vectorization of a loop.  This means that using
bit-precise types would be a mid-range option providing less-guaranteed codegen
improvement for less effort.

The ABI should not have much of an affect on this use-case directly, since the
optimization would be done in the target-independent part of compilers and the
eventual operations in auto vectorized code would be acting on vector machine
types.

That said, bit-precise types would also be used in the surrounding code.  Given
that in this use-case these types are added for performance reasons it seems
reasonable to guess that this concern around performance would apply to the
surrounding code as well.  Hence it seems that this use-case would benefit from
choosing performance concerns.

In this use-case the programmer would be converting a codebase using either 8
bit integers or 16 bit integers to a bit-precise type of the same size.  Such a
codebase may include calls to variadic functions (like ``printf``) in
surrounding code.  Variadic functions like this may be missed when changing
types in a codebase, so it would be helpful if the bit-precise machine types
passed matched what the relevant standard integral types looked like in order to
avoid extra difficulties during the conversion.  The C semantics require that
variadic arguments undergo standard integral promotions.  While ``int8_t`` and
the like undergo integral promotion, ``_BitInt`` does not.  Hence this use-case
would benefit from having the representation of ``_BitInt(8)`` in the PCS match
that of ``int`` and similar for the ``16`` bit and unsigned variants (which
implies having them sign- or zero-extended).

One further point around this use-case, is that decisions which do not affect 8
and 16 bit types would not affect this use-case.


For representing cryptography algorithms
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Many cryptography algorithms perform operations on large objects.  It seems
to be that using a ``_BitInt(128)`` or ``_BitInt(256)`` could express
cryptographic algorithms more concisely.

For symmetric algorithms the existing block cipher and hash algorithms do not
tend to operate on chunks this size as single integers.  This seems like it will
remain the case due to CPU limitations and a desire to understand the
performance characteristics of written algorithms.

For asymmetric algorithms something like elliptic curve cryptography seems like
it could gain readability from using the new bit-precise types.  However there
would likely be concern around whether code generated from using these types is
guaranteed to use constant-time operations.

This use-case would only be using "large" bit-precise types.  Moreover all
relevant sizes are powers of two.

Translating some more esoteric languages to C
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

At the moment there exist some high-level languages which support arbitrary
bit-width integers.  Translating such languages to C would benefit from the new
C type.

We do not know of any specific use-case within these languages other than for
cryptography algorithms as above.  Hence the trade-offs in this space are
assumed to be based on the trade-offs from the cryptography use-case above.

We estimate the use of translating a more esoteric language to C to be less
common than writing code directly in C.  Hence the weighting of this use-case in
our trade-offs is correspondingly lower than others.

Possible transparent BigNum libraries
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

We have heard of interest in using the new bit-precise integer types to
implement transparent BigNum libraries in C.

Such a use-case unfortunately does not directly correspond to what kind of code
will be using this (e.g. would this be algorithmic code or I/O bound code).
Given the mention of 512x512 matrices in the comment where we heard of this we
assume that in general such a library would be CPU-bound code.

Hence we assume that the main consideration here would be performance.


Summary of use-case trade-offs
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

In our estimation, the C to FPGA use case seems to be the most promising.  We
estimate that the use in this space will be a great majority of the use of this
new type.

Uses for cryptography, networking, and in order to help the compiler optimize
certain code seem like they are large enough to consider but not as widespread.

For the C to FPGA use case, the majority of the use is not expected to be seen
on Arm Architectures.  For helping the compiler optimize code we expect to only
see bit-precise types with sizes matching that of standard integral types.
Cryptographic uses are only expected on "large" sizes which are powers of two.
Networking uses are likely to be using bit-fields for in-memory representations.

All use-cases would have concerns around performance and the familiarity of
representations.  There does not seem to be a clear choice to prefer one or the
other.


Alignment and sizes
-------------------

Options and their trade-offs
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

These types must be at least byte-aligned so they are addressable, and at least
rounded to a byte boundary in size for ``sizeof``.

"Small" regime
//////////////
For the "small" regime there are 2 obvious options:

A. Byte alignment.
B. Alignment and size "as if" stored in the next-largest Fundamental Data Type.
   (Where the Fundamental Data Types are defined in the relevant PCS documents).

Option ``A`` has the following benefits:

- Better packing in an array of ``_BitInt(24)`` than an array of ``int32_t``.
  This is more relevant for bit-precise types than others since these types have
  an aesthetic similarity to bit-fields and hence programmers might expect good
  packing.

Option ``B`` has the following benefits (both following from the alignment being
greater than or equal to the size of the object in memory):

- Avoid a performance hit since loading and storing of these "small" sized
  ``_BitInt``'s will not cross cache boundaries.
- Atomic loads and stores can be made on these objects.
- The representation of bit-precise types of the same size as standard integer
  types will have the same alignment and size in memory.

In the use-cases we have identified above we did not notice any special need for
tight packing.  All of the use-cases we identified would benefit from better
performance characteristics, and the use-case to help the compiler in optimizing
some code would benefit greatly from ``_BitInt(8)`` having the same alignment
and size as a ``int8_t``.

Hence for "small" sizes we are choosing to define a ``_BitInt(N)`` size and
alignment according to the smallest Fundamental Data Type which has a bit-size
greater or equal to ``N``.  Similar for ``unsigned`` versions.


"Large" regime
//////////////
For "large" sizes the only approach considered has been to treat these
bit-precise types as an array of ``M`` sized chunks, for some ``M``.

There are two obvious choices for ``M``:

A. Register sized.
B. Double-register sized.

Option ``A`` has the following benefits:

- This would mean that the alignment of a ``_BitInt(128)`` on AArch64 matches
  that of other architectures which have already defined their ABI.  This could
  reduce surprises when writing portable code.
- Less space used for half of the values of ``N``.
- Multiplications on large ``_BitInt(N)`` can be logically done on the limbs of
  size ``M``, which should result in a neater compiler implementation.  E.g.
  for AArch64 there is a ``SMULH`` which could be used as part of a
  multiplication on an entire limb.

Option ``B`` has the following benefit:

- Would allow atomic operations on types in the range between register
  and double-register sizes.
  This is due to the associated extra alignment allowing operations like
  ``CASP`` on aarch64 and ``LDRD`` on aarch32.  Similarly this would allow
  ``LDP`` and ``STP`` single-copy atomicity on architectures with the LSE2
  extension.
- On AArch32 a ``_BitInt(64)`` would have the same alignment and size as an
  ``int64_t``, and on AArch64 a ``_BitInt(128)`` would have the same alignment
  and size as a ``__int128``.
- Double-register sized integers match the largest Fundamental Data Types
  defined in the relevant PCS architectures for both platforms.  We believe
  that that developers familiar with the AArch64 ABI would find this mapping
  less surprising and hence make less mistakes.  This also includes those
  working at FFI boundaries interfacing to the C ABI.

The "large" size use-cases we have identified so far are of power-of-two sizes.
These sizes would not benefit greatly from the positives of either of the
options presented here, with the only difference being around the implementation
of multiplication.

Our estimate is that the benefits of option ``B`` are more useful for sizes
between register and double-register than those from option ``A``.  This is not
considered a clear-cut choice, with the main point in favour of option ``A``
being a smaller difference from other architectures psABI choices.

Other variants are available, such as choosing alignment and size based on
register sized chunks except for the special case of the double-register sized
_BitInt.  Though such variants can provide a good combination of the properties
above we judge them to have an extra complexity of definition and associated
increased likelyhood of mistakes when developers code relies on ABI choices.

Based on the above reasoning, we would choose to define the size and alignment
of ``_BitInt(N > [register-size])`` types by treating them "as if" they are an
array of double-register sized Fundamental Data Types.

Representation in bits
----------------------

There are two decisions around the representation of a "small" ``_BitInt`` that
we have identified.  (1) Whether required bits are stored in the least
significant end or most significant end of a register or region in memory. (2)
Whether the "remaining" bits after rounding up to the size specified in
`Alignment and sizes`_ are specified or not.  The choice of *how* "remaining"
bits would be specified would tie in to the choice made for (1).


Options and their trade-offs
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

We have identified three viable options:

A. Required bits stored in most significant end.
   Not-required bits are specified as zero at ABI boundaries.
B. Required bits stored in least significant end.
   Not-required bits are unspecified at ABI boundaries.
C. Required bits stored in least significant end.
   Not-required bits are specified as zero- or sign-extended.

While it would be possible to make different requirements for bit-precise
integer types in memory vs in registers, we believe that the combined negatives
of the choice are reason enough to not look into the option.  These negatives
being that code would have to perform a transformation on loading and storing
values, and that different representations in memory and registers is likely to
cause programmer confusion.

Similarly, it would be possible to define a representation in registers that
does something like specifying bits ``[2-7]`` of a ``_BitInt(2)`` but leaves
bits ``[8-63]`` unspecified.  This would seem to choose the worst of both worlds
in terms of performance, since one must both ensure "overflow" from an addition
of ``_BitInt(2)`` types does not affect the specified bits **and** ensure that
the unspecified bits above bit number 7 do not affect multiplication or division
operations.  Hence we do not look at variations of this kind.

For option ``A`` there is an extra choice around how "large" values are stored.
One could either have the "padding" bits in the least significant "chunk", or
the most significant "chunk".  Having these padding bits in the least
significant chunk would mean require something like a widening cast would
require updating every "chunk" in memory, hence we assume large values of option
``A`` would be represented with the padding bits in the most significant chunk.


Option ``A`` has the following benefits:

- For small values in memory, on AArch64, the operations like ``LDADD`` and
  ``LD{S,U}MAX`` both work (assuming the relevant register operand is
  appropriately shifted).

- Operations ``+,-,%,==,<=,>=,<,>,<<`` all work without any extra instructions
  (which is more of the common operations than other representations).

It has the following negatives:

- This would be a less familiar representation to programmers.  Especially the
  fact that a ``_BitInt(8)`` would not have the same representation in a
  register as a ``char`` could cause confusion (e.g. when debugging, or writing
  assembly code).  This would likely be increased if other architectures that
  programmers may use have a more familiar representation.

- Operations ``*,/``, saving and loading values to memory, and casting to
  another type would all require extra cost.

- Operations ``+,-`` on "large" values (greater than one register) would require
  an extra instruction to "normalize" the carry-bit.

- If used in calls to variadic functions which were written for standard
  integral types this can give surprising results.


Option ``B`` has the following benefits:

- For small values in memory, the AArch64 ``LDADD`` operations work naturally.

- Operations ``+,-,*,<<``, narrowing conversions, and loading/storing to memory
  would all naturally work.

- On AArch64 this would most likely match the expectation of developers, and
  e.g. a ``_BitInt(8)`` would have the same representation as a ``char`` in
  registers.

It has the following negatives:

- The AArch64 ``LD{S,U}MAX`` operations would not work naturally on small values
  of this representation.

- Operations ``/,%,==,<,>,<=,>=,>>`` and widening conversions on operands coming
  from an ABI boundary would require masking the operands.

- On AArch32 this could cause surprises to developers, given that on this
  architecture small Fundamental Data Types are have zero- or sign-extended
  extra bits.  So a ``char`` would not have the same representation as a
  ``_BitInt(8)`` on this architecture.

- If used in calls to variadic functions which were written for standard
  integral types this can give surprising results.


Option ``C`` has the following benefits:

- For small values in memory, the AArch64 ``LD{S,U}MAX`` operations work
  naturally.

- Operations ``==,<,<=,>=,>,>>``, widening conversions, and loading/storing to
  memory would all naturally work.

- On AArch32 this could match the expectation of developers, with a
  ``_BitInt(8)`` in a register matching the representation of a ``char``.

- If used in variadic function calls, mismatches between ``_BitInt`` types and
  standard integral types would not cause as much of a problem.

It has the following negatives:

- The AArch64 ``LDADD`` operations would not work naturally.

- Operations ``+,-,*,<<`` would all cause the need for masking at an ABI
  boundary.

- On AArch64 this would not match the expectation of developers, with
  ``_BitInt(8)`` not matching the representation of a ``char``.

Summary, suggestion, and reasoning
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Overall it seems that option ``A`` is more performant for operations on small
values.  However, when acting on "large" values (i.e. greater than the size of
one register) it loses some of that benefit.  Storing to and from memory would
also come at a cost for this representation.  This is also likely to be the most
surprising representation for developers on an Arm platform.

Between option ``B`` and option ``C`` there is not a great difference in
performance characteristics.  However it should be noted that option ``C`` is
the most natural extension of the AArch32 PCS rules for unspecified bits in a
register containing a small Fundamental Data Type, while option ``B`` is the
most natural extension of the similar rules in AArch64 PCS.  Furthermore, option
``C`` would mean that accidental misuse of a bit-precise type instead of a
standard integral type should not cause problems, while ``B`` could give strange
values.  This would be most visible with variadic functions.

As mentioned above, both performance concerns and a familiar representation are
valuable in the use-cases that we have identified.  This has made the decision
non-obvious.  We have chosen to favor representation familiarity.

Choosing between ``C`` and ``B`` is also non-obvious.  It seems relatively clear
to choose option ``C`` for AArch32.  We choose option ``B`` for AArch64 to
prefer that across most ABI boundaries a ``char`` and a ``_BitInt(8)`` have the
same representation, but acknowledge that this could cause surprise to
programmers when using variadic functions.

..
   Copyright (c) 2023, Arm Limited and its affiliates.  All rights reserved.
   CC-BY-SA-4.0 AND Apache-Patent-License
   See LICENSE file for details

.. _ARMARM: https://developer.arm.com/documentation/ddi0487/latest
.. _PAPER: https://doi.org/10.1109/CGO57630.2024.10444836

Rationale Document for C11 Atomics ABI.
***************************************

Preamble
========

Background
----------

This document describes the rationale behind the ABI choices made for mapping
from C11 atomic operations to Arm AArch64 assembly sequences.

From the perspective of the Arm ABI we have some decisions to
make:

- We need to choose a baseline ABI (a set of mappings), that is compatible for all versions of the Armv8 architecture.
- The mappings should cover atomic accesses of various sign, size, and type accessible through C11 atomic operations using compiler profiles.

The main trade-offs we have identified or have been made aware of are:

- Performance of different mappings versus compatibility with all architectures.
- Whether certain compiler operations lead to unexpected behaviours.

As motivated by the use cases expanded upon below:

- The need for a baseline ABI
- Knowing when an implementation departs from that baseline
- Backwards compatibility of atomics as new mappings are added
- Compatibility between compilers and runtimes
- The need to constrain optimisations on specific atomic operations
- Documenting the interoperable mappings
- providing a basis upon which ABI compatibility can be tested.

References
----------

This document refers to, or is referred to by, the following documents.

.. table::

  +-------------+--------------------------------------------------------------+-----------------------------------------------------------------------------+
  | Ref         | External reference or URL                                    | Title                                                                       |
  +=============+==============================================================+=============================================================================+
  | ARMARM_     | DDI 0487                                                     | Arm Architecture Reference Manual Armv8 for Armv8-A architecture profile    |
  +-------------+--------------------------------------------------------------+-----------------------------------------------------------------------------+
  | PAPER_      | CGO paper                                                    | Compiler Testing with Relaxed Memory Models                                 |
  +-------------+--------------------------------------------------------------+-----------------------------------------------------------------------------+



Note: At the time of writing C23 is not released, as such ISO C17 is considered
the latest published document.

Use-cases known of so far
-------------------------


A Baseline: Describing current implementations
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The ABI we provide is a baseline specification that compilers should or do implement.
The ABI provides a grounds to be compatible across all versions of the Armv8 architecture. Most
of the mappings in the ABI are already implemented in LLVM and GCC and this ABI ratifies
a decade of established practice, and provides alternatives where the current practice
is incompatible.


Sub-ABIs and ABI-islands: Departing from the baseline (or 'mainland')
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

We do *not* require that compilers implement this ABI. Implementers can specify their own
ABI, whether it is a subset of the allowed mappings of the baseline ABI (a sub-ABI), or 
uses different mappings altogether (an ABI-island). Currently, sub-ABIs and ABI-islands implicitly
arise with each new architecture release, and implementers quickly find new candidate mappings
that are performant on their machines. Such mappings are proposed or added to mainstream
compilers. However due to the lack of a baseline specification or widespread
concurrency expertise, testing such mappings has been a challenge and concurrency bugs have been
unintentionally introduced into compilers when new mappings are added.

We need a baseline ABI in order to determine if a given sub-ABI respects or departs
from the baseline. Adding command-line options is a logical consequence of defining such an ABI, 
and makes it possible to track ABI compatibility of concurrent programs at compile or link-time,
rather than runtime. It is the responsibility of the sub-ABI maintainer to ensure code built
under their ABI does not mix with code built under the baseline. But a baseline must exist 
for sub-ABI compatibility to be decided in the first place.

A baseline provides the means to describe or contain ABI-islands. Where a compiler implementation
departs from the baseline completely (an ABI-island), it would be the responsibility of the
maintainer of that implementation to ensure their programs are not mixed with programs built for 
baseline ABI compatibility, or provide adequate warnings at compile time. 

Further, numerous parties have asked the ABI team whether the same atomics mapping is correct. 
Writing down the known cases helps engineers answer these queries without the concurrency 
expertise required to come up with current compatible mappings. A future section of the ABI 
could document common queries received by the ABI team, in order to assist implementers and 
engineers with such issues.

Backwards Compatibility and New Architecture Features
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Put another way, A baseline ABI helps with the decisions of compatibility of new mappings.
Certain instructions (such as Load/Store-Pair instructions [ARMARM_]) have different
single-copy atomicity guarantees with respect to different architecture versions. A baseline
decides which assembly sequences can be composed correctly (at least as far as testing can decide).


Compatibility Between Compilers and Runtimes
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The above issues also apply when ensuring object files compiled with different compilers can be mixed. 
For instance LLVM and GCC code should be interoperable. At the time of writing we identified a number of
places where this does not apply, both when compiling to target the same architecture version, and when mixing
different (compatible) architecture versions. Further, the above issues are not limited to statically compiled 
code. We found one instance where proposed mappings implemented in a JiT compiler would not be interoperable 
with statically compiled code the runtime links against. Even if a JiT compiles under one set of mappings, and 
is not subject to an ABI, it may still depend on other libraries or components that do have an ABI.


Constrain optimisations
~~~~~~~~~~~~~~~~~~~~~~~

The frequency of this behaviour justifies collecting these cases together to outline why they should not occur. 
For example, consider the following Concurrent Program::

  // Shared-Memory Locations
  _Atomic int* x;
  _Atomic int* y;

  // Memory Order Parameter
  #define relaxed memory_order_relaxed
  #define release memory_order_release
  #define acquire memory_order_acquire

  // Threads of Execution
  void thread_0 () {
    atomic_store_explicit(x,1,relaxed);
    atomic_thread_fence(release);
    atomic_store_explicit(y,1,relaxed);
  }

  void thread_1 () {
    atomic_exchange_explicit(y,2,release);
    atomic_thread_fence(acquire);
    int r0 = atomic_load_explicit(x,relaxed);
  }


Under ISO C, the above Concurrent Program finishes execution in one of three
possible outcomes (a reference for this notation is found here [PAPER_])::

  { thread_1:r0=0; y=1; }
  { thread_1:r0=1; y=1; }
  { thread_1:r0=1; y=2; }

In this case the value read by the exchange on ``thread_1`` is not used, and a
compiler is free to remove references to unused data. It is not legal according
to this ABI for a compliant implementation to translate the program into
the following Assembly Sequences::

  thread_0:
    MOV W9,#1
    STR W9,[X2]
    DMB ISH
    STR W3,[X4]

  thread_1:
    MOV W9,#2
    SWP W9, WZR, [X2]
    DMB ISHLD
    LDR W3,[X4]

where ``thread_0:X2`` contains the address of ``x``, ``thread_0:X4`` contains
the address of ``y``, and ``thread_1:X2`` contains the address of ``y``,
``thread_1:X4`` contains the address of ``x``.

The ``exchange`` Atomic Operation is compiled to a ``SWP`` Assembly
Instruction, where its destination register is the zero register ``WZR``. The 
``acquire`` fence on ``thread_1`` is compiled to the ``DMB ISHLD`` Assembly 
Instruction.

Executing the compiled program on an Arm-based machine from a fixed initial
state (where ``x`` and ``y`` are ``0``) produces one of the following outcomes,
according to the AArch64 Memory Model contained in §B2 of the Arm Architecture
Reference Manual [ARMARM_]::

  { thread_1:r0=0; [y]=1; }
  { thread_1:r0=0; [y]=2; } <-- Forbidden by source model, a bug!
  { thread_1:r0=1; [y]=1; }
  { thread_1:r0=1; [y]=2; }

By comparing ``W3`` and the local variable ``r0`` of the original Concurrent
Program we see there is one additional outcome of executing the compiled
program that is not an outcome of executing the Concurrent Program. This is 
because the Arm Architecture Reference Manual [ARMARM_] states that 
*instructions where the destination register is WZR or XZR, are not regarded 
as doing a read for the purpose of a DMB LD barrier.*

In this case the compiler introduces another outcome of Execution. To fix this
issue, a compiler is not permitted to rewrite the destination register to be the
zero register::

  thread_0:
    MOV W9,#1
    STR W9,[X2]
    DMB ISH
    STR W3,[X4]

  thread_1:
    MOV W9,#2
    SWP W9, W10, [X2]
    DMB ISHLD
    LDR W3,[X4]

Executing the compiled program on an Arm-based machine from a fixed initial
state (where ``x`` and ``y`` are ``0``) produces one of the following outcomes,
according to the AArch64 Memory Model contained in §B2 of the Arm Architecture
Reference Manual [ARMARM_]::

  { thread_1:r0=0; [y]=1; }
  { thread_1:r0=1; [y]=1; }
  { thread_1:r0=1; [y]=2; }

As such the unexpected outcome has disappeared. There are multiple Mappings
that exhibit this behaviour. Assembly Sequences affected make use of ``SWP`` 
and ``LD<OP>`` Assembly instructions.

Documentation
~~~~~~~~~~~~~

The collective knowledge of atomics ABIs exists as numerous online discusions.
These discussions are neither authoritative nor persistent. Some discussions 
are now inaccessible and others are out of date. This is problematic given the
inherent complexity of relaxed memory concurrency, the difficulty of finding bugs,
and the possibility of user error. We believe an ABI is necessary to document
this corner of code generation.


The Mix Testing Process
-----------------------

ABI compatibility must be testable. Concurrency is not trivial, and the ABI
presents a simplification of part of the problem that is understandable by
engineers. We provide a simple technique for testing ABI compatibility.
These techniques reduce the difficulty of checking compatibility from a 
problem of understanding concurrent executions, to the familiar testing 
domain of comparing program outcomes of tests. This document does not 
preclude other means of testing compatibility.

We test for Compiler bugs. A Compiler Bug is defined as an outcome of a
compiled program execution (under the AArch64 Memory Model contained in
§B2 of the Arm Architecture Reference Manual [ARMARM_]) that is not 
an outcome of execution of the source Concurrent Program (under the 
ISO C memory model). Consider the hypothetical example where a source
Concurrent Program finishes execution in one of three possible outcomes
(a reference for this notation is found here [PAPER_])::

  { thread_0:r0=0, thread_1:r0=1 }
  { thread_0:r0=1, thread_1:r0=0 }
  { thread_0:r0=1, thread_1:r0=1 }

and one compiled program execution run has the following possible outcomes 
according to the AArch64 Memory Model contained in §B2 of the Arm 
Architecture Reference Manual [ARMARM_]::

  { thread_0:X3=0, thread_1:X3=0 } <--- Forbidden by source model, Compiler Bug!
  { thread_0:X3=0, thread_1:X3=1 }
  { thread_0:X3=1, thread_1:X3=0 }
  { thread_0:X3=1, thread_1:X3=1 }

By comparing ``X3`` and the local variable ``r0`` of the original Concurrent
Program in this example we see there is one additional outcome of executing the
compiled program that is not an outcome of executing the source program (under
the respective models). This suggests the Mappings under question are
incompatible, and a compiler that implements them exhibits a Compiler Bug. To
ensure compatibility we therefore test for the absence of such outcomes of the
compiled programs when mixing all combinations of the above Mappings. We define
the *Mix Testing* process as follows:

#. Take an arbitrary Concurrent Program. When executed on the C/C++ memory
   model, it will produce outcomes *S*.
#. Split out the individual Atomic Operations from the initial concurrent
   program into individual source files.
#. Compile each individual source file containing an Atomic Operation 
   using each Compiler Profile under test that generates Assembly Sequences
   under a given Mapping.
#. Combine the Assembly Sequences from above into *multiple* possible Compiled
   Programs.
#. Compute the outcomes of each compiled program under the AArch64 Memory Model
   contained in §B2 of the Arm Architecture Reference Manual [ARMARM_]. Get a
   *set* of compiled program outcomes *C*.
#. If any compiled program set of outcomes *c* in *C* exhibits a Compiler Bug
   (Check that *c* is a subset of *S*), the given Mappings are not
   interoperable. 


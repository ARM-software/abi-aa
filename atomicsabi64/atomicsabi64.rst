..
   Copyright (c) 2024, Arm Limited and its affiliates.  All rights reserved.
   CC-BY-SA-4.0 AND Apache-Patent-License
   See LICENSE file for details

.. |release| replace:: 2024Q1
.. |date-of-issue| replace:: 19\ :sup:`th` August 2024
.. |copyright-date| replace:: 2024
.. |footer| replace:: Copyright © |copyright-date|, Arm Limited and its
                      affiliates. All rights reserved.

.. _ARMARM: https://developer.arm.com/documentation/ddi0487/latest
.. _AAELF64: https://github.com/ARM-software/abi-aa/releases
.. _CPPABI64: https://github.com/ARM-software/abi-aa/releases
.. _CSTD: https://www.open-std.org/jtc1/sc22/wg14/www/docs/n1548.pdf
.. _PAPER: https://doi.org/10.1109/CGO57630.2024.10444836
.. _OOPSLA: https://2024.splashcon.org/track/splash-2024-oopsla#event-overview

*********************************************************************************************
C/C++ Atomics Application Binary Interface Standard for the Arm\ :sup:`®` 64-bit Architecture
*********************************************************************************************

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

This document describes the C/C++ Atomics Application Binary Interface for the
Arm 64-bit architecture. This document concerns the valid Mappings from C/C++
Atomic Operations to sequences of A64 instructions. For further information 
on the memory model, refer to §B2 of the Arm Architecture Reference Manual [ARMARM_]. 
This document only focusses on a subset of C11 atomic operations.

Keywords
--------

C++, C, Application Binary Interface, ABI, AArch64, C++ ABI,  generic C++ ABI,
Atomics, Concurrency

Latest release and defects report
---------------------------------

Please check `C/C++ Atomics Application Binary Interface Standard for the Arm 64-bit Architecture
<https://github.com/ARM-software/abi-aa>`_ for the latest
release of this document.

Please report defects in this specification to the `issue tracker page
on GitHub
<https://github.com/ARM-software/abi-aa/issues>`_.

.. raw:: pdf

   PageBreak

Acknowledgement
---------------

This ABI was written as part of Luke Geeson’s PhD on testing the
compilation of concurrent C/C++ with assistance from Wilco Dijkstra from Arm's
Compiler Teams.

It is an offshoot from a paper that will be presented at OOPSLA 2024 [OOPSLA_]:
*Mix Testing: Specifying and Testing ABI Compatibility Of C/C++ Atomics Implementations*
by Luke Geeson, James Brotherston, Wilco Dijkstra, Alastair Donaldson, Lee Smith,
Tyler Sorensen, and John Wickerson.



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

The following support level definitions are used by the Arm Atomics ABI
specifications:

**Release**
   Arm considers this specification to have enough implementations, which have
   received sufficient testing, to verify that it is correct. The details of
   these criteria are dependent on the scale and complexity of the change over
   previous versions: small, simple changes might only require one
   implementation, but more complex changes require multiple independent
   implementations, which have been rigorously tested for cross-compatibility.
   Arm anticipates that future changes to this specification will be limited to
   typographical corrections, clarifications and compatible extensions.

**Beta**
   Arm considers this specification to be complete, but existing
   implementations do not meet the requirements for confidence in its release
   quality. Arm may need to make incompatible changes if issues emerge from its
   implementation.

**Alpha**
   The content of this specification is a draft, and Arm considers the
   likelihood of future incompatible changes to be significant.

All content in this document is at the **Release** quality level.

Change History
--------------

If there is no entry in the change history table for a release, there are no
changes to the content of the document for that release.

.. class:: atomicsabi64-change-history

.. table::

  +---------+------------------------------+-------------------------------------------------------------------+
  | Issue   | Date                         | Change                                                            |
  +=========+==============================+===================================================================+
  | 00rel0  | 19\ :sup:`th` August 2024.   | Release.                                                          |
  +---------+------------------------------+-------------------------------------------------------------------+
  

References
----------

This document refers to, or is referred to by, the following documents.

.. table::

  +-------------+--------------------------------------------------------------+-----------------------------------------------------------------------------+
  | Ref         | External reference or URL                                    | Title                                                                       |
  +=============+==============================================================+=============================================================================+
  | ARMARM_     | DDI 0487                                                     | Arm Architecture Reference Manual Armv8 for Armv8-A architecture profile    |
  +-------------+--------------------------------------------------------------+-----------------------------------------------------------------------------+
  | CSTD_       | ISO/IEC 9899:2018                                            | International Standard ISO/IEC 9899:2018 – Programming languages C.         |
  +-------------+--------------------------------------------------------------+-----------------------------------------------------------------------------+
  | AAELF64_    | ELF for the Arm 64-bit Architecture (AArch64)                | ELF for the Arm 64-bit Architecture (AArch64)                               |
  +-------------+--------------------------------------------------------------+-----------------------------------------------------------------------------+
  | PAPER_      | CGO paper                                                    | Compiler Testing with Relaxed Memory Models                                 |
  +-------------+--------------------------------------------------------------+-----------------------------------------------------------------------------+



Note: At the time of writing, C23 is not released. Therefore, ISO C17 is considered 
the most recently published document.

.. raw:: pdf

   PageBreak

Terms and Abbreviations
-----------------------

The C/C++ Atomics ABI for the Arm 64-bit Architecture uses the following terms and
abbreviations.

A64
   The instruction set available when in AArch64 state.

AArch64
   The 64-bit general-purpose register width state of the Armv8 architecture.

ABI
   Application Binary Interface:

   1. The specifications to which an executable must conform in order to
      execute in a specific execution environment. For example, the
      :title-reference:`Linux ABI for the Arm Architecture`.

   2. A particular aspect of the specifications to which independently
      produced relocatable files must conform in order to be statically
      linkable and executable.  For example, the C++ ABI for the Arm 64-bit
      Architecture [CPPABI64_], or ELF for the Arm Architecture [AAELF64_].

Arm-based
   ... based on the Arm architecture ...

Thread of Execution
   A unit of computation that executes one or more Atomic Operations,
   Synchronization Operations or other C language statements. The Arm
   Architecture Reference Manual [ARMARM_] calls these *Observers*. Typically a
   thread is defined as a function (e.g. a POSIX thread) although we do not
   limit threads to this type of implementation.

Atomic Operation
   A C/C++ operation on a Shared-Memory Location. Typically either a load,
   store, exchange, compare, or arithmetic instruction (such as a fetch and add
   operation). Atomics are used to define higher level primitives including
   locks and concurrent queues. ISO C defines the range of supported atomic
   operations and the ``atomic`` type. Operations on atomic-qualified data are
   guaranteed not to be interrupted by another Thread of Execution.

Concurrent Program
   A C or C++ program that consists of one or more Threads of Execution. Each
   Thread of Execution must communicate with other threads in the Concurrent
   Program through Shared-Memory Locations, using both Atomic Operations and
   Non-Atomic Operations (Operations that lack the atomic qualifier) to be
   deemed *concurrent*. This document focuses on compiling such programs for
   Arm-based machines that run the A64 instruction set.

Synchronization Operation
   The order in which atomic operations are executed by each Thread of Execution
   may not be the same as the order they are written in the program.
   Synchronization Operations are statements that constrain the order of
   accesses made to Shared-Memory Locations by each thread. Synchronization
   Operations include Thread Fences.

Shared-Memory Location
   A memory location that can be accessed by any Thread of Execution in the
   program.

Memory Order Parameter
   Describes a constraint on an Atomic Operation or Synchronization Operation.
   Memory Order describes how memory accesses made by Atomic Operations may be
   ordered with respect to other Atomic Operations and Synchronization
   Operations. ISO C defines a ``memory_order`` enum type to capture the
   possible memory order parameters.

Thread Fence 
   A Thread Fence is a Synchronization Operation that constrains the order of
   Accesses made by Atomic Operations on a given Thread of Execution. Fences
   are equipped with a Memory Order Parameter that specifies which kinds of
   accesses may be reordered before or after the fence. ISO C defines the
   ``atomic_thread_fence`` to synchronize the order of accesses made by atomic
   operations on ``_Atomic`` qualified data.

Assembly Sequence
   A sequence of A64 instructions, optionally including Atomic Instructions.

Mapping
   A Mapping takes an Atomic Operation and Compiler Profile as input, 
   producing an Assembly Sequence as output.

Compiler Profile
   A Compiler implementation and command-line flags or attributes that use
   Mappings.

More specific terminology is defined when it is first used.

.. raw:: pdf

   PageBreak

Overview
========

The C/C++ Atomics ABI for the Arm 64-bit architecture (AABI64) comprises the
following sub-components:

* The `Mappings from Atomic Operations to Assembly Sequences`_ defines
  the Mappings from C/C++ atomic operations to the Assembly 
  Sequences that are interoperable with respect to each other.

* A `Declarative statement of Mappings compatibility`_, as far as
  non-exhaustive testing can validate, that the aforementioned Mappings can be
  used together. That is, there is no tested combination of Mappings that
  induces unexpected program behaviour when a compiled program that uses
  atomics is executed on a multi-core Arm-based machine.

Mappings from Atomic Operations to Assembly Sequences
=====================================================

We now describe the compatible Mappings for C/C++ Atomic Operations and
Assembly Sequences. Since there is a large number of ways these Mappings may be
combined, we break down the tables by the width of the access, and list
compatible Assembly Sequences for each Atomic Operation.

This is an open ABI, we encourage suggestions and improvements to this 
specification to be submitted to the `issue tracker page on
GitHub <https://github.com/ARM-software/abi-aa/issues>`_.

Notational Conventions
----------------------
To reduce repetition, we use the following notational conventions

.. table::

  +-----------------------------------------+--------------------------------------+
  | Memory Order Parameter                  | Notation                             | 
  +=========================================+======================================+
  | ``memory_order_relaxed``                | ``relaxed``                          |
  +-----------------------------------------+--------------------------------------+
  | ``memory_order_acquire``                | ``acquire``                          |
  +-----------------------------------------+--------------------------------------+
  | ``memory_order_release``                | ``release``                          |
  +-----------------------------------------+--------------------------------------+
  | ``memory_order_acq_rel``                | ``acq_rel``                          |
  +-----------------------------------------+--------------------------------------+
  | ``memory_order_seq_cst``                | ``seq_cst``                          |
  +-----------------------------------------+--------------------------------------+

Arbitrary registers may be used in the Assembly Sequences that may change in
compiler implementations. Cases where arbitrary registers may *not* be used are
covered in the Special Cases section.

Further, in what follows there may be multiple valid Mappings from Atomic
Operation to Assembly Sequence, as made available by a given architecture
extension. In this case we split the rows of the table to represent multiple
options.

.. table::

  +--------------------------------------------------------+--------------------------------------+
  | Atomic Operation                                       | Assembly Sequence                    | 
  +============================================+===========+======================================+
  | ``atomic_store_explicit(loc,val,relaxed)`` | ARCH1     | ``option A``                         |
  +                                            +-----------+--------------------------------------+
  |                                            | ARCH2     | ``option B``                         |
  +--------------------------------------------+-----------+--------------------------------------+

Where ARCH is either the base architecture (Armv8-A) or an extension like FEAT_LSE.

Lastly, all operations are in a shorthand form:

.. table::

  +----------------------------------------------------+--------------------------------------+
  | Atomic Operation                                   | ShortHand Atomic Operation           | 
  +====================================================+======================================+
  | ``atomic_store_explicit(...)``                     | ``store(...)``                       |
  +----------------------------------------------------+--------------------------------------+
  | ``atomic_load_explicit(...)``                      | ``load(...)``                        |
  +----------------------------------------------------+--------------------------------------+
  | ``atomic_thread_fence(...)``                       | ``fence(...)``                       |
  +----------------------------------------------------+--------------------------------------+
  | ``atomic_exchange_explicit(...)``                  | ``exchange(...)``                    |
  +----------------------------------------------------+--------------------------------------+
  | ``atomic_fetch_add_explicit(...)``                 | ``fetch_add(...)``                   | 
  +----------------------------------------------------+--------------------------------------+
  | ``atomic_fetch_sub_explicit(...)``                 | ``fetch_sub(...)``                   | 
  +----------------------------------------------------+--------------------------------------+
  | ``atomic_fetch_or_explicit(...)``                  | ``fetch_or(...)``                    | 
  +----------------------------------------------------+--------------------------------------+
  | ``atomic_fetch_xor_explicit(...)``                 | ``fetch_xor(...)``                   | 
  +----------------------------------------------------+--------------------------------------+
  | ``atomic_fetch_and_explicit(...)``                 | ``fetch_and(...)``                   | 
  +----------------------------------------------------+--------------------------------------+


Mappings for 32-bit types
-------------------------

In what follows, register ``X1`` contains the location ``loc`` and ``W2``
contains ``val``. ``W0`` contains input ``exp`` in compare-exchange.  The result is
returned in ``W0``.

.. table::

  +-----------------------------------------------------+--------------------------------------+
  | Atomic Operation                                    | Assembly Sequence                    |
  +=====================================================+======================================+
  | ``store(loc,val,relaxed)``                          | .. code-block:: none                 |
  |                                                     |                                      |
  |                                                     |    STR   W2, [X1]                    |
  +-----------------------------------------------------+--------------------------------------+
  | ``store(loc,val,release)``                          | .. code-block:: none                 |
  |                                                     |                                      |
  | ``store(loc,val,seq_cst)``                          |    STLR  W2, [X1]                    |
  +-----------------------------------------------------+--------------------------------------+
  | ``load(loc,relaxed)``                               | .. code-block:: none                 |
  |                                                     |                                      |
  |                                                     |    LDR    W2, [X1]                   |
  +-------------------------------------+---------------+--------------------------------------+
  | ``load(loc,acquire)``               | ``Armv8-A``   | .. code-block:: none                 |
  |                                     |               |                                      |
  |                                     |               |    LDAR  W2, [X1]                    |
  +                                     +---------------+--------------------------------------+
  |                                     | ``FEAT_RCPC`` | .. code-block:: none                 |
  |                                     |               |                                      |
  |                                     |               |    LDAPR  W2, [X1]                   |
  +-------------------------------------+---------------+--------------------------------------+
  | ``load(loc,seq_cst)``                               | .. code-block:: none                 |
  |                                                     |                                      |
  |                                                     |    LDAR   W2, [X1]                   |
  +-----------------------------------------------------+--------------------------------------+
  | ``fence(relaxed)``                                  | .. code-block:: none                 |
  |                                                     |                                      |
  |                                                     |    NOP                               |
  +-----------------------------------------------------+--------------------------------------+
  | ``fence(acquire)``                                  | .. code-block:: none                 |
  |                                                     |                                      |
  |                                                     |    DMB ISHLD                         |
  +-----------------------------------------------------+--------------------------------------+
  | ``fence(release)``                                  | .. code-block:: none                 |
  |                                                     |                                      |
  | ``fence(acq_rel)``                                  |    DMB ISH                           |
  |                                                     |                                      |
  | ``fence(seq_cst)``                                  |                                      |
  +-------------------------------------+---------------+--------------------------------------+
  | ``exchange(loc,val,relaxed)``       | ``Armv8-A``   | .. code-block:: none                 |
  |                                     |               |                                      |
  |                                     |               |    loop:                             |
  |                                     |               |      LDXR   W0, [X1]                 |
  |                                     |               |      STXR   W3, W2, [X1]             |
  |                                     |               |      CBNZ   W3, loop                 |
  |                                     +---------------+--------------------------------------+
  |                                     | ``FEAT_LSE``  | .. code-block:: none                 |
  |                                     |               |                                      |
  |                                     |               |    SWP    W2, W0, [X1] *             |
  +-------------------------------------+---------------+--------------------------------------+
  | ``exchange(loc,val,acquire)``       | ``Armv8-A``   | .. code-block:: none                 |
  |                                     |               |                                      |
  |                                     |               |    loop:                             |
  |                                     |               |      LDAXR  W0, [X1]                 |
  |                                     |               |      STXR   W3, W2, [X1]             |
  |                                     |               |      CBNZ   W3, loop                 |
  |                                     +---------------+--------------------------------------+
  |                                     | ``FEAT_LSE``  | .. code-block:: none                 |
  |                                     |               |                                      |
  |                                     |               |    SWPA   W2, W0, [X1] *             |
  +-------------------------------------+---------------+--------------------------------------+
  | ``exchange(loc,val,release)``       | ``Armv8-A``   | .. code-block:: none                 |
  |                                     |               |                                      |
  |                                     |               |    loop:                             |
  |                                     |               |      LDXR   W0, [X1]                 |
  |                                     |               |      STLXR  W3, W2, [X1]             |
  |                                     |               |      CBNZ   W3, loop                 |
  |                                     +---------------+--------------------------------------+
  |                                     | ``FEAT_LSE``  | .. code-block:: none                 |
  |                                     |               |                                      |
  |                                     |               |    SWPL   W2, W0, [X1] *             |
  +-------------------------------------+---------------+--------------------------------------+
  | ``exchange(loc,val,acq_rel)``       | ``Armv8-A``   | .. code-block:: none                 |
  | ``exchange(loc,val,seq_cst)``       |               |                                      |
  |                                     |               |    loop:                             |
  |                                     |               |      LDAXR  W0, [X1]                 |
  |                                     |               |      STLXR  W3, W2, [X1]             |
  |                                     |               |      CBNZ   W3, loop                 |
  |                                     +---------------+--------------------------------------+
  |                                     | ``FEAT_LSE``  | .. code-block:: none                 |
  |                                     |               |                                      |
  |                                     |               |    SWAL   W2, W0, [X1] *             |
  +-------------------------------------+---------------+--------------------------------------+
  | ``fetch_add(loc,val,relaxed)``      | ``Armv8-A``   | .. code-block:: none                 |
  |                                     |               |                                      |
  |                                     |               |    loop:                             |
  |                                     |               |      LDXR   W0, [X1]                 |
  |                                     |               |      ADD    W2, W2, W0               |
  |                                     |               |      STXR   W3, W2, [X1]             |
  |                                     |               |      CBNZ   W3, loop                 |
  |                                     +---------------+--------------------------------------+
  |                                     | ``FEAT_LSE``  | .. code-block:: none                 |
  |                                     |               |                                      |
  |                                     |               |    LDADD  W0, W2, [X1] *             |
  +-------------------------------------+---------------+--------------------------------------+
  | ``fetch_add(loc,val,acquire)``      | ``Armv8-A``   | .. code-block:: none                 |
  |                                     |               |                                      |
  |                                     |               |    loop:                             |
  |                                     |               |      LDAXR  W0, [X1]                 |
  |                                     |               |      ADD    W2, W2, W0               |
  |                                     |               |      STXR   W3, W2, [X1]             |
  |                                     |               |      CBNZ   W3, loop                 |
  |                                     +---------------+--------------------------------------+
  |                                     | ``FEAT_LSE``  | .. code-block:: none                 |
  |                                     |               |                                      |
  |                                     |               |    LDADDA W0, W2, [X1] *             |
  +-------------------------------------+---------------+--------------------------------------+
  | ``fetch_add(loc,val,release)``      | ``Armv8-A``   | .. code-block:: none                 |
  |                                     |               |                                      |
  |                                     |               |    loop:                             |
  |                                     |               |      LDXR   W0, [X1]                 |
  |                                     |               |      ADD    W2, W2, W0               |
  |                                     |               |      STLXR  W3, W2, [X1]             |
  |                                     |               |      CBNZ   W3, loop                 |
  |                                     +---------------+--------------------------------------+
  |                                     | ``FEAT_LSE``  | .. code-block:: none                 |
  |                                     |               |                                      |
  |                                     |               |    LDADDL W0, W2, [X1] *             |
  +-------------------------------------+---------------+--------------------------------------+
  | ``fetch_add(loc,val,acq_rel)``      | ``Armv8-A``   | .. code-block:: none                 |
  | ``fetch_add(loc,val,seq_cst)``      |               |                                      |
  |                                     |               |    loop:                             |
  |                                     |               |      LDAXR  W0, [X1]                 |
  |                                     |               |      ADD    W2, W2, W0               |
  |                                     |               |      STLXR  W3, W2, [X1]             |
  |                                     |               |      CBNZ   W3, loop                 |
  |                                     +---------------+--------------------------------------+
  |                                     | ``FEAT_LSE``  | .. code-block:: none                 |
  |                                     |               |                                      |
  |                                     |               |    LDADDAL W0, W2, [X1] *            |
  +-------------------------------------+---------------+--------------------------------------+
  | ``compare_exchange_strong(``        | ``Armv8-A``   | .. code-block:: none                 |
  |   ``loc,exp,val,relaxed,relaxed)``  |               |                                      |
  |                                     |               |      MOV    W4, W0                   |
  |                                     |               |    loop:                             |
  |                                     |               |      LDXR   W0, [X1]                 |
  |                                     |               |      CMP    W0, W4                   |
  |                                     |               |      B.NE   fail                     |
  |                                     |               |      STXR   W3, W2, [X1]             |
  |                                     |               |      CBNZ   W3, loop                 |
  |                                     |               |    fail:                             |
  |                                     +---------------+--------------------------------------+
  |                                     | ``FEAT_LSE``  | .. code-block:: none                 |
  |                                     |               |                                      |
  |                                     |               |    CAS    W0, W2, [X1] *             |
  +-------------------------------------+---------------+--------------------------------------+
  | ``compare_exchange_strong(``        | ``Armv8-A``   | .. code-block:: none                 |
  |   ``loc,exp,val,acquire,acquire)``  |               |                                      |
  |                                     |               |      MOV    W4, W0                   |
  |                                     |               |    loop:                             |
  |                                     |               |      LDAXR  W0, [X1]                 |
  |                                     |               |      CMP    W0, W4                   |
  |                                     |               |      B.NE   fail                     |
  |                                     |               |      STXR   W3, W2, [X1]             |
  |                                     |               |      CBNZ   W3, loop                 |
  |                                     |               |    fail:                             |
  |                                     +---------------+--------------------------------------+
  |                                     | ``FEAT_LSE``  | .. code-block:: none                 |
  |                                     |               |                                      |
  |                                     |               |    CASA   W0, W2, [X1] *             |
  +-------------------------------------+---------------+--------------------------------------+
  | ``compare_exchange_strong(``        | ``Armv8-A``   | .. code-block:: none                 |
  |   ``loc,exp,val,release,release)``  |               |                                      |
  |                                     |               |      MOV    W4, W0                   |
  |                                     |               |    loop:                             |
  |                                     |               |      LDXR   W0, [X1]                 |
  |                                     |               |      CMP    W0, W4                   |
  |                                     |               |      B.NE   fail                     |
  |                                     |               |      STLXR  W3, W2, [X1]             |
  |                                     |               |      CBNZ   W3, loop                 |
  |                                     |               |    fail:                             |
  |                                     +---------------+--------------------------------------+
  |                                     | ``FEAT_LSE``  | .. code-block:: none                 |
  |                                     |               |                                      |
  |                                     |               |    CASL   W0, W2, [X1] *             |
  +-------------------------------------+---------------+--------------------------------------+
  | ``compare_exchange_strong(``        | ``Armv8-A``   | .. code-block:: none                 |
  |   ``loc,exp,val,acq_rel,acquire)``  |               |                                      |
  |                                     |               |      MOV    W4, W0                   |
  | ``compare_exchange_strong(``        |               |    loop:                             |
  |   ``loc,exp,val,seq_cst,seq_cst)``  |               |      LDAXR  W0, [X1]                 |
  |                                     |               |      CMP    W0, W4                   |
  |                                     |               |      B.NE   fail                     |
  |                                     |               |      STLXR  W3, W2, [X1]             |
  |                                     |               |      CBNZ   W3, loop                 |
  |                                     |               |    fail:                             |
  |                                     +---------------+--------------------------------------+
  |                                     | ``FEAT_LSE``  | .. code-block:: none                 |
  |                                     |               |                                      |
  |                                     |               |    CASAL  W0, W2, [X1] *             |
  +-------------------------------------+---------------+--------------------------------------+
  | Note                                                                                       |
  +--------------------------------------------------------------------------------------------+
  | ``*`` Using ``WZR`` or ``XZR`` for the destination register is invalid (Section 4.7).      |
  +--------------------------------------------------------------------------------------------+


Mappings for 8-bit types
------------------------

The Mappings for 8-bit types are the same as 32-bit types except they use the
``B`` variants of instructions. 


Mappings for 16-bit types
-------------------------

The Mappings for 16-bit types are the same as 32-bit types except they use the
``H`` variants of instructions.

Mappings for 64-bit types
-------------------------

The Mappings for 64-bit types are the same as 32-bit types except the registers
used are X-registers.

Mappings for 128-bit types
--------------------------

Since the access width of 128-bit types is double that of the 64-bit register
width, the following Mappings use *pair* instructions, which require their own
table.

In what follows, register ``X4`` contains the location ``loc``, ``X2`` and 
``X3`` contain the input value ``val``. ``X0`` and ``X1`` contain input ``exp`` in
compare-exchange. The result is returned in ``X0`` and ``X1``.

.. table::

  +-----------------------------------------------------+--------------------------------------+
  | Atomic Operation                                    | Assembly Sequence                    |
  +=====================================+===============+======================================+
  | ``store(loc,val,relaxed)``          | ``Armv8-A``   | .. code-block:: none                 |
  |                                     |               |                                      |
  |                                     |               |    loop:                             |
  |                                     |               |      LDXP   XZR, X1, [X4]            |
  |                                     |               |      STXP   W5, X2, X3, [X4]         |
  |                                     |               |      CBNZ   W5, loop                 |
  |                                     +---------------+--------------------------------------+
  |                                     | ``FEAT_LSE``  | .. code-block:: none                 |
  |                                     |               |                                      |
  |                                     |               |      LDP   X0, X1, [X4]              |
  |                                     |               |    loop:                             |
  |                                     |               |      MOV    X6, X0                   |
  |                                     |               |      MOV    X7, X1                   |
  |                                     |               |      CASP   X0, X1, X2, X3, [X4]     |
  |                                     |               |      CMP    X0, X6                   |
  |                                     |               |      CCMP   X1, X7, 0, EQ            |
  |                                     |               |      B.NE   loop                     |
  |                                     +---------------+--------------------------------------+
  |                                     | ``FEAT_LSE2`` | .. code-block:: none                 |
  |                                     |               |                                      |
  |                                     |               |    STP   X2, X3, [X4]                |
  +-------------------------------------+---------------+--------------------------------------+
  | ``store(loc,val,release)``          | ``Armv8-A``   | .. code-block:: none                 |
  |                                     |               |                                      |
  |                                     |               |    loop:                             |
  |                                     |               |      LDXP   XZR, X1, [X4]            |
  |                                     |               |      STLXP  W5, X2, X3, [X4]         |
  |                                     |               |      CBNZ   W5, loop                 |
  |                                     +---------------+--------------------------------------+
  |                                     | ``FEAT_LSE``  | .. code-block:: none                 |
  |                                     |               |                                      |
  |                                     |               |      LDP   X0, X1, [X4]              |
  |                                     |               |    loop:                             |
  |                                     |               |      MOV    X6, X0                   |
  |                                     |               |      MOV    X7, X1                   |
  |                                     |               |      CASPL  X0, X1, X2, X3, [X4]     |
  |                                     |               |      CMP    X0, X6                   |
  |                                     |               |      CCMP   X1, X7, 0, EQ            |
  |                                     |               |      B.NE   loop                     |
  +                                     +---------------+--------------------------------------+
  |                                     | ``FEAT_LSE2`` | .. code-block:: none                 |
  |                                     |               |                                      |
  |                                     |               |    DMB   ISH                         |
  |                                     |               |    STP   X2, X3, [X4]                |
  |                                     +---------------+--------------------------------------+
  |                                     |``FEAT_LRCPC3``| .. code-block:: none                 |
  |                                     |               |                                      |
  |                                     |               |    STILP   X2, X3, [X4]              |
  +-------------------------------------+---------------+--------------------------------------+
  | ``store(loc,val,seq_cst)``          | ``Armv8-A``   | .. code-block:: none                 |
  |                                     |               |                                      |
  |                                     |               |    loop:                             |
  |                                     |               |      LDAXP   XZR, X1, [X4]           |
  |                                     |               |      STLXP   W5, X2, X3, [X4]        |
  |                                     |               |      CBNZ    W5, loop                |
  |                                     +---------------+--------------------------------------+
  |                                     | ``FEAT_LSE``  | .. code-block:: none                 |
  |                                     |               |                                      |
  |                                     |               |      LDP   X0, X1, [X4]              |
  |                                     |               |    loop:                             |
  |                                     |               |      MOV    X6, X0                   |
  |                                     |               |      MOV    X7, X1                   |
  |                                     |               |      CASPAL X0, X1, X2, X3, [X4]     |
  |                                     |               |      CMP    X0, X6                   |
  |                                     |               |      CCMP   X1, X7, 0, EQ            |
  |                                     |               |      B.NE   loop                     |
  +                                     +---------------+--------------------------------------+
  |                                     | ``FEAT_LSE2`` | .. code-block:: none                 |
  |                                     |               |                                      |
  |                                     |               |    DMB   ISH                         |
  |                                     |               |    STP   X2, X3, [X4]                |
  |                                     |               |    DMB   ISH                         |
  |                                     +---------------+--------------------------------------+
  |                                     |``FEAT_LRCPC3``| .. code-block:: none                 |
  |                                     |               |                                      |
  |                                     |               |    STILP   x2, X3, [X4]              |
  +-------------------------------------+---------------+--------------------------------------+
  | ``load(loc,relaxed)``               | ``Armv8-A``   | .. code-block:: none                 |
  |                                     |               |                                      |
  |                                     |               |    loop:                             |
  |                                     |               |      LDXP   X0, X1, [X4]             |
  |                                     |               |      STXP   W5, X0, X1, [X4]         |
  |                                     |               |      CBNZ   W5, loop                 |
  |                                     +---------------+--------------------------------------+
  |                                     | ``FEAT_LSE``  | .. code-block:: none                 |
  |                                     |               |                                      |
  |                                     |               |    CASP   X0, X1, X0, X1, [X4]       |
  |                                     +---------------+--------------------------------------+
  |                                     | ``FEAT_LSE2`` | .. code-block:: none                 |
  |                                     |               |                                      |
  |                                     |               |    LDP   X0, X1, [X4]                |
  +-------------------------------------+---------------+--------------------------------------+
  | ``load(loc,acquire)``               | ``Armv8-A``   | .. code-block:: none                 |
  |                                     |               |                                      |
  |                                     |               |    loop:                             |
  |                                     |               |      LDAXP  X0, X1, [X4]             |
  |                                     |               |      STXP   W5, X0, X1, [X4]         |
  |                                     |               |      CBNZ   W5, loop                 |
  |                                     +---------------+--------------------------------------+
  |                                     | ``FEAT_LSE``  | .. code-block:: none                 |
  |                                     |               |                                      |
  |                                     |               |    CASPA  X0, X1, X0, X1, [X4]       |
  |                                     +---------------+--------------------------------------+
  |                                     | ``FEAT_LSE2`` | .. code-block:: none                 |
  |                                     |               |                                      |
  |                                     |               |    LDP   X0, X1, [X4]                |
  |                                     |               |    DMB   ISHLD                       |
  |                                     +---------------+--------------------------------------+
  |                                     |``FEAT_LRCPC3``| .. code-block:: none                 |
  |                                     |               |                                      |
  |                                     |               |    LDIAPP X0, X1, [X4]               |
  +-------------------------------------+---------------+--------------------------------------+
  | ``load(loc,seq_cst)``               | ``Armv8-A``   | .. code-block:: none                 |
  |                                     |               |                                      |
  |                                     |               |    loop:                             |
  |                                     |               |      LDAXP  X0, X1, [X4]             |
  |                                     |               |      STXP   W5, X0, X1, [X4]         |
  |                                     |               |      CBNZ   W5, loop                 |
  |                                     +---------------+--------------------------------------+
  |                                     | ``FEAT_LSE``  | .. code-block:: none                 |
  |                                     |               |                                      |
  |                                     |               |    CASPA  X0, X1, X0, X1, [X4]       |
  |                                     +---------------+--------------------------------------+
  |                                     | ``FEAT_LSE2`` | .. code-block:: none                 |
  |                                     |               |                                      |
  |                                     |               |    LDAR  X5, [X4]                    |
  |                                     |               |    LDP   X0, X1, [X4]                |
  |                                     |               |    DMB   ISHLD                       |
  |                                     +---------------+--------------------------------------+
  |                                     |``FEAT_LRCPC3``| .. code-block:: none                 |
  |                                     |               |                                      |
  |                                     |               |    LDAR   X5, [X4]                   |
  |                                     |               |    LDIAPP X0, X1, [X4]               |
  +-------------------------------------+---------------+--------------------------------------+
  | ``exchange(loc,val,relaxed)``       | ``Armv8-A``   | .. code-block:: none                 |
  |                                     |               |                                      |
  |                                     |               |    loop:                             |
  |                                     |               |      LDXP   X0, X1, [X4]             |
  |                                     |               |      STXP   W5, X2, X3, [X4]         |
  |                                     |               |      CBNZ   W5, loop                 |
  |                                     +---------------+--------------------------------------+
  |                                     | ``FEAT_LSE``  | .. code-block:: none                 |
  |                                     |               |                                      |
  |                                     |               |      LDP   X0, X1, [X4]              |
  |                                     |               |    loop:                             |
  |                                     |               |      MOV    X6, X0                   |
  |                                     |               |      MOV    X7, X1                   |
  |                                     |               |      CASP   X0, X1, X2, X3, [X4]     |
  |                                     |               |      CMP    X0, X6                   |
  |                                     |               |      CCMP   X1, X7, 0, EQ            |
  |                                     |               |      B.NE   loop                     |
  |                                     +---------------+--------------------------------------+
  |                                     |``FEAT_LSE128``| .. code-block:: none                 |
  |                                     |               |                                      |
  |                                     |               |    MOV    X0, X2                     |
  |                                     |               |    MOV    X1, X3                     |
  |                                     |               |    SWPP   X0, X1, [X4]               |
  +-------------------------------------+---------------+--------------------------------------+
  | ``exchange(loc,val,acquire)``       | ``Armv8-A``   | .. code-block:: none                 |
  |                                     |               |                                      |
  |                                     |               |    loop:                             |
  |                                     |               |      LDAXP  X0, X1, [X4]             |
  |                                     |               |      STXP   W5, X2, X3, [X4]         |
  |                                     |               |      CBNZ   W5, loop                 |
  |                                     +---------------+--------------------------------------+
  |                                     | ``FEAT_LSE``  | .. code-block:: none                 |
  |                                     |               |                                      |
  |                                     |               |      LDP   X0, X1, [X4]              |
  |                                     |               |    loop:                             |
  |                                     |               |      MOV    X6, X0                   |
  |                                     |               |      MOV    X7, X1                   |
  |                                     |               |      CASPA  X0, X1, X2, X3, [X4]     |
  |                                     |               |      CMP    X0, X6                   |
  |                                     |               |      CCMP   X1, X7, 0, EQ            |
  |                                     |               |      B.NE   loop                     |
  |                                     +---------------+--------------------------------------+
  |                                     |``FEAT_LSE128``| .. code-block:: none                 |
  |                                     |               |                                      |
  |                                     |               |    MOV    X0, X2                     |
  |                                     |               |    MOV    X1, X3                     |
  |                                     |               |    SWPPA  X0, X1, [X4]               |
  +-------------------------------------+---------------+--------------------------------------+
  | ``exchange(loc,val,release)``       | ``Armv8-A``   | .. code-block:: none                 |
  |                                     |               |                                      |
  |                                     |               |    loop:                             |
  |                                     |               |      LDXP   X0, X1, [X4]             |
  |                                     |               |      STLXP  W5, X2, X3, [X4]         |
  |                                     |               |      CBNZ   W5, loop                 |
  |                                     +---------------+--------------------------------------+
  |                                     | ``FEAT_LSE``  | .. code-block:: none                 |
  |                                     |               |                                      |
  |                                     |               |      LDP   X0, X1, [X4]              |
  |                                     |               |    loop:                             |
  |                                     |               |      MOV    X6, X0                   |
  |                                     |               |      MOV    X7, X1                   |
  |                                     |               |      CASPL  X0, X1, X2, X3, [X4]     |
  |                                     |               |      CMP    X0, X6                   |
  |                                     |               |      CCMP   X1, X7, 0, EQ            |
  |                                     |               |      B.NE   loop                     |
  |                                     +---------------+--------------------------------------+
  |                                     |``FEAT_LSE128``| .. code-block:: none                 |
  |                                     |               |                                      |
  |                                     |               |    MOV    X0, X2                     |
  |                                     |               |    MOV    X1, X3                     |
  |                                     |               |    SWPPL  X0, X1, [X4]               |
  +-------------------------------------+---------------+--------------------------------------+
  | ``exchange(loc,val,acq_rel)``       | ``Armv8-A``   | .. code-block:: none                 |
  |                                     |               |                                      |
  | ``exchange(loc,val,seq_cst)``       |               |    loop:                             |
  |                                     |               |      LDAXP  X0, X1, [X4]             |
  |                                     |               |      STLXP  W5, X2, X3, [X4]         |
  |                                     |               |      CBNZ   W5, loop                 |
  |                                     +---------------+--------------------------------------+
  |                                     | ``FEAT_LSE``  | .. code-block:: none                 |
  |                                     |               |                                      |
  |                                     |               |      LDP   X0, X1, [X4]              |
  |                                     |               |    loop:                             |
  |                                     |               |      MOV    X6, X0                   |
  |                                     |               |      MOV    X7, X1                   |
  |                                     |               |      CASPAL X0, X1, X2, X3, [X4]     |
  |                                     |               |      CMP    X0, X6                   |
  |                                     |               |      CCMP   X1, X7, 0, EQ            |
  |                                     |               |      B.NE   loop                     |
  |                                     +---------------+--------------------------------------+
  |                                     |``FEAT_LSE128``| .. code-block:: none                 |
  |                                     |               |                                      |
  |                                     |               |    MOV    X0, X2                     |
  |                                     |               |    MOV    X1, X3                     |
  |                                     |               |    SWPPAL X0, X1, [X4]               |
  +-------------------------------------+---------------+--------------------------------------+
  | ``fetch_add(loc,val,relaxed)``      | ``Armv8-A``   | .. code-block:: none                 |
  |                                     |               |                                      |
  |                                     |               |    loop:                             |
  |                                     |               |      LDXP   X0, X1, [X4]             |
  |                                     |               |      ADDS   X0, X0, X2               |
  |                                     |               |      ADC    X1, X1, X3               |
  |                                     |               |      STXP   W5, X0, X1, [X4]         |
  |                                     |               |      CBNZ   W5, loop                 |
  |                                     +---------------+--------------------------------------+
  |                                     | ``FEAT_LSE``  | .. code-block:: none                 |
  |                                     |               |                                      |
  |                                     |               |      LDP   X0, X1, [X4]              |
  |                                     |               |    loop:                             |
  |                                     |               |      MOV    X6, X0                   |
  |                                     |               |      MOV    X7, X1                   |
  |                                     |               |      ADDS   X8, X0, X2               |
  |                                     |               |      ADC    X9, X1, X3               |
  |                                     |               |      CASP   X0, X1, X8, X9, [X4]     |
  |                                     |               |      CMP    X0, X6                   |
  |                                     |               |      CCMP   X1, X7, 0, EQ            |
  |                                     |               |      B.NE   loop                     |
  +-------------------------------------+---------------+--------------------------------------+
  | ``fetch_add(loc,val,acquire)``      | ``Armv8-A``   | .. code-block:: none                 |
  |                                     |               |                                      |
  |                                     |               |    loop:                             |
  |                                     |               |      LDAXP  X0, X1, [X4]             |
  |                                     |               |      ADDS   X0, X0, X2               |
  |                                     |               |      ADC    X1, X1, X3               |
  |                                     |               |      STXP   W5, X0, X1, [X4]         |
  |                                     |               |      CBNZ   W5, loop                 |
  |                                     +---------------+--------------------------------------+
  |                                     | ``FEAT_LSE``  | .. code-block:: none                 |
  |                                     |               |                                      |
  |                                     |               |      LDP   X0, X1, [X4]              |
  |                                     |               |    loop:                             |
  |                                     |               |      MOV    X6, X0                   |
  |                                     |               |      MOV    X7, X1                   |
  |                                     |               |      ADDS   X8, X0, X2               |
  |                                     |               |      ADC    X9, X1, X3               |
  |                                     |               |      CASPA  X0, X1, X8, X9, [X4]     |
  |                                     |               |      CMP    X0, X6                   |
  |                                     |               |      CCMP   X1, X7, 0, EQ            |
  |                                     |               |      B.NE   loop                     |
  +-------------------------------------+---------------+--------------------------------------+
  | ``fetch_add(loc,val,release)``      | ``Armv8-A``   | .. code-block:: none                 |
  |                                     |               |                                      |
  |                                     |               |    loop:                             |
  |                                     |               |      LDXP   X0, X1, [X4]             |
  |                                     |               |      ADDS   X0, X0, X2               |
  |                                     |               |      ADC    X1, X1, X3               |
  |                                     |               |      STLXP  W5, X0, X1, [X4]         |
  |                                     |               |      CBNZ   W5, loop                 |
  |                                     +---------------+--------------------------------------+
  |                                     | ``FEAT_LSE``  | .. code-block:: none                 |
  |                                     |               |                                      |
  |                                     |               |      LDP   X0, X1, [X4]              |
  |                                     |               |    loop:                             |
  |                                     |               |      MOV    X6, X0                   |
  |                                     |               |      MOV    X7, X1                   |
  |                                     |               |      ADDS   X8, X0, X2               |
  |                                     |               |      ADC    X9, X1, X3               |
  |                                     |               |      CASPL  X0, X1, X8, X9, [X4]     |
  |                                     |               |      CMP    X0, X6                   |
  |                                     |               |      CCMP   X1, X7, 0, EQ            |
  |                                     |               |      B.NE   loop                     |
  +-------------------------------------+---------------+--------------------------------------+
  | ``fetch_add(loc,val,acq_rel)``      | ``Armv8-A``   | .. code-block:: none                 |
  |                                     |               |                                      |
  | ``fetch_add(loc,val,seq_cst)``      |               |    loop:                             |
  |                                     |               |      LDAXP  X0, X1, [X4]             |
  |                                     |               |      ADDS   X0, X0, X2               |
  |                                     |               |      ADC    X1, X1, X3               |
  |                                     |               |      STLXP  W5, X0, X1, [X4]         |
  |                                     |               |      CBNZ   W5, loop                 |
  |                                     +---------------+--------------------------------------+
  |                                     | ``FEAT_LSE``  | .. code-block:: none                 |
  |                                     |               |                                      |
  |                                     |               |      LDP   X0, X1, [X4]              |
  |                                     |               |    loop:                             |
  |                                     |               |      MOV    X6, X0                   |
  |                                     |               |      MOV    X7, X1                   |
  |                                     |               |      ADDS   X8, X0, X2               |
  |                                     |               |      ADC    X9, X1, X3               |
  |                                     |               |      CASPAL X0, X1, X8, X9, [X4]     |
  |                                     |               |      CMP    X0, X6                   |
  |                                     |               |      CCMP   X1, X7, 0, EQ            |
  |                                     |               |      B.NE   loop                     |
  +-------------------------------------+---------------+--------------------------------------+
  | ``fetch_or(loc,val,relaxed)``       |``FEAT_LSE128``| .. code-block:: none                 |
  |                                     |               |                                      |
  |                                     |               |    MOV    X0, X2                     |
  |                                     |               |    MOV    X1, X3                     |
  |                                     |               |    LDSETP X0, X1, [X4]               |
  +-------------------------------------+---------------+--------------------------------------+
  | ``fetch_or(loc,val,acquire)``       |``FEAT_LSE128``| .. code-block:: none                 |
  |                                     |               |                                      |
  |                                     |               |    MOV     X0, X2                    |
  |                                     |               |    MOV     X1, X3                    |
  |                                     |               |    LDSETPA X0, X1, [X4]              |
  +-------------------------------------+---------------+--------------------------------------+
  | ``fetch_or(loc,val,release)``       |``FEAT_LSE128``| .. code-block:: none                 |
  |                                     |               |                                      |
  |                                     |               |    MOV     X0, X2                    |
  |                                     |               |    MOV     X1, X3                    |
  |                                     |               |    LDSETPL X0, X1, [X4]              |
  +-------------------------------------+---------------+--------------------------------------+
  | ``fetch_or(loc,val,acq_rel)``       |``FEAT_LSE128``| .. code-block:: none                 |
  |                                     |               |                                      |
  | ``fetch_or(loc,val,seq_cst)``       |               |    MOV      X0, X2                   |
  |                                     |               |    MOV      X1, X3                   |
  |                                     |               |    LDSETPAL X0, X1, [X4]             |
  +-------------------------------------+---------------+--------------------------------------+
  | ``fetch_and(loc,val,relaxed)``      |``FEAT_LSE128``| .. code-block:: none                 |
  |                                     |               |                                      |
  |                                     |               |    MVN    X0, X2                     |
  |                                     |               |    MVN    X1, X3                     |
  |                                     |               |    LDCLRP X0, X1, [X4]               |
  +-------------------------------------+---------------+--------------------------------------+
  | ``fetch_and(loc,val,acquire)``      |``FEAT_LSE128``| .. code-block:: none                 |
  |                                     |               |                                      |
  |                                     |               |    MVN     X0, X2                    |
  |                                     |               |    MNV     X1, X3                    |
  |                                     |               |    LDCLRPA X0, X1, [X4]              |
  +-------------------------------------+---------------+--------------------------------------+
  | ``fetch_and(loc,val,release)``      |``FEAT_LSE128``| .. code-block:: none                 |
  |                                     |               |                                      |
  |                                     |               |    MVN     X0, X2                    |
  |                                     |               |    MVN     X1, X3                    |
  |                                     |               |    LDCLRPL X0, X1, [X4]              |
  +-------------------------------------+---------------+--------------------------------------+
  | ``fetch_and(loc,val,acq_rel)``      |``FEAT_LSE128``| .. code-block:: none                 |
  |                                     |               |                                      |
  | ``fetch_and(loc,val,seq_cst)``      |               |    MVN      X0, X2                   |
  |                                     |               |    MVN      X1, X3                   |
  |                                     |               |    LDCLRPAL X0, X1, [X4]             |
  +-------------------------------------+---------------+--------------------------------------+
  | ``compare_exchange_strong(``        | ``Armv8-A``   | .. code-block:: none                 |
  |   ``loc,exp,val,relaxed,relaxed)``  |               |                                      |
  |                                     |               |    loop:                             |
  |                                     |               |      LDXP   X6, X7, [X4]             |
  |                                     |               |      CMP    X6, X0                   |
  |                                     |               |      CCMP   X7, X1, 0, EQ            |
  |                                     |               |      CSEL   X8, X2, X6, EQ           |
  |                                     |               |      CSEL   X9, X3, X7, EQ           |
  |                                     |               |      STXP   W5, X8, X9, [X4]         |
  |                                     |               |      CBNZ   W5, loop                 |
  |                                     |               |      MOV    X0, X6                   |
  |                                     |               |      MOV    X1, X7                   |
  |                                     +---------------+--------------------------------------+
  |                                     | ``FEAT_LSE``  | .. code-block:: none                 |
  |                                     |               |                                      |
  |                                     |               |    CASP    X0, X1, X2, X3, [X4]      |
  +-------------------------------------+---------------+--------------------------------------+
  | ``compare_exchange_strong(``        | ``Armv8-A``   | .. code-block:: none                 |
  |   ``loc,exp,val,acquire,acquire)``  |               |                                      |
  |                                     |               |    loop:                             |
  | ``compare_exchange_strong(``        |               |      LDAXP  X6, X7, [X4]             |
  |   ``loc,exp,val,acquire,relaxed)``  |               |      CMP    X6, X0                   |
  |                                     |               |      CCMP   X7, X1, 0, EQ            |
  |                                     |               |      CSEL   X8, X2, X6, EQ           |
  |                                     |               |      CSEL   X9, X3, X7, EQ           |
  |                                     |               |      STXP   W5, X8, X9, [X4]         |
  |                                     |               |      CBNZ   W5, loop                 |
  |                                     |               |      MOV    X0, X6                   |
  |                                     |               |      MOV    X1, X7                   |
  |                                     +---------------+--------------------------------------+
  |                                     | ``FEAT_LSE``  | .. code-block:: none                 |
  |                                     |               |                                      |
  |                                     |               |    CASPA   X0, X1, X2, X3, [X4]      |
  +-------------------------------------+---------------+--------------------------------------+
  | ``compare_exchange_strong(``        | ``Armv8-A``   | .. code-block:: none                 |
  |   ``loc,exp,val,release,relaxed)``  |               |                                      |
  |                                     |               |    loop:                             |
  |                                     |               |      LDXP   X6, X7, [X4]             |
  |                                     |               |      CMP    X6, X0                   |
  |                                     |               |      CCMP   X7, X1, 0, EQ            |
  |                                     |               |      CSEL   X8, X2, X6, EQ           |
  |                                     |               |      CSEL   X9, X3, X7, EQ           |
  |                                     |               |      STLXP  W5, X8, X9, [X4]         |
  |                                     |               |      CBNZ   W5, loop                 |
  |                                     |               |      MOV    X0, X6                   |
  |                                     |               |      MOV    X1, X7                   |
  |                                     +---------------+--------------------------------------+
  |                                     | ``FEAT_LSE``  | .. code-block:: none                 |
  |                                     |               |                                      |
  |                                     |               |    CASPL   X0, X1, X2, X3, [X4]      |
  +-------------------------------------+---------------+--------------------------------------+
  | ``compare_exchange_strong(``        | ``Armv8-A``   | .. code-block:: none                 |
  |   ``loc,exp,val,acq_rel,acquire)``  |               |                                      |
  |                                     |               |    loop:                             |
  | ``compare_exchange_strong(``        |               |      LDAXP  X6, X7, [X4]             |
  |   ``loc,exp,val,seq_cst,acquire)``  |               |      CMP    X6, X0                   |
  |                                     |               |      CCMP   X7, X1, 0, EQ            |
  |                                     |               |      CSEL   X8, X2, X6, EQ           |
  |                                     |               |      CSEL   X9, X3, X7, EQ           |
  |                                     |               |      STLXP  W5, X8, X9, [X4]         |
  |                                     |               |      CBNZ   W5, loop                 |
  |                                     |               |      MOV    X0, X6                   |
  |                                     |               |      MOV    X1, X7                   |
  |                                     +---------------+--------------------------------------+
  |                                     | ``FEAT_LSE``  | .. code-block:: none                 |
  |                                     |               |                                      |
  |                                     |               |    CASPAL  X0, X1, X2, X3, [X4]      |
  +-------------------------------------+---------------+--------------------------------------+





We do not list other variants of ``fetch_<op>`` since their Mappings should be
the same (modulo implementations of <op> that are not in scope for this
document). Precisely, implementations that use loops should use the instructions
that load or store from memory with the relevant memory order, and the
appropriate <op> Assembly Sequence inside the loop. Exceptions, where Assembly 
Sequences exist, are stated. For instance ``fetch_or`` can be implemented using
``LDSETP`` when the LSE128 extension is enabled.

Special Cases
-------------

Read-Modify-Write atomics must not use the zero register
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``CAS``, ``SWP`` and ``LD<OP>`` instructions must not use the zero register if
the result is not used since it allows reordering of the read past a
``DMB ISHLD`` barrier. Affected instructions are marked with ``*`` in section 4.2.

Const-Qualified 128-bit Atomic Loads Should Be Marked Mutable
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Const-qualified data containing 128-bit atomic types should not be placed
in read-only memory (such as the ``.rodata`` section).

Before LSE2, the only way to implement a single-copy 128-bit atomic load
is by using a Read-Modify-Write sequence. The write is not visible to
software if the memory is writeable. Compilers and runtimes should prefer the
LSE2/LRCPC3 sequence when available.


Declarative statement of Mappings compatibility
===============================================

To ensure that the above Mappings are ABI-compatible we test the compilation of
Concurrent Programs, where each Atomic Operation is compiled to one of the
aforementioned Mappings. We test if there is a compiled program that exhibits
an outcome of execution according to the AArch64 Memory Model contained in §B2
of the Arm Architecture Reference Manual [ARMARM_] that is not an outcome of
execution of the source program under the ISO C model. In this section we
define the process by which we test compatibility. 

Definition of ABI-Compatibility for Atomic Operations
-----------------------------------------------------

*A compiler that implement these Mappings and special cases is ABI-Compatible with
respect to other compilers that implement the Mappings and special cases.*

We impose some constraints on this definition:

* This is not a correctness guarantee, but rather a statement backed up by
  bounded testing. C/C++ Atomics ABI-compatibility is thus tested for the Mappings
  above by generating C/C++ Concurrent Programs that permute combinations of
  Atomic Operations on each Thread of Execution. We bound our test size between
  2 and 5 Threads of Execution, where each Thread has at least 1 Atomic
  Operation or Synchronization Operation and at most 5 Atomic Operations or
  Synchronization Operations. We do not make any statement about the
  ABI-Compatibility of Concurrent Programs outside these bounds.
* We test Concurrent Programs with a fixed initial state, loop unroll factor
  (equal to 1 loop unroll), and function calls or recursion. 
* The above Mappings are not exhaustive. We recommend that Arm's partners
  submit requests for other Mappings to the ABI team using the `issue tracker page on GitHub <https://github.com/ARM-software/abi-aa/issues>`_.
* This document makes no statement about the ABI-Compatibility of optimised
  Concurrent Programs, nor does it make a statement concerning the performance of
  compiled programs under the above Mappings when executed on a given Arm-based
  machine.
* This document makes no statement about the ABI-Compatibility of compilers
  that implement Mappings other than what is stated in this document.

Appendix: Mix Testing
=====================

The status of this appendix is informative.





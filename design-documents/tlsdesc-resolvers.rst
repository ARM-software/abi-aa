..
   Copyright (c) 2023-2025, Arm Limited and its affiliates.  All rights reserved.
   CC-BY-SA-4.0 AND Apache-Patent-License
   See LICENSE file for details

.. _SYSVABI64: https://github.com/ARM-software/abi-aa/tree/main/sysvabi64/sysvabi64.rst
.. _TLSDESC: http://www.fsfla.org/~lxoliva/writeups/TLS/RFC-TLSDESC-ARM.txt

Thread Local Storage TLSDESC resolver functions
***********************************************

Preamble
========

Background
----------

The ``R_AARCH64_TLSDESC`` dynamic relocation is platform specific. The
dynamic loader is expected to choose an appropriate resolver function
for the context. This document provides some example resolver
functions.

These examples are for illustrative purposes only. There is no
requirement for any of the following resolver functions to be
implemented.

The ABI requirements for calling convention of resolver functions is
described in `SYSVABI64`_.

Example Resolver Functions
^^^^^^^^^^^^^^^^^^^^^^^^^^

Due to the restrictions on calling convention, the
resolver routines must be written in assembly language.

Static TLS Specialization:

When the TLS variable is in the static TLS block, the offset from the
thread pointer is fixed at runtime. The dynamic loader can calculate
the offset and place it in the TLS descriptor. All the static TLS
resolver function needs to do is extract the offset and return it.

.. code-block:: asm

    _dl_tlsdesc_return:
    // x0 contains pointer to struct tlsdesc.
    // tlsdesc.argument.value contains offset of variable from TP
      ldr   x0, [x0, #8]
      ret

Dynamic TLS Specialization:

When the TLS variable is defined in dynamic TLS the address of the TLS
variable must be calculated by the resolver function using
``__tls_get_addr``. The resolver function returns the offset from the
thread pointer by subtracting the address of the thread pointer from
the address of the TLS variable. In practice an implementation of the
dynamic TLS resolver contains many platform specific details outside
of the scope of the ABI. An example of how a dynamic resolver might be
implemented can be found in the Dynamic Specialization section of
TLSDESC_.

Undefined Weak Symbols

An undefined weak symbol has the value 0. As the resolver function
returns an offset from the Thread Pointer, to get a value of 0 when
added to the Thread Pointer the resolver function returns a negative
thread pointer value that cancels to 0 when added to the thread
pointer.

.. code-block:: asm

    __dl_tlsdesc_undefweak:
      mrs   x0, tpidr_el0
      neg   x0, x0
      ret

Lazy resolution of R_AARCH64_TLSDESC
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The TLSDESC_ paper describes an optional mechanism to resolve TLSDESC
calls lazily. Lazy resolution for TLSDESC resolver functions is not
recommended on AArch64. Additional synchronization is required for
each TLSDESC call, which has a significant affect on performance. The
description below describes the additional synchronization that is
needed.

Instead of fully resolving the ``R_AARCH64_TLSDESC`` relocation at
module load time, a lazy resolver function runs on the first TLSDESC
call. The lazy resolver updates the TLS Descriptor with the actual
resolver function and the parameter to the actual resolver
function. In a multi-threaded program when lazy TLS in use, the
resolver functions must ensure that the write to the parameter in the
TLS descriptor has completed before reading it.

.. code-block:: asm

    // Code to obtain the offset of var from thread pointer.
    // Loads the address of the resolver function into x1.
    // Places the address of the TLS Descriptor into x0.
    adrp  x0, :tlsdesc:var
    ldr   x1, [x0, #:tlsdesc_lo12:var]
    add   x0, x0, #:tlsdesc_lo12:var]
    .tlsdesccall var
    blr   x1 // _dl_desc_return

    // Resolver function
    _dl_tlsdesc_return:
    // load the parameter from the TLS descriptor. Without
    // synchronization this load can read an old value prior
    // to the lazy resolvers update to the descriptor completing.
    ldr   x0, [x0, #8]
    ret

The recommended way to ensure synchronization between the lazy
resolver update of the TLS Descriptor and the actual resolver function
accessing the TLS Descriptor is:

* The TLS lazy resolver function uses a store release when updating
  the address of the resolver function in the TLS Descriptor.

* The actual entry function uses a load acquire on the address of the
  resolver function, with a destination register of xzr.

Referring to the example above, the code for the resolver function
becomes:

.. code-block:: asm

    // Resolver function
    _dl_tlsdesc_return:
    // Guaranteed to complete after the lazy resolvers store release
    // of the address in [x0].
    ldar  xzr, [x0]
    // Access the parameter.
    ldr   x0, [x0, #8]
    ret

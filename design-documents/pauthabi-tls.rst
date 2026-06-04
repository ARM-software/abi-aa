..
   Copyright (c) 2026, Arm Limited and its affiliates.  All rights reserved.
   CC-BY-SA-4.0 AND Apache-Patent-License
   See LICENSE file for details

.. _AAELF64: https://github.com/ARM-software/abi-aa/tree/main/aaelf64/aaelf64.rst
.. _PAUTHABIELF64: https://github.com/ARM-software/abi-aa/tree/main/pauthabielf64/pauthabielf64.rst
.. _SYSVABI64: https://github.com/ARM-software/abi-aa/tree/main/sysvabi64/sysvabi64.rst
.. _TLSDESC: http://www.fsfla.org/~lxoliva/writeups/TLS/RFC-TLSDESC-ARM.txt

TLS in the PAuthABI
*******************

Preamble
========

Background
----------

This document contains additional context for implementing TLS in the
PAuthABI as defined in the ABI extension `PAUTHABIELF64`_. This
document is not normative and `PAUTHABIELF64`_ takes precedence if
there are any discrepancies.

TLS Dialect
-----------

The base ABI in `AAELF64`_ defines relocations for two TLS
dialects. The "traditional" dialect and the "descriptor" dialect. In
the traditional dialect global and local dynamic TLS use the
``R_<CLS>_TLSGD`` and ``R_<CLS>_TLSLD`` prefixed relocations. These
create a pair of GOT entries relocated by ``R_<CLS>_TLS_DTPMOD``. In
the "descriptor" dialect, global and local dynamic TLS use the
``R_<CLS>_TLSDESC`` prefixed relocations. These create a pair of GOT
entries relocated by ``R_<CLS>_TLSDESC``. Local Exec and Initial Exec
TLS are handled the same way in both dialects.

The `PAUTHABIELF64`_ only supports the descriptor based dialect,
primarily because clang only supports the "descriptor" based dialect.

Auth variant TLS relocations
----------------------------

The signing-schema for accessing TLS is platform defined. The
following section is a discussion of the most likely choices.

If the GOT is unsigned, the TLS code-sequences, relocations and
relaxations, from the base ABI can be used, see `AAELF64`_ and
`SYSVABI64`_ for details.

If a GOT entry is signed then AUTH variant static TLS relocations are
required for the static linker to be able use an AUTH variant dynamic
relocation that informs the dynamic linker to sign the GOT entries.

At present there are AUTH variant static and dynamic relocations
defined for TLSDESC, but not for Initial Exec.

Local dynamic TLS does not use the GOT so it can be handled by the
``R_<CLS>_TLSLE`` prefixed relocations defined in `AAELF64`_.

The choice of which GOT entries to sign is a property of the
signing-schema for the platform. For example a signing-schema may only
sign GOT entries containing code-pointers, which would permit Initial
Exec TLS using the ``R_<CLS>_TLSIE`` prefixed relocations defined in
`AAELF64`_. Alternatively a signing-schema may sign all GOT entries.

TLS Relaxation
--------------

The static linker may relax a more general TLS model to a more
constrained model when TLS variables meet the requirements for using
the constrained model, and the relaxed sequence is permitted by the
signing-schema of the platform.

The AUTH variant TLSDESC sequence to access TLS variable ``v`` is as
described below:

  .. code

     adrp x0, :tlsdesc_auth:v // R_AARCH64_AUTH_TLS_ADR_PAGE21
     ldr  x16, [x0, #:tlsdesc_auth_lo12:v] // R_AARCH64_AUTH_TLSDESC_LD64_LO12
     add  x0, x0, #:tlsdesc_auth_lo12:v // R_AARCH64_AUTH_TLSDESC_ADD_LO12
     .tlsauthdesccall v //R_AARCH64_AUTH_TLSDESC_CALL
     blraa x16, x0

There are no AUTH variant TLSIE relocations defined so a relaxation is
only possible to an unsigned GOT entry if permitted by the
signing-schema:

  .. code

     adrp x0, :gottprel:v            // R_AARCH64_TLSIE_ADR_GOTTPREL_PAGE21 v
     ldr  x0, [x0, #:gottprel_lo12:v] // R_AARCH64_TLSIE_LD64_GOTTPREL_LO12_NC v
     nop
     nop

A theoretical relaxation for a signed GOT is possible when the
architectural feature ``FEAT_FPAC`` is available or a signing-schema
does not require an immediate trap on failure of an AUTH
(``-fno-ptrauth-traps`` in clang).

  .. code

     adrp x0, :gottprel:v           // R_AARCH64_AUTH_TLSIE_ADR_GOTTPREL_PAGE21 v
     add  x1, x0, #:gottprel_lo12:v // R_AARCH64_AUTH_TLSIE_ADD_LO12 v
     ldr  x0, [x1]
     autia x0, x1

There are no spare instructions to test whether the TLS offset in
``x0`` authenticated successfully.

A relaxation to local-exec is always possible as no GOT entry is used.

  .. code

    movz    x0, :tprel_g1:v // R_AARCH64_TLSLE_MOVW_TPREL_G1 v
    movk    x0, :tprel_g0:v // R_AARCH64_TLSLE_MOVW_TPREL_G0_NC v
    nop
    nop

A weak reference that is known at static link time to be undefined can
be relaxed by setting the offset so that it cancels to 0 when added to
the thread pointer.

  .. code

   mrs x0, tpidr_el0
   neg x0, x0
   nop
   nop

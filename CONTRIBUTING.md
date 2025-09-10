# Thank you for considering contributing!

Contributions are always welcome. We accept [bug fixes](#bugs), [proposals and
new ideas](#proposals-for-new-content), or simply editorial improvements.

By submitting a pull request you are implicitly adhering to the
[contribution agreement](#contribution-agreement).

## Bugs

You can report a bug by creating an
[issue](https://github.com/ARM-software/abi/issues). You can also fix
it yourself with a [pull
request](https://github.com/ARM-software/abi/pulls).

## Proposals for new content

We are open to any proposal that will improve either the content or the
presentation of the ABI.

Arm recommends that you
present them in a [pull
request](https://github.com/ARM-software/acle/pulls), along with the
following details:

1. A rationale in support of the changes.
2. A design document to keep track of the reasoning that made the
   proposal reach its current state.

Please note that this extra information is not a requirement for
submitting new content. Contributors are trusted to use their judgment
to decide whether or not the proposal needs this information. Arm
recommends that you add this information so that it is easier for new
ideas to be discussed and possibly accepted, especially for changes of
great impact.

Instead of a pull request, you can also create an
[issue](https://github.com/ARM-software/abi/issues), in which you describe your
proposed change. However beware that opening an issue will have less chance to
make it into the ABI, as someone will need to do the leg-work to make actual
changes.

If you want to make ABI changes that for some reason can't be discussed in
public, you can send an email to arm.eabi@arm.com.

### Extension documents
While the majority of new proposals can be added to existing
documents. Proposals that extend the ABI, but are not yet stable are
placed in an extension document. An example of an extension document
is the PAuth Extension to ELF for Arm 64-bit Architecture. Extension
documents have the following requirements:

1. The document status must be Alpha.
2. The document has an owner recorded in the table below. The owner
   need not be from Arm.
3. The document must not clash with other ABI extension documents, or
   both extensions must be marked as being incompatible.


The Arm approval process for accepting the extension is as follows:

1. At least one person within Arm has reviewed and accepted the pull
   request.
2. There is a consensus within Arm that the extension can be added to
   the ABI.

Extension documents can move into the main ABI when the following conditions hold:

1. The information in the document is stable.
2. There is an implementation of the extension.
3. The boundaries of when the extension applies are clear.

An extension document that moves into the main ABI will add the
necessary information to the main documents. In addition any design
and rationale in the extension document will be moved to a new
document in the design-documents folder.

When the extension has either moved into the main ABI or has been
withdrawn it will be moved to an archive folder.

## Manual checking of the PDF documents and Continuous Integration

To check the outcome of your changes, use the `tools/rst2pdf/generate-pdfs.sh`
script. To install the (python) prerequisites for the script, do the following.

Create and activate Python virtual environment:

```
python3 -m venv ./venv
source ./venv/bin/activate
pip3 install -U pip setuptools wheel
```

Run the `tools/rst2pdf/install.sh` script.

Now run the `tools/rst2pdf/generate-pdfs.sh`:

```
./tools/rst2pdf/generate-pdfs.sh build
```

The generated PDF files will be in the `build` directory.

You can also check the rst syntax of the documents you changed with the
`tools/common/check-rst-syntax.sh` script.

These scripts have only been tested on Linux.

## Continuous integration

Whenever you create a pull request, these syntax checking and PDF generating
scripts will be executed by `Github Actions`.

You can download the PDFs in the `Checks` tab of any pull request (in the
`Checks` tab click on the `CI` summary page above the highlighted `Build`
sub-tab).

The CI bot will also check the `rst` syntax of the documents. You can check the
output in the `Checks` tab in the `check .rst document syntax` build log
dropdown.

# Pull request workflow

1. Make pull request

    First you will have to make the actual pull request, which contains the
    proposed changes. If you are unfamiliar with Github pull requests, you can
    read up on them
    [here](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/about-pull-requests).

    New development (bug-fixes, proposals, extensions, and so on) is committed
    on the `main` development branch. Therefore, please submit your PR against
    the branch `main`.

    If your change is substansive, please add a short entry to the `Change
    history` section of the changed documents that makes clear what you changed.

    Design documents are placed in the `<root>/design-documents` directory.

2. Review of pull request

    Your pull request needs to be reviewed. Anyone can review, but at least one
    of the reviewers needs to be someone from Arm. Good candidate to review your
    change would be the various so-called document owners who look after the
    quality of the individual documents. Not every document has an owner, but
    the most used and important ones do. See the table below:

document | owner | Github handle
---      | ---   | ---
[Procedure Call Standard for the Arm Architecture](https://github.com/ARM-software/abi-aa/tree/master/aapcs32) | Ties Stuij | @stuij
[Procedure Call Standard for the Arm 64-bit Architecture](https://github.com/ARM-software/abi-aa/tree/main/aapcs64) | Ties Stuij | @stuij
[ELF for the Arm Architecture](https://github.com/ARM-software/abi-aa/blob/master/aaelf32) | Matthew Malcomson | @mmalcomson
[ELF for the Arm 64-bit Architecture](https://github.com/ARM-software/abi-aa/tree/master/aaelf64) | Matthew Malcomson | @mmalcomson
[DWARF for the Arm Architecture](https://github.com/ARM-software/abi-aa/tree/main/aadwarf32) | Keith Walker | @walkerkd
[DWARF for the Arm 64-bit Architecture](https://github.com/ARM-software/abi-aa/tree/main/aadwarf64) | Keith Walker | @walkerkd
[PAUTH Extension to ELF for the Arm 64-bit Architecture](https://github.com/ARM-software/abi-aa/tree/master/pauthabielf64) | Peter Smith | @smithp35
[Exception Handling ABI for the Arm Architecture](https://github.com/ARM-software/abi-aa/tree/master/ehabi32) | Victor Campos | @vhscampos
[Vector Function Application Binary Interface Specification for AArch64](https://github.com/ARM-software/abi-aa/tree/master/vfabia64) | Richard Sandiford | @rsandifo-arm
[System V ABI for the Arm 64-bit Architecture](https://github.com/ARM-software/abi-aa/tree/master/sysvabi64) | Peter Smith | @smithp35
[Morello extensions to Procedure Call Standard for the Arm 64-bit Architecture](https://github.com/ARM-software/abi-aa/tree/master/aapcs64-morello) | Silviu Baranga | @sbaranga-arm
[Morello extensions to ELF for the Arm 64-bit Architecture](https://github.com/ARM-software/abi-aa/tree/master/aaelf64-morello) | Silviu Baranga | @sbaranga-arm
[Morello Descriptor ABI for the Arm 64-bit Architecture](https://github.com/ARM-software/abi-aa/tree/master/descabi-morello) | Silviu Baranga | @sbaranga-arm
[Memtag ABI Extension to ELF for the Arm 64-bit Architecture](https://github.com/ARM-software/abi-aa/tree/master/memtagabielf64) | Florian Mayer | @fmayer
[C/C++ Atomics Application Binary Interface Standard for the Arm 64-bit Architecture](https://github.com/ARM-software/abi-aa/tree/master/atomicsabi64) | Luke Geeson | @lukeg101
[AArch64 ELF Conventions for Binary Analysis](https://github.com/ARM-software/abi-aa/tree/main/baabielf64) | Pavel Iliin | @ilinpv

3. Merging the change

    Once the change has been reviewed properly it can be merged, which can only
    be done by a member of the abi-aa admin group. If your change hasn't been
    merged for more than a week after it has been accepted, leave a comment on
    the pull request. Merging of changes should use the rebase and merge
    strategy. Other merge options should be disabled.

# Style guide

- We favor simple language over complicated language.
- If in doubt, we'll consult the
  [Chicago Manual of Style](https://www.chicagomanualofstyle.org/home.html) as
  it is a de facto standard.
- We should use Sentence case rather than Title Case for section headings. So
  capitalization only of the first word.


# Contribution agreement

Contributions to this project are licensed under an inbound=outbound
model such that any such contributions are licensed by the contributor
under the same terms as those in the [LICENSE](LICENSE.md) file.

We _do not_ require copyright assignment. The original contributor
will retain the copyright.

When adding content for the first time to an existing ABI specification or when
creating a new one, you should add the copyright owner (presumably either
yourself or your organization) to the list of copyright owners in the copyright
notices section at the top of the document. Add a copyright notice in the same
style as the other copyright notices already present.

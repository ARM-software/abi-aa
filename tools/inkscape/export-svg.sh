#!/bin/sh

# Copyright (c) 2020-2021, Arm Limited
# SPDX-License-Identifier: Apache-2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


# Script to process the SVG diagrams found in some of these
# subdirectories.
#
# The diagrams tend to use the SVG 'marker' feature that makes it easy
# to put an arrowhead on the end of a line. This makes them easy to
# edit in (for example) Inkscape, because when you move a line, the
# arrowhead automatically moves with it. Unfortunately that arrowhead
# feature is not supported by the combination of rst2pdf and svglib,
# so importing an SVG like that directly into the PDF ABI documents
# loses all the arrowheads.
#
# A workaround is to round-trip via EPS, because EPS also lacks a
# built-in arrowhead primitive, so forcing Inkscape to export to EPS
# causes it to realize the arrowheads as ordinary SVG paths. Then,
# when those are re-imported to SVG, you end up with simpler SVG that
# rst2pdf can handle.

if test $# != 2; then
    echo >&2 "usage: export-svg.sh <input SVG> <output SVG>"
    exit 1
fi

set -e

temp_eps=$(mktemp -t abiXXXXXX.eps)
temp_svg=$(mktemp -t abiXXXXXX.svg)

inkscape "$1" --export-eps="$temp_eps"
inkscape "$temp_eps" --export-plain-svg="$temp_svg"
rm -f "$temp_eps"

# Also, while we're processing this file, coerce the font
# specifications back to something sensible. The round-trip process
# will have unhelpfully converted the generic specification
# 'sans-serif' into a specific thing like 'DejaVu Sans' which won't be
# what we want.
#
# In fact, a good choice is Helvetica, on the grounds that it's a
# standard built-in font in the PDF spec.
sed 's/font-family:[^;]*/font-family:Helvetica/g' "$temp_svg" > "$2"
rm -f "$temp_svg"

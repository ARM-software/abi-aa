#!/usr/bin/env python

# Copyright (c) 2021-2022, Arm Limited
# SPDX-License-Identifier: Apache-2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# invocation example:
# ./tools/common/new-release.py . 2021 Q1 "02\ :sup:\`nd\` March"

import argparse
import os
import re

description = (
    "Replace dates in ABI files with dates suitable for a new release.")


def convert(text, quarter, year, date_of_issue):
    re_pairs = [
        (r"(\|release\| replace:: )(.*)", lambda x: x.group(1) + year + quarter),
        (r"(\|date-of-issue\| replace:: )(.*)", lambda x: x.group(1) + date_of_issue),
        # In copyright statements:
        # append this year to last year with a hyphen if it's not a range:
        # Copyright (c) 2003-2007, 2012, 2018, 2020
        # becomes:
        # Copyright (c) 2003-2007, 2012, 2018, 2020-2021
        (r"(opyright.* )(\d+)(?!.*\d)", lambda x: \
                                                x.group(1) + year \
                                            if x.group(2) == year \
                                                else x.group(1) + x.group(2) + "-" + year),
        # replace last year with this year, if it's part of a range:
        # Copyright (c) 2003-2007, 2012, 2018-2020
        # becomes:
        # Copyright (c) 2003-2007, 2012, 2018-2021
        (r"(opyright.*-)(\d+)(?!.*\d)", lambda x: x.group(1) + year),
    ]

    for rex, fn in re_pairs:
        regex = re.compile(rex)
        text = regex.sub(fn, text)
    return text


def convert_file(file, year, quarter, date_of_issue):
    with open(file) as f_in:
        text = f_in.read()
    with open(file, "w+") as f_out:
        converted = convert(text, quarter, year, date_of_issue)
        f_out.write(converted)


def main(root, year, quarter, date_of_issue):
    text = ""
    for subdir, dirs, files in os.walk(root):
        for file in files:
            ext = os.path.splitext(file)[-1].lower()
            if ext in [".rst", ".py"]:
                convert_file(os.path.join(subdir, file), year, quarter, date_of_issue)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=description)
    parser.add_argument("file", help="path of rst file to be converted")
    parser.add_argument("year", help="current year: 2020")
    parser.add_argument("quarter", help="current quarter: Q1")
    parser.add_argument("date_of_issue", help="date of issue, without year: 01\\ :sup:`st` March")
    args = parser.parse_args()

    main(args.file, args.year, args.quarter, "{0} {1}".format(args.date_of_issue, args.year))

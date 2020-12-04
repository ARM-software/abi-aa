#!/usr/bin/env bash
cd $(dirname $BASH_SOURCE)

# we need a very recent version of rst2pdf, as (currently) the latest release
# installed with Ubuntu 16.04 contains a bug where the contents section links
# are broken
# the rst2pdf release below is 0.98
pip install -r requirements.txt

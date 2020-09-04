#!/usr/bin/env bash

# we need a very recent version of rst2pdf, as (currently) the latest release
# installed with Ubuntu 16.04 contains a bug where the contents section links
# are broken
# the rst2pdf release below is 0.98
pip install git+git://github.com/rst2pdf/rst2pdf@d9bf8cd737c11cfc572c936173228c1103344fdf
pip install rstcheck matplotlib

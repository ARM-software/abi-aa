#!/usr/bin/env bash

# we need a very recent version of rst2pdf, as (currently) the latest release
# contains a bug where the contents section links are broken
pip install git+git://github.com/rst2pdf/rst2pdf@4d617f348d967f54679294c7ef5dc21f45e34923
pip install rstcheck matplotlib

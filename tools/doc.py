#! /usr/bin/env python
# -*- coding: utf-8 -*-

import re
import os


source_file = "src/Makefile"

Makefile = open(source_file).readlines();

buff = []
append = False
is_equal_separator = lambda line: re.match(r"#\s*=+", line)
is_target = lambda line: re.match(r"\t*\s*([$_\-(){}/a-zA-Z]+)\s*:.*", line)
is_comment = lambda line: re.match(r"\s*#\s*(.*)", line)

for line in open(source_file):
    if append:
        m = is_comment(line)
        if m:
            buff += [m.group(1)]
    if not append and is_equal_separator(line):
        append = True
    if is_target(line):
        target      = is_target(line).group(1)
        target_body = "\n".join(buff)
        buff = []
        append = False
        if len(target_body):
            print(target_body)
            print("```bash \nmake %s\n```"%target)





#vim-run: python % > DOCUMENTATION.md

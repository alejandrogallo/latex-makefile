#! /usr/bin/env python
# -*- coding: utf-8 -*-

import re
import os
import sys


source_file = "src/Makefile"

Makefile = open(source_file).readlines();

buff = []
append = False
is_equal_separator = lambda line: re.match(r"#\s*=+", line)
is_target = lambda line: re.match(r"\t*\s*([$_\-(){}/a-zA-Z]+)\s*:.*", line)
is_comment = lambda line: re.match(r"\s*#\s*(.*)", line)
is_variable = lambda line: re.match(r"^([$_\-(){}/a-zA-Z]+)\s*\?=\s*([^$].*)\s*", line)
is_empty = lambda line: re.match(r"^\s*$", line)

source_lines = open(source_file).readlines()

comment_buffer = []
print("## Overridable variables ##")
print("  * `%s`(`%s`): %s"%(
    "VAR_NAME",
    "DEFAULT",
    """ Brief description. If the default value is too long to appear it is
    omitted and a `see` is put in its place.  If there is no default value then
    the keyword `empty` appears.
    """
))
for line in source_lines:
    m = is_comment(line)
    if m:
        comment_buffer.append(m.group(1))
        continue
    elif is_empty(line):
        comment_buffer = []
        continue
    m = is_variable(line)
    if m:
        print("  * `%s`(`%s`): %s"%(
            m.group(1),
            re.sub(r"\s*\$.*","see",m.group(2).replace("\n","")) or "empty",
            " ".join(comment_buffer)
            ))
        comment_buffer = []
    else:
        comment_buffer = []


# sys.exit(0)

print("## Targets ##")
for line in source_lines:
    if append:
        m = is_comment(line)
        if m:
            buff += [m.group(1)]
    if not append and is_equal_separator(line):
        append = True
    if is_target(line):
        target      = is_target(line).group(1)
        if len(buff):
            buff[0] = "### %s ###"%buff[0]
        target_body = "\n".join(buff)
        buff = []
        append = False
        if len(target_body):
            print(re.sub(r"==+","",target_body))
            print("```bash \nmake %s\n```"%target)





#vim-run: python %
#vim-run: python % > DOCUMENTATION.md

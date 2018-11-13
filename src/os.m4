# Recognise OS
ifeq ($(shell uname),Linux)
LINUX := 1
OSX   :=
else
LINUX :=
OSX   := 1
endif

dnl vim:ft=make:noexpandtab:

#
# Copyright © 2020-2023 Tomasz Augustyn
# All rights reserved.
#
# Project Name: Call Stack Logger
# GitHub: https://github.com/TomaszAugustyn/call-stack-logger
# Contact Email: t.augustyn@poczta.fm

ODIR = build
EXECUTABLE = $(ODIR)/runDemo
MKDIR_P = mkdir -p

.PHONY: all test callStack
all: makedirs callStack test 


callStack:
	$(MAKE) -C src

test:callStack
	$(MAKE) -C test

makedirs: $(ODIR)

${ODIR}:
	${MKDIR_P} ${ODIR}

run:
	$(EXECUTABLE)

clean:
	rm -f $(ODIR)/*
	$(MAKE) -C test clean
	$(MAKE) -C src clean

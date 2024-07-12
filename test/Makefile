#
# Copyright © 2020-2023 Tomasz Augustyn
# All rights reserved.
#
# Project Name: Call Stack Logger
# GitHub: https://github.com/TomaszAugustyn/call-stack-logger
# Contact Email: t.augustyn@poczta.fm

# Find C++ Standard Library header files to exclude them from instrumentation
CPP_STD_INCLUDES=$(shell ( 	`gcc -print-prog-name=cc1plus` -v < /dev/null 2>&1 \
								| LC_ALL=C sed -ne '/starts here/,/End of/p' \
								| grep -o '/[^"]*' ; \
							`gcc -print-prog-name=cpp` -v < /dev/null 2>&1 \
								| LC_ALL=C sed -ne '/starts here/,/End of/p' \
								| grep -o '/[^"]*' ) \
						| cat | sort | uniq | tr '\n' ',' | sed 's/\(.*\),/\1 /' | xargs )

# Exclude tracing functions themselves from instrumentation
CPP_STD_INCLUDES := "${CPP_STD_INCLUDES},include/callStack.h,include/unwinder.h,include/types.h,include/format.h,include/prettyTime.h"
$(info $$CPP_STD_INCLUDES is [${CPP_STD_INCLUDES}])

CXX ?= g++
CXXFLAGS += -g -Wall -rdynamic -std=c++17 -finstrument-functions -finstrument-functions-exclude-file-list=$(CPP_STD_INCLUDES)

IDIR = ../include
ODIR = ../build
LIB_DIR = ../lib
INCS = -I$(IDIR) -L$(LIB_DIR)
LIBS = -ldl -lbfd 

#SOURCES := $(shell find . -name "*.cpp" -printf '%f\n')
SOURCES := main.cpp

_HEADERS  := $(shell find $(IDIR) -name "*.h" -printf '%f\n')

HEADERS = $(patsubst %,$(IDIR)/%,$(_HEADERS))

_OBJS = $(SOURCES:.cpp=.o)
$(info "_OBJS is ${_OBJS}")

OBJS = $(patsubst %,$(ODIR)/%,$(_OBJS))
$(info "OBJS is ${OBJS}")
$(info "_OBJS_TEST is ${_OBJS_TEST}")

EXECUTABLE = $(ODIR)/runDemo
LIBRARY = $(ODIR)/libcallstack.a

ifdef log_with_addr
	CXXFLAGS += -DLOG_ADDR
endif
ifdef log_not_demangled
	CXXFLAGS += -DLOG_NOT_DEMANGLED
endif
ifdef disable_instrumentation
	CXXFLAGS = -g -Wall -std=c++17 -DDISABLE_INSTRUMENTATION
endif

.PHONY: build libcallstack run
build: $(SOURCES) $(EXECUTABLE)

$(EXECUTABLE): $(LIBRARY) $(_OBJS_TEST)
	$(CXX) $(CXXFLAGS) -o $@ $^ $(LIBS)

$(LIBRARY): $(OBJS)
	$(AR) -r $@ $^

$(ODIR)/%.o : %.cpp $(HEADERS)
	$(CXX) $(CXXFLAGS) -c $< -o $@ $(INCS)

run:
	$(EXECUTABLE)

libcallstack:
	$(LIBRARY)


.PHONY: clean
clean:
	rm -f $(EXECUTABLE) $(OBJS)

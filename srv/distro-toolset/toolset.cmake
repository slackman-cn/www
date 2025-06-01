# cmake -P xxx.cmake
cmake_minimum_required(VERSION 3.16)
project(toolchain)
project(toolset)

configure_file(version.h.in version.h)

target(x86_64-unknown-linux-gnu)

参考 openwrt

find_library 默认有
find_binary,
find_package 默认有; 代替 build_requires

doc_template
  $project
  $project

SHELL := /bin/bash

TOOLS_HOST := autoconf autogen automake bash ld expect g++ gcc \
              make tar gzip bzip2 patch cp grep sed awk libtoolize \
              makeinfo xz rsync bison flex m4 runtest

host:
	@echo "================================================================"
	@echo "TFS-ENVIRONMENT HOST TOOLS"
	@echo "================================================================"
	for I in $(TOOLS_HOST); do \
	  if ! which "$${I}" 2>&1 && [[ ! -e "$${I}" ]]; then \
	    echo "Host tool/file \`$${I}' not installed."; \
	    exit 1; \
	  fi; \
	done


function(TEMPLATE Arg0)
    message("${CMAKE_CURRENT_FUNCTION}")
    message("ARG: ${ARGV0}")
    message("ARG: ${Arg0}")
endfunction()

set(Var "First")
MY_FNC(${Var})
My_FNC("Fist")

// DOWNLOAD_SOURCE
// PRE_CHECK_BIN

// CHECK_BIN
function(CHECK_BINARY Arg0)
    message("${CMAKE_CURRENT_FUNCTION}")
    message("ARG: ${ARGV0}")
    message("ARG: ${Arg0}")
endfunction()

// CHECK_LIB & include
function(CHECK_LIBRARY Arg0)
    message("${CMAKE_CURRENT_FUNCTION}")
    message("ARG: ${ARGV0}")
    message("ARG: ${Arg0}")
endfunction()

function(CHECK_INCLUDE Arg0)
    message("${CMAKE_CURRENT_FUNCTION}")
    message("ARG: ${ARGV0}")
    message("ARG: ${Arg0}")
endfunction()
#!/bin/bash
~/.vim/bundle/runVimTests/bin/runVimTests.sh --source "`pwd`/autoload/vmustache.vim" "${1-tests/}"

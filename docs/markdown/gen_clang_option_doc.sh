#!/bin/bash

## generates documentation about clang options.

clang=/opt/rocm/llvm/bin/clang

exec > clang_options.md

echo "# Support of Clang options"
echo " Clang versiion: $($clang --version | head -1)"
echo
echo "|Option|Support|Description|"
echo "|-------|------|-------|"

$clang --help | sed '1,5d'|  while read a b; do
  if [[ "$a" != "-"* ]]; then
    desc="$a $b"
  elif [[ "$b" = *'>'* ]]; then
    opt=$(echo $a $b| sed 's:\(^-[^ ]*[= ]*<[^<>]*>\) *\(.*\):\1:')
    desc=$(echo $a $b| sed 's:\(^-[^ ]*[= ]*<[^<>]*>\) *\(.*\):\2:')
    if [[ "$opt" == "$desc" ]]; then
      opt="$a"
      desc="$b"
    fi
  else
    opt="$a"
    desc="$b"
  fi
  if [[ "$desc" != "" ]]; then
    echo '|`'$opt'`||`'$desc'`|'
  fi
done

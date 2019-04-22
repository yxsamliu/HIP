#!/bin/bash

## generates documentation about clang options.

clang=/opt/rocm/llvm/bin/clang

exec > clang_options.md

echo "# Support of Clang options"
echo " Clang versiion: $($clang --version | head -1)"
echo
echo "|Option|Support|Description|"
echo "|-------|------|-------|"

$clang --help | sed '5d'|  while read a b; do
  if [[ "$a" != "-"* ]]; then
    continue
  elif [[ "$b" = *'>'* ]]; then
    res=$(echo $a $b| sed 's:\(^-[^ ]*[= ]*<[^<>]*>\) *\(.*\):|`\1`||`\2`|:')
    if [[ "$res" == "$a $b" ]]; then
      echo '|`'$a'`||`'$b'`|'
    else
      echo $res
    fi
  else
    echo '|`'$a'`||`'$b'`|'
  fi
done

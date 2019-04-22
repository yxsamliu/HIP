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
    opt=$(echo $a $b| sed -e 's:\(^-[^ ]*[= ]*<[^<>]*>\) *\(.*\):\1:')
    desc=$(echo $a $b| sed -e 's:\(^-[^ ]*[= ]*<[^<>]*>\) *\(.*\):\2:')
    if [[ "$opt" == "$desc" ]]; then
      opt="$a"
      desc="$b"
    fi
  else
    opt="$a"
    desc="$b"
  fi
  supp=
  if [[ "$desc" = *AArch* ||\
	"$desc" = *MIPS* || \
	"$desc" = *ARM* || \
	"$desc" = *Objective-C* ]]; then
    supp="Unsupported"
  elif [[ "$desc" = *OpenCL* ||\
	"$desc" = *HIP* || \
	"$desc" = *AMDGPU* ]]; then
    supp="Supported"
  fi
  desc=$(echo "$desc"| sed -e 's:|:\\|:g')
  #echo a=$a
  #echo b=$b
  #echo opt=$opt
  #echo desc=$desc
  if [[ "$desc" != "" ]]; then
    echo '|`'$opt'`|'$supp'|`'$desc'`|'
  fi
done

#!/usr/bin/env bash

# Task : Remove ignored files by .gitignore file, located in bower components directory

#base_path=$(dirname $(dirname $(readlink -e $0)));
base_path='./';
bowerrc=$base_path'.bowerrc';
if [ -f "$bowerrc" ]; then
  bower_components_path=$base_path$(grep -Po '(?<="directory": ")[^"]*' "$bowerrc");
  if [ -d "$bower_components_path" ]; then
    gitignore_file=$bower_components_path'/.gitignore';
    if [ -f "$gitignore_file" ]; then
      gitignore_content=$(cat "$gitignore_file" | grep -v -e '^#' -e '^$');
      echo "Removing files, declared in .gitignore ($gitignore_file) file:";
      while read line; do
        if [[ ! -z "$line" ]]; then
          entry_path="$bower_components_path/"$(sed 's/^\///' <<< "$line");
          if [ ! "$entry_path" == "$bower_components_path" ]; then
            if [ ! -z "$(ls -la $entry_path 2>/dev/null)" ]; then
              echo "Try to remove $entry_path";
              rm -Rf $entry_path;
            fi;
          fi;
        fi;
      done <<< "$gitignore_content";
    else
      echo '"'$gitignore_file'" file not found';
    fi;
  else
    echo 'Directory "'$bower_components_path'" not found';
  fi;
else
  echo '"'$bowerrc'" file not found';
fi;
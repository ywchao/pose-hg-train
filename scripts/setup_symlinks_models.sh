#!/bin/bash

echo "Setting up symlinks for precomputed hg models..."

dir_name=( "mpii" "penn_action_cropped" )

cd exp

for k in "${dir_name[@]}"; do
  if [ -L $k ]; then
    rm $k
  fi
  if [ -d $k ]; then
    echo "Failed: exp/$k already exists as a folder..."
    continue
  fi
  ln -s precomputed_hg_models/$k $k
done

cd ..

echo "Done."

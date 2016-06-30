#!/bin/bash

if [ $# -eq 0 ]; then
  gpu_id=0
else
  gpu_id=$1
fi

ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/../.." && pwd )"
cd "$ROOT_DIR/src"

th main.lua \
  -expID umich-stacked-hourglass \
  -manualSeed 3 \
  -GPU $gpu_id \
  -loadModel $ROOT_DIR/../data/umich-stacked-hourglass/umich-stacked-hourglass.t7

th main.lua \
  -expID umich-stacked-hourglass-final-preds \
  -GPU $gpu_id \
  -finalPredictions 1 \
  -nEpochs 0 \
  -loadModel $ROOT_DIR/../data/umich-stacked-hourglass/umich-stacked-hourglass.t7

#!/bin/bash

if [ $# -eq 0 ]; then
  gpu_id=0
else
  gpu_id=$1
fi

ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
cd "$ROOT_DIR/src"

th main.lua \
  -manualSeed 3 \
  -GPU $gpu_id \

th main.lua \
  -branch default \
  -expID default-final-preds \
  -GPU $gpu_id \
  -finalPredictions 1 \
  -nEpochs 0

#!/bin/bash

if [ $# -eq 0 ]; then
  gpu_id=0
else
  gpu_id=$1
fi

ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/../.." && pwd )"
cd "$ROOT_DIR/src"

th main.lua \
  -expID hg-single-no-skip \
  -dataset penn_action_cropped \
  -manualSeed 3 \
  -GPU $gpu_id \
  -netType hg-single-no-skip \
  -task pose \
  -nStack 1 \
  -trainIters 13121 \
  -validIters 8721

th main.lua \
  -expID hg-single-no-skip-final-preds \
  -dataset penn_action_cropped \
  -GPU $gpu_id \
  -finalPredictions 1 \
  -branch hg-single-no-skip \
  -nEpochs 0

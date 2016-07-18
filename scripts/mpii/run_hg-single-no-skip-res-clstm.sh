#!/bin/bash

if [ $# -eq 0 ]; then
  gpu_id=0
else
  gpu_id=$1
fi

ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/../.." && pwd )"
cd "$ROOT_DIR/src"

th main.lua \
  -expID hg-single-no-skip-res-clstm \
  -manualSeed 3 \
  -GPU $gpu_id \
  -netType hg-single-no-skip-res-clstm \
  -task pose \
  -nStack 1

th main.lua \
  -branch hg-single-no-skip-res-clstm \
  -expID hg-single-no-skip-res-clstm-final-preds \
  -GPU $gpu_id \
  -finalPredictions 1 \
  -nEpochs 0

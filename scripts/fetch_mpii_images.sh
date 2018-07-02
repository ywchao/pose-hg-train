#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/../data/mpii" && pwd )"
cd $DIR

FILE=mpii_human_pose_v1.tar.gz
URL=https://datasets.d2.mpi-inf.mpg.de/andriluka14cvpr/mpii_human_pose_v1.tar.gz

if [ -f $FILE ]; then
  echo "File already exists..."
  exit 0
fi

echo "Downloading MPII Human Pose images (12G)..."

wget $URL -O $FILE

echo "Unzipping..."

tar zxvf $FILE

echo "Done."

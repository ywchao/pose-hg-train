#!/usr/bin/env python

import penn
import sys
import os
import h5py
import numpy as np

sys.path.append('tools')

def read_file_lines(file):
    lines = [line.strip() for line in open(file)]; 
    return lines

def write_file_h5(file,dict,attrs):
  with h5py.File(file,'w') as f:
    f.attrs['name'] = attrs
    for k in dict.keys():
      f[k] = np.array(dict[k])

def write_file_lines(file,lines,method):
# method: 'w' or 'a'
  file = open(file,method)
  for idx, line in enumerate(lines):
    file.write(line)
    if idx != len(lines) - 1:
      file.write("\n")
  file.close()

# read valid ind (one-based)
vind_file = './data/penn_action_cropped/annot/valid_ind.txt'
valid_ind = read_file_lines(vind_file)
valid_ind = [int(x) for x in valid_ind]

# init variables
keys = ['index','center','scale','part','visible','normalize','torsoangle']
annot_tr = {k:[] for k in keys}
annot_vl = {k:[] for k in keys}
annot_ts = {k:[] for k in keys}
ls_tr = []
ls_vl = []
ls_ts = []

# set outputs
op_dir = './data/penn_action_cropped/annot/'
tr_h5 = op_dir + 'train.h5'
vl_h5 = op_dir + 'valid.h5'
ts_h5 = op_dir + 'test.h5'
tr_txt = op_dir + 'train_images.txt'
vl_txt = op_dir + 'valid_images.txt'
ts_txt = op_dir + 'test_images.txt'

for idx in xrange(penn.nimages):
  # Center and scale
  c,s = penn.location(idx)
  # Adjust center/scale slightly to avoid cropping limbs
  # (in hindsight this should have been done in the Torch code...)
  c = [float(i) for i in c]
  c[1] += 15 * s
  s *= 1.25

  # Part annotations and visibility
  coords,vis = penn.partinfo(idx)
  # skip if no visible joints
  # 1. all joints
  # if np.all(vis == False): continue
  # 2. difficult joints, i.e. idx 3 to 12
  if np.all(vis[3:] == False): continue

  # Check train/valid/test association
  if penn.istrain(idx):
    if penn.seqind(idx)+1 not in valid_ind:
      annot = annot_tr
      ls = ls_tr
    else:
      annot = annot_vl
      ls = ls_vl
  else:
    annot = annot_ts
    ls = ls_ts

  # Add info to annotation list
  annot['index'] += [idx]
  annot['center'] += [c]
  annot['scale'] += [s]
  annot['part'] += [coords]
  annot['visible'] += [vis]
  annot['normalize'] += [-1]
  annot['torsoangle'] += [-1]

  # Append image path
  ls.append(penn.imgpath(idx))

  # Show progress
  print "images\rprocessed",idx+1,
  sys.stdout.flush()

print ""

# generate h5 files
if not os.path.isfile(tr_h5):
  write_file_h5(tr_h5,annot_tr,'penn_action_cropped')
if not os.path.isfile(vl_h5):
  write_file_h5(vl_h5,annot_vl,'penn_action_cropped')
if not os.path.isfile(ts_h5):
  write_file_h5(ts_h5,annot_ts,'penn_action_cropped')

# generate txt files
if not os.path.isfile(tr_txt):
  write_file_lines(tr_txt,ls_tr,'w')
if not os.path.isfile(vl_txt):
  write_file_lines(vl_txt,ls_vl,'w')
if not os.path.isfile(ts_txt):
  write_file_lines(ts_txt,ls_ts,'w')

print "done."
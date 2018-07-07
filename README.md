# Stacked Hourglass Networks for Human Pose Estimation (Training Code)

This is the training pipeline used for:

Alejandro Newell, Kaiyu Yang, and Jia Deng,
**Stacked Hourglass Networks for Human Pose Estimation**,
[arXiv:1603.06937](http://arxiv.org/abs/1603.06937), 2016.

A pretrained model is available on the [project site](http://www-personal.umich.edu/~alnewell/pose). You can use the option `-loadModel path/to/model` to try fine-tuning. 

To run this code, make sure the following are installed:

- [Torch7](https://github.com/torch/torch7)
- hdf5
- cudnn

## Getting Started ##

Download the full [MPII Human Pose dataset](http://human-pose.mpi-inf.mpg.de), and place the `images` directory in `data/mpii`. From there, it is as simple as running `th main.lua -expID test-run` (the experiment ID is arbitrary). To run on [FLIC](http://bensapp.github.io/flic-dataset.html), again place the images in a directory `data/flic/images` then call `th main.lua -dataset flic -expID test-run`.

Most of the command line options are pretty self-explanatory, and can be found in `src/opts.lua`. The `-expID` option will be used to save important information in a directory like `pose-hg-train/exp/mpii/test-run`. This directory will include snapshots of the trained model, training/validations logs with loss and accuracy information, and details of the options set for that particular experiment.

## Running experiments ##

There are a couple features to make experiments a bit easier:

- Experiment can be continued with `th main.lua -expID example-exp -continue` it will pick up where the experiment left off with all of the same options set. But let's say you want to change an option like the learning rate, then you can do the same call as above but add the option `-LR 1e-5` for example and it will preserve all old options except for the new learning rate.

- In addition, the `-branch` option allows for the initialization of a new experiment directory leaving the original experiment intact. For example, if you have trained for a while and want to drop the learning rate but don't know what to change it to, you can do something like the following: `th main.lua -branch old-exp -expID new-exp-01 -LR 1e-5` and then compare to a separate experiment `th main.lua -branch old-exp -expID new-exp-02 -LR 5e-5`.

In `src/misc` there's a simple script for monitoring a set of experiments to visualize and compare training curves.

#### Getting final predictions ####

To generate final test set predictions for MPII, you can call:

`th main.lua -branch your-exp -expID final-preds -finalPredictions 1 -nEpochs 0`

This assumes there is an experiment that has already been run. If you just want to provide a pre-trained model, that's fine too and you can call:

`th main.lua -expID final-preds -finalPredictions 1 -nEpochs 0 -loadModel /path/to/model`

#### Training accuracy metric ####

For convenience during training, the accuracy function evaluates PCK by comparing the output heatmap of the network to the ground truth heatmap. The normalization in this case will be slightly different than the normalization done when officially evaluating on FLIC or MPII. So there will be some discrepancy between the numbers, but the heatmap-based accuracy still provides a good picture of how well the network is learning during training.

## Final notes ##

In the paper, the training time reported was with an older version of cuDNN, and after switching to cuDNN 4, training time was cut in half. Now, with a Titan X NVIDIA GPU, training time from scratch is under 3 days for MPII, and about 1 day for FLIC.

#### pypose/ ####

Included in this repository is a folder with a bunch of old python code that I used. It hasn't been updated in a while, and might not be totally functional at the moment. There are a number of useful functions for doing evaluation and analysis on pose predictions and it is worth digging into. It will be updated and cleaned up soon.

#### Questions? ####

I am sure there is a lot not covered in the README at the moment so please get in touch if you run into any issues or have any questions!

## Acknowledgements ##

Thanks to Soumith Chintala, this pipeline is largely built on his example ImageNet training code available at:
[https://github.com/soumith/imagenet-multiGPU.torch](https://github.com/soumith/imagenet-multiGPU.torch)

---

## README for Branch `image-play`

This branch (`image-play`), together with [image-play](https://github.com/ywchao/image-play) and [skeleton2d3d](https://github.com/ywchao/skeleton2d3d), hold the code for reproducing the results in the following paper:

**Forecasting Human Dynamics from Static Images**  
Yu-Wei Chao, Jimei Yang, Brian Price, Scott Cohen, Jia Deng  
IEEE Conference on Computer Vision and Pattern Recognition (CVPR), 2017  

Check out the [project site](http://www-personal.umich.edu/~ywchao/image-play/) for more details.

### Role

- The role of this branch is to implement **training step 1** (Sec. 3.3), i.e. pre-training a customized hourglass network for single-image human pose estimation.

- This is later used to initialize the hourglass sub-network in **training step 3** (Sec. 3.3), i.e. training the full system.

### Contents

1. [Downloading pre-computed hourglass models](#downloading-pre-computed-hourglass-models)
2. [Training your own models](#training-your-own-models)
3. [Results](#results)

### Downloading pre-computed hourglass models

If you just want to run the later stages of the pipeline, i.e. [image-play](https://github.com/ywchao/image-play) and [skeleton2d3d](https://github.com/ywchao/skeleton2d3d), you can simply download the pre-computed models (50M) and skip the remaining content.

  ```Shell
  ./scripts/fetch_hg_models.sh
  ./scripts/setup_symlinks_models.sh
  ```

This will populate the `exp` folder with `precomputed_hg_models` and set up a set of symlinks.

### Training your own models

If you do not want to use the pre-computed models, you can train your own. This demo trains a customized hourglass network on MPII and fine-tune it on Penn Action.

1. Install dependencies if you have not:

    - [Torch7](https://github.com/torch/distro)
         - We used [commit a86a090](https://github.com/torch/distro/commit/a86a09071344bcbe6c60a868ebde6a3b264e9efb) (2016-06-04) with CUDA 7.5 and cuDNN v5.0 (cudnn-7.5-linux-x64-v5.0-ga).
         - **Warning:** We observed a performance difference when using different cuDNN versions, e.g. an 8% drop in accuracy on MPII after replacing cuDNN v5.0 with cuDNN v5.1.
         - All our models were trained on a GeForce GTX TITAN X GPU.
    - [torch-hdf5](https://github.com/deepmind/torch-hdf5)
    - [MATLAB](https://www.mathworks.com/products/matlab.html)

2. Remove the symlinks from the previous section, if any:

    ```Shell
    find exp -type l -delete
    ```

3. Download the MPII Human Pose images if you have not:

    ```Shell
    ./scripts/fetch_mpii_images.sh
    ```

    This will populate the `data/mpii` folder with `images`.

4. Train a customized hourglass network on MPII:

    ```Shell
    ./scripts/mpii/run_hg-256.sh $GPU_ID
    ````

    The trained model will be saved in `exp/mpii/hg-256`.

5. Download the [Penn Action dataset](https://upenn.box.com/PennAction) to `external`. `external` should contain `Penn_Action.tar.gz`. Extract the files:

    ```Shell
    tar zxvf external/Penn_Action.tar.gz -C external
    ```

    This will populate the `external` folder with a folder `Penn_Action` with `frames`, `labels`, `tools`, and `README`.

6. Preprocess Penn Action by cropping the images:

    ```Shell
    matlab -r "prepare_penn_crop; quit"
    ```

    This will populate the `external` folder with `Penn_Action_cropped`.

7. Generate validation set and preprocess annotations:

    ```Shell
    matlab -r "generate_valid; quit"
    python tools/convert_annot_penn.py
    ```

    This will populate the `data/penn_action_crop/annot` folder.

8. Create a symlink for the images:

    ```Shell
    ln -s ../../external/Penn_Action_cropped/frames data/penn_action_cropped/images
    ````

9. Fine-tune the hourglass network on Penn Action:

    ```Shell
    ./scripts/penn_action_cropped/run_hg-256-ft.sh $GPU_ID
    ```

    The trained model will be saved in `exp/penn_action_cropped/hg-256-ft`.

10. **Optional:** You can visualize the training loss and accuracy by modifying and running the following MATLAB scripts.

    ```Shell
    tools/compare_acc_mpii.m
    tools/compare_acc_penn.m
    ````

### Results

- For training on MPII (step 4 above), we obtained an 80.58% validation accuracy after 100 epochs.
- For fine-tuning on Penn Action (step 9 above), we obtained a 91.20% validation accuracy and 91.10% test accuracy after 10 epochs. The best model was obtained after 8 epochs (91.52% validation accuracy).
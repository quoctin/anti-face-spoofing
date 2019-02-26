# Implementation of LDP-TOP in face spoofing detection

## Table of Contents

- Introduction
- Usage
- Additional information


### Introduction


This source code provides a simple implementation of LDP-TOP in face spoofing detection.
It is very easy to use and reproduce our work.


### Usage

The three core functions of this implementation

1. ```LDP_TOP_2nd_hist_ff(V, width, height, nframe, Rt, faceloc, from_frame)```

This function returns the 2nd-order LDP-TOP histogram of a video
On Matlab, V = VideoReader(video_path)
Other parameters are described in *LDP_TOP_2nd_hist_ff.m*

2. ```LDP_TOP_3rd_hist_ff(V, width, height, nframe, Rt, faceloc, from_frame)```

This function returns the 3rd-order LDP-TOP histogram of a video
On Matlab, V = VideoReader(video_path)
Other parameters are described in *LDP_TOP_3rd_hist_ff.m*

3. ```LDP_TOP_4th_hist_ff(V, width, height, nframe, Rt, faceloc, from_frame)```

This function returns the 4th-order LDP-TOP histogram of a video
On Matlab, ```V = VideoReader(video_path)```
Other parameters are described in *LDP_TOP_4th_hist_ff.m*

In order to proceed to training and testing step, one must download LibSVM
from [here](https://www.csie.ntu.edu.tw/~cjlin/libsvm/index.html).

To prepare for the training , you must extract labels and features from the training set,
save as a file in which each row corresponds to a video and has the
format: label, 1xd histogram.

To prepare for the testing , you must extract labels and features from the training set,
save as a file in which each row corresponds to a video and has the
format: label, 1xd histogram.

To prepare for the threshold estimating (if you have the development set),
you must extract labels and features from the training set, save as a file in which
each row corresponds to a video and has the format: label, 1xd histogram.

* Copy validation code to LibSVM

- Extract and copy LibSVM to the root folder of this project, name it 'LibSVM'
- Copy *.m from ./LibSVM_matlab to ./LibSVM/matlab/
- Replace ./LibSVM/svm.cpp by ./svm.cpp
- Build LibSVM

Note: *label = 1* for attacks, *-1* for real access. We will reverse these values in our validation code.

* Running with threshold estimation

After having files containing labels and features of training, testing and developing videos, on Matlab

```>> run_with_threshold_estimation (training_file_path, testing_file_path, devel_file_path)```

* Running with 5-fold cross-validation

On Matlab

```>> cross_validation_EER (training_file_path, testing_file_path)```

* Running with cross-database test

On Matlab

```>> cross_database_test (training_file_path_1, testing_file_path_1, training_file_path_2, testing_file_path_2)```

* List of print-attack videos on Idiap REPLAY-ATTACK, CASIA-FASD and MSU MFSD

We have conducted cross-database test on Idiap REPLAY-ATTACK, CASIA-FASD and MSU MFSD by
extracting only print-attack videos. Here are the lists of them. This may be useful if
you want to reproduce our work.

| Dataset | Training | Testing |
| :-------:|:--------:|:-------:|	                    
| REPLAY-ATTACK | *print_replay_attack_train.lst* | *print_replay_attack_test.lst* |
| CASIA-FASD | *print_casia_train.lst* | *print_casia_test.lst* |
| MSU MFSD   | *print_msu_train.lst*   | *print_msu_test.lst* |


## Additional information


This source code is licensed to Quoc-Tin Phan, Duc-Tien Dang-Nguyen and Giulia Boato,
Department of Information Engineering and Computer Science, University of Trento, Italy.


For any question, please contact Quoc-Tin Phan <quoctin.phan@unitn.it>.

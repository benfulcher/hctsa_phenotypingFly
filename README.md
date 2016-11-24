# hctsa_phenotypingFly
Running [hctsa](github.com/benfulcher/hctsa) analysis on movement speed data of fruit flies, *Drosophila melanogaster*, restricted to a one-dimensional tube and tracked continuously for between 3 and 6 days using video tracking.
Data were measured and kindly provided by Quentin Geissmann and Giorgio Gilestro.
Movement speed was estimated as the maximum speed in each non-overlapping 10 s time window, from position measurements measured at approximately 2 Hz, where displacements were measured as the euclidean distance between successive coordinates of the fly.

A summary of key analysis results are [on bioRxiv](http://biorxiv.org/content/early/2016/10/17/081463).

Data are labeled with keywords `M` (male), `F` (female), `day`, and `night`, as well as region numbers, and day numbers (for multi-day experiments).

This repository requires [hctsa](github.com/benfulcher/hctsa) to be installed and paths to this package added (through the `startup.m` script in *hctsa*).
Also requires the data file, `HCTSA.mat`, containing the time-series data and the results of *hctsa* feature extraction.
This file can be downloaded by running `downloadComputedData` (can also be found [on figshare](https://dx.doi.org/10.4225/03/5804798d2a2ec))

A summary of the functions included are below:

* `dayNightAnalysis` contains the main steps for determining movement differences between day and night
* `maleFemaleAnalysis` contains the main steps for distinguishing male from female movement
* `fourWayClass` contains the main steps for four-class classification across: (1) male-day, (2) male-night, (3) female-day, (4) female-night
* `flyClassificationResults` contains the steps for reproducing the classification accuracies of the different classification tasks.
* `reproduceFigures` reproduces the results in the figure of the implementation paper.

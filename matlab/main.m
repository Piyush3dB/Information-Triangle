close all;
clc;
format compact;

here = pwd;
datasets = [here 'datasets'];
plotter  = [here 'ternplot'];
infoTria = [here 'infoTriangle'];

addpath(datasets);
addpath(plotter);
addpath(infoTria);


inCsv = 1;

a=double([
    100     10     00  6
    10    100     80  8
    00     80    100 9
    1 2 3 4
    4 5 8 19]);



disp '== DONE ==';


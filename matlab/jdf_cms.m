close all;
clc;
format compact;
clear;

dbstop if error

here = pwd;

plotter  = fullfile(here, 'ternplot');



addpath(plotter);



inCsv = 1;

tst = [
1 0
0 1

];

tcm = double([
0.95 0.06 0.04 0.00 0.00
0.38 0.24 0.30 0.00 0.00
0.03 0.09 0.45 0.02 0.02
0.03 0.00 1.47 0.76 0.16
0.00 0.00 0.03 0.05 0.57
    ]);

vcm = double([

0.94 0.05 0.04 0.00 0.00
0.47 0.28 0.40 0.01 0.01
0.08 0.28 0.40 0.01 0.01
0.08 0.08 0.40 0.03 0.02
0.02 0.00 1.22 0.68 0.29
0.04 0.01 0.15 0.17 0.44


]);

%
tr = InfoTriangle(tcm); cm = tr;
ternplot(cm.DeltaH_Pxy, cm.twoMI, cm.VI, 'b+');
hold on;

trb = InfoTriangle(diag(sum(tcm,2))); cm = trb;
ternplot(cm.DeltaH_Pxy, cm.twoMI, cm.VI, 'b*');

vd = InfoTriangle(vcm); cm = vd;
ternplot(cm.DeltaH_Pxy, cm.twoMI, cm.VI, 'r+');

vdb = InfoTriangle(diag(sum(vcm,2))); cm = vdb;
ternplot(cm.DeltaH_Pxy, cm.twoMI, cm.VI, 'r*');




ternlabel('Entropy Reduction', 'Mutual Information', 'Variation of Information')
legend('Training - Achieved', 'Training - Best Possible', 'Validation - Achieved', 'Validation - Best Possible')


disp '== DONE ==';


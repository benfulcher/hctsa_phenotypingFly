% flyClassificationResults
% Script to output different classification results quoted in paper.
%-------------------------------------------------------------------------------

normHow = 'zscore'; % 'none', 'scaledRobustSigmoid', 'zscore'
filterProp = [0.5,1];
computePCs = 0;

%-------------------------------------------------------------------------------
% Day/night:
TS_LabelGroups({'day','night'},'raw');
TS_normalize(normHow,filterProp,[],1);
TS_classify('norm','svm_linear',computePCs)

%-------------------------------------------------------------------------------
% Male/female:
TS_LabelGroups({'F','M'},'raw');
TS_normalize(normHow,filterProp,[],1);
TS_classify('norm','svm_linear',computePCs)

%-------------------------------------------------------------------------------
% Combined m/f, day/night:
labelCombination();
TS_normalize(normHow,filterProp,[],1);
TS_classify('norm','svm_linear',computePCs)

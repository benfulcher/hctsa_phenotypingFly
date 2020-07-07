% flyClassificationResults
% Script to output different classification results quoted in paper.
%-------------------------------------------------------------------------------

%-------------------------------------------------------------------------------
% Set parameters:
%-------------------------------------------------------------------------------

% Normalization method
normHow = 'zscore'; % 'none', 'scaledRobustSigmoid', 'zscore'

% How to filter out features:
filterProp = [0.5,1];

% Whether to remove features with no within-class variance
% (causes problems for some classification algorithms):
classVarianceFilter = true;

numNulls = 0;

% What classifier to use:
cfnParams = GiveMeDefaultClassificationParams('raw');
cfnParams.whatClassifier = 'svm_linear';

%-------------------------------------------------------------------------------
% Go through 3 different classification tasks:
%-------------------------------------------------------------------------------

% ------------Day/night:
TS_LabelGroups('raw',{'day','night'});
% Normalize data:
TS_Normalize(normHow,filterProp,[],classVarianceFilter);
% Classify the normalized data:
TS_Classify('norm',cfnParams,numNulls);

% ------------Male/female:
TS_LabelGroups('raw',{'F','M'});
% Normalize data:
TS_Normalize(normHow,filterProp,[],classVarianceFilter);
% Classify the normalized data:
TS_Classify('norm',cfnParams,numNulls);

% ------------% Combined four-class: male/female & day/night:
labelCombination('raw');
% Normalize data:
TS_Normalize(normHow,filterProp,[],classVarianceFilter);
% Classify the normalized data:
TS_Classify('norm',cfnParams,numNulls);

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

% Whether to compare results using all features to results using reduced PCs
numPCs = 0;

% What classifier to use:
whatClassifier = 'svm_linear';

%-------------------------------------------------------------------------------
% Go through 3 different classification tasks:
%-------------------------------------------------------------------------------

for i = 1:3
    switch i
    case 1
        % Day/night:
        TS_LabelGroups('raw',{'day','night'});
    case 2
        % Male/female:
        TS_LabelGroups('raw',{'F','M'});
    case 3
        % Combined four-class: male/female & day/night:
        labelCombination('raw');
    end

    % Normalize data:
    TS_normalize(normHow,filterProp,[],classVarianceFilter);

    % Classify the normalized data:
    TS_classify('norm',whatClassifier,computePCs);

end

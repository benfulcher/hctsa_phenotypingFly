%-------------------------------------------------------------------------------
% ---Day/night analysis
% Runs hctsa to understand differences in fly movement between
% day and night.
%-------------------------------------------------------------------------------
%% Label, normalize, and load data:
% Set how to normalize the data:
whatNormalization = 'mixedSigmoid'; % 'zscore', 'scaledRobustSigmoid'
% Label all time series by either 'day' or 'night':
TS_LabelGroups('raw',{'day','night'});
% Normalize the data, filtering out features with any special values:
TS_Normalize(whatNormalization,[0.5,1],[],true);
% Load data in as a structure:
unnormalizedData = load('HCTSA.mat');
% Load normalized data in a structure:
normalizedData = load('HCTSA_N.mat');
% Set classification parameters:
cfnParams = GiveMeDefaultClassificationParams(unnormalizedData,2);
cfnParams.whatClassifier = 'svm_linear';

%-------------------------------------------------------------------------------
% Optionally cluster and plot a colored data matrix:
doCluster = false
if doCluster
    TS_Cluster();
    % reload with cluster info:
    normalizedData = load('HCTSA_N.mat');
end
TS_PlotDataMatrix(normalizedData,'colorGroups',false)

%-------------------------------------------------------------------------------
%% How accurately can day versus night be classified using all features:
numNulls = 0; % (don't do any comparison to shuffled-label nulls)
TS_Classify(normalizedData,cfnParams,numNulls);

%-------------------------------------------------------------------------------
%% Generate a low-dimensional feature-based representation of the dataset:
numAnnotate = 6; % number of time series to annotate to the plot
whatAlgorithm = 'tSNE';
userSelects = true; % whether the user can click on time series to manually annotate
timeSeriesLength = 600; % length of time-series segments to annotate
annotateParams = struct('n',numAnnotate,'textAnnotation','none',...
                        'userInput',userSelects,'maxL',timeSeriesLength);
TS_PlotLowDim(normalizedData,whatAlgorithm,true,annotateParams,cfnParams);

%-------------------------------------------------------------------------------
%% What individual features best discriminate day from night?
% Uses 'ustat' between day/night as a statistic to score individual features
% Produces 1) a pairwise correlation plot between the top features
%          2) class distributions of the top features, with their stats
%          3) a histogram of the accuracy of all features

numFeatures = 40; % number of features to include in the pairwise correlation plot
numFeaturesDistr = 32; % number of features to show class distributions for
whatStatistic = 'ustat'; % rank-sum test p-value

TS_TopFeatures(normalizedData,whatStatistic,struct(),...
            'numFeatures',numFeatures,...
            'numFeaturesDistr',numFeaturesDistr,...
            'whatPlots',{'histogram','distributions','cluster'});

%-------------------------------------------------------------------------------
%% Investigate particular individual features in some more detail
annotateParams = struct('maxL',4320);
featureID = 1752;
TS_FeatureSummary(featureID,normalizedData,true,annotateParams)
featureID = 1099;
TS_FeatureSummary(featureID,unnormalizedData,true,annotateParams)

%-------------------------------------------------------------------------------
% Four-way classification: male-day/male-night/female-day/female-night
%-------------------------------------------------------------------------------

%-------------------------------------------------------------------------------
%% Label the combination with group labels, normalize, and load in data:
labelCombination();
whatNormalization = 'zscore';
TS_Normalize(whatNormalization,[0.5,1]);
unnormalizedData = load('HCTSA.mat');
normalizedData = load('HCTSA_N.mat');
% Set classification parameters:
cfnParams = GiveMeDefaultClassificationParams(unnormalizedData);
cfnParams.whatClassifier = 'svm_linear';

%-------------------------------------------------------------------------------
%% Plot time series from each class:
numTimeSeriesPerClass = 5;
TS_PlotTimeSeries(unnormalizedData,numTimeSeriesPerClass)

%-------------------------------------------------------------------------------
%% Classify labels using all features:
numNulls = 0; % do permutation-based significance testing
TS_Classify(normalizedData,cfnParams,numNulls);

%-------------------------------------------------------------------------------
%% PCA with annotations:
% *****FIGURE IN PAPER*****
annotateParams = struct('n',0,'textAnnotation','none','userInput',false,'maxL',600);
f = TS_PlotLowDim(normalizedData,'tSNE',false,annotateParams,cfnParams);
f.Position(3:4) = [417,384];

%-------------------------------------------------------------------------------
%% Get some top features:
numFeaturesDistr = 40; % plot class distributions for this many features
doNull = false; % whether to run nulls (slow) to compute statistical significance of individual features
if doNull
    numNulls = 50;
else
    numNulls = 0;
end
cfnParams.whatClassifier = 'fast_linear';
TS_TopFeatures(unnormalizedData,'classification',cfnParams,...
                    'numFeaturesDistr',numFeaturesDistr,...
                    'numNulls',numNulls)

%-------------------------------------------------------------------------------
%% Investigate some top features of interest specifically:
% (features from TS_TopFeatures)
featuresLook = [7051,... % MF_CompareTestSets_y_ar_4_rand_25_01_1_stdrats_median
                3540,... % SB_MotifTwo_mean_duu
                4610,... % SP_Summaries_fft_logdev_area_4_3
                492,... % glscf_1_1_2
                1156]; % noise titration

for i = 1:length(featuresLook)
    TS_SingleFeature(unnormalizedData,featuresLook(i),true,true);
end

%-------------------------------------------------------------------------------
%% Focus in on SY_StdNthDer_1:
featureID = 751;
annotateParams = struct('n',15,'textAnnotation','none','userInput',false,'maxL',4320);
TS_FeatureSummary(featureID,unnormalizedData,true,annotateParams);

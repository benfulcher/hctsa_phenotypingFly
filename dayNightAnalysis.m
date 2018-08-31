%-------------------------------------------------------------------------------
% ---Day/night analysis
% Runs hctsa to understand differences in fly movement between
% day and night.
%-------------------------------------------------------------------------------
%% Label, normalize, and load data:
% Set how to normalize the data:
whatNormalization = 'zscore'; % 'zscore', 'scaledRobustSigmoid'
% Label all time series by either 'day' or 'night':
TS_LabelGroups('raw',{'day','night'});
% Normalize the data, filtering out features with any special values:
TS_normalize(whatNormalization,[0.5,1],[],1);
% Load data in as a structure:
unnormalizedData = load('HCTSA.mat');
% Load normalized data in a structure:
normalizedData = load('HCTSA_N.mat');

%-------------------------------------------------------------------------------
%% How accurately can day versus night be classified using all features:
whatClassifier = 'svm_linear';
TS_classify(normalizedData,whatClassifier,'numPCs',0);

%-------------------------------------------------------------------------------
%% Generate a low-dimensional principal components representation of the dataset:
numAnnotate = 6; % number of time series to annotate to the plot
userSelects = false; % whether the user can click on time series to manually annotate
timeSeriesLength = 600; % length of time-series segments to annotate
annotateParams = struct('n',numAnnotate,'textAnnotation','none',...
                        'userInput',userSelects,'maxL',timeSeriesLength);
TS_plot_pca(normalizedData,true,'',annotateParams)

%-------------------------------------------------------------------------------
%% What individual features best discriminate day from night
% Uses a linear classication accuracy between day/night as a statistic to
% score individual features
% Produces 1) a pairwise correlation plot between the top features
%          2) class distributions of the top features, with their stats
%          3) a histogram of the accuracy of all features

numFeatures = 40; % number of features to include in the pairwise correlation plot
numFeaturesDistr = 32; % number of features to show class distributions for
whatStatistic = 'fast_linear'; % fast linear classification rate statistic

TS_TopFeatures(unnormalizedData,whatStatistic,'numFeatures',numFeatures,...
            'numFeaturesDistr',numFeaturesDistr,...
            'whatPlots',{'histogram','distributions','cluster'});

%-------------------------------------------------------------------------------
%% Investigate particular individual features in some more detail
annotateParams = struct('maxL',4320);
featureID = 1752;
TS_FeatureSummary(featureID,unnormalizedData,true,annotateParams)
featureID = 1099;
TS_FeatureSummary(featureID,unnormalizedData,true,annotateParams)

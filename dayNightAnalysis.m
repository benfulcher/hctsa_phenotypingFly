%-------------------------------------------------------------------------------
% Day/night analysis:
%-------------------------------------------------------------------------------

% How to normalize the data:
normHow = 'zscore'; % 'none', 'scaledRobustSigmoid', 'zscore'

%-------------------------------------------------------------------------------
% Label and load data:
% Label all time series by either 'day' or 'night':
TS_LabelGroups({'day','night'},'raw');
% Normalize the data, filtering out features with any special values:
TS_normalize(normHow,[0.5,1],[],1);
% Load data in as a structure:
dataLoad = load('HCTSA.mat');
% Load normalized data in a structure:
dataLoadNorm = load('HCTSA_N.mat');

%-------------------------------------------------------------------------------
% How accurately can day versus night be classified:
whatClassifier = 'svm_linear';
computePCs = 0;
TS_classify(dataLoadNorm,whatClassifier,computePCs);

%-------------------------------------------------------------------------------
% Check out a low-dimensional principal components representation of the dataset:
annotateParams = struct('n',6,'textAnnotation','none','userInput',0,'maxL',600);
TS_plot_pca(dataLoadNorm,1,'',annotateParams)

%-------------------------------------------------------------------------------
% Look at some single features:
TS_TopFeatures(dataLoad,'fast_linear',0,'numHistogramFeatures',40)

%-------------------------------------------------------------------------------
% Investigate particular individual features:
featureID = 1039;
TS_SingleFeature(dataLoad,featureID,1,1);
set(gcf,'Position',[1000,910,269,167]);
annotateParams.maxL = 4320;
featureID = 6015;
TS_FeatureSummary(featureID,dataLoad,1,annotateParams)
featureID = 45;
TS_FeatureSummary(featureID,dataLoad,1,annotateParams)

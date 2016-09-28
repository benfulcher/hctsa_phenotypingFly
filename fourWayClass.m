%-------------------------------------------------------------------------------
% Four-way classification: M-day/M-night/F-day/F-night
%-------------------------------------------------------------------------------

%-------------------------------------------------------------------------------
% Label the combination with group labels and load in data:
labelCombination();
TS_normalize('zscore',[0.5,1]);
dataLoad = load('HCTSA.mat');
normDataLoad = load('HCTSA_N.mat');

%-------------------------------------------------------------------------------
% Plot time series from each class:
TS_plot_timeseries(dataLoad,5,[],[])

%-------------------------------------------------------------------------------
% Classify labels using all features:
TS_classify(normDataLoad,'svm_linear',0);

%-------------------------------------------------------------------------------
% PCA with annotations:
% *****FIGURE IN PAPER*****
annotateParams = struct('n',0,'textAnnotation','none','userInput',0,'maxL',600);
TS_plot_pca(normDataLoad,0,'svm_linear',annotateParams)
set(gcf,'Position',[491,500,417,384])

%-------------------------------------------------------------------------------
% Get some top features:
doNull = 0;
TS_TopFeatures(dataLoad,'fast_linear',doNull,'numHistogramFeatures',40)

%-------------------------------------------------------------------------------
% Investigate some top features of interest specifically:

featuresLook = [7080,... % MF_CompareTestSets_y_ar_4_rand_25_01_1_stdrats_median
                3533,... % SB_MotifTwo_mean_duu
                4605,... % SP_Summaries_fft_logdev_logarea_4_3
                485,... % glscf_1_1_2
                1294]; % noise titration

for i = 1:length(featuresLook)
    TS_SingleFeature(dataLoad,featuresLook(i),1,1);
end

%-------------------------------------------------------------------------------
% Focus in on SY_StdNthDer_1:
% ******FIGURE IN PAPER******
TS_SingleFeature(dataLoad,744,1,1);

% Inspect in a bit more detail:
annotateParams = struct('n',15,'textAnnotation','none','userInput',0,'maxL',4320);
TS_FeatureSummary(744,dataLoad,1,annotateParams);

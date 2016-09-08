%-------------------------------------------------------------------------------
% four-way classification:
%-------------------------------------------------------------------------------
% Label the combination M/F day/night:
labelCombination();
data = load('HCTSA.mat');
TS_plot_timeseries(data,5,[],[])

%-------------------------------------------------------------------------------
% Classify using all features:
TS_normalize('mixedSigmoid',[0.5,1]);
TS_classify();

%-------------------------------------------------------------------------------
% PCA with annotations:
% *****FIGURE IN PAPER*****
annotateParams = struct('n',0,'textAnnotation','none','userInput',0,'maxL',600);
TS_plot_pca('norm',0,'svm_linear',annotateParams)
set(gcf,'Position',[491   500   417   384])

%-------------------------------------------------------------------------------
% Get some top features:
doNull = 0;
TS_TopFeatures(data,'fast_linear',doNull,'numHistogramFeatures',40)

featuresLook = [7080,... % MF_CompareTestSets_y_ar_4_rand_25_01_1_stdrats_median
                3533,... % SB_MotifTwo_mean_duu
                744,... % SY_StdNthDer_1
                4605,... % SP_Summaries_fft_logdev_logarea_4_3
                485,... % glscf_1_1_2
                1294]; % noise titration
for i = 1:length(featuresLook)
    TS_SingleFeature(data,featuresLook(i),1);
end

%-------------------------------------------------------------------------------
% ******FIGURE IN PAPER******
TS_SingleFeature(data,744,1,1);

%-------------------------------------------------------------------------------
% Inspect individual features:
annotateParams.maxL = 4320;
TS_FeatureSummary(744, data, 1, annotateParams);

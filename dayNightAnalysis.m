%-------------------------------------------------------------------------------
% Day/night analysis:
%-------------------------------------------------------------------------------

%-------------------------------------------------------------------------------
% Label and load data:
TS_LabelGroups({'day','night'},'raw');
data = load('HCTSA.mat');

%-------------------------------------------------------------------------------
normHow = 'zscore'; % 'none', 'scaledRobustSigmoid', 'zscore'
TS_normalize(normHow,[0.5,1],[],1);
TS_classify('norm')
TS_plot_pca
TS_normalize('none',[0.5,1],[],1);


%-------------------------------------------------------------------------------
% Look at some single features:
TS_TopFeatures(data,'fast_linear',0,'numHistogramFeatures',40)
TS_SingleFeature(data,1039,1);
set(gcf,'Position',[1000,910,269,167]);

annotateParams.maxL = 4320;
TS_FeatureSummary(6015, data, 1, annotateParams)
TS_FeatureSummary(45, data, 1, annotateParams)

%-------------------------------------------------------------------------------
% ---Male/female analysis:
% Runs hctsa functions to understand differences in fly movement between
% males and females
%-------------------------------------------------------------------------------

%-------------------------------------------------------------------------------
%% Label groups, normalize, and load data:
% Set how to normalize the data:
whatNormalization = 'scaledRobustSigmoid'; % 'zscore', 'scaledRobustSigmoid'
TS_LabelGroups({'F','M'},'raw');
dataLoad = load('HCTSA.mat');
TS_normalize(whatNormalization,[0.5,1]);
% Load normalized data in a structure:
normalizedData = load('HCTSA_N.mat');

%-------------------------------------------------------------------------------
% Reorder features to sit close:
TS_cluster('none',[],'corr','average');

%-------------------------------------------------------------------------------
% Reorder to ensure male/female sit together:
load('HCTSA_N.mat','ts_clust','TimeSeries','TS_DataMat');
[~,ix] = sort([TimeSeries.Group]);
dataMatReOrd = TS_DataMat(ix,:);
ordering_1 = BF_ClusterReorder([],pdist(dataMatReOrd([TimeSeries(ix).Group]==1,:)),'average');
ordering_2 = BF_ClusterReorder([],pdist(dataMatReOrd([TimeSeries(ix).Group]==2,:)),'average');
is1 = ix([TimeSeries(ix).Group]==1);
ix([TimeSeries(ix).Group]==1) = is1(ordering_1);
is2 = ix([TimeSeries(ix).Group]==2);
ix([TimeSeries(ix).Group]==2) = is2(ordering_2);
ts_clust.ord = ix;
save('HCTSA_N.mat','ts_clust','-append')
dataLoadNorm = load('HCTSA_N.mat');

%-------------------------------------------------------------------------------
% Plot the clustered data matrix:
TS_plot_DataMatrix('cl','colorGroups',1,'addTimeSeries',0)

%-------------------------------------------------------------------------------
% Get overall classification rate:
whatClassifier = 'svm_linear';
computePCs = 0;
TS_classify(dataLoadNorm,whatClassifier,computePCs);

%-------------------------------------------------------------------------------
% Male/female PCA plot:
annotateParams = struct('n',12,'textAnnotation','none','userInput',0,'maxL',600);
TS_plot_pca(dataLoadNorm,1,'',annotateParams)

%-------------------------------------------------------------------------------
% Feature learning:
doNull = 0;
TS_TopFeatures(dataLoad,'fast_linear',doNull,'numFeaturesDistr',40)

%-------------------------------------------------------------------------------
% Plot some of the top features:
annotateParams = struct();
annotateParams.userInput = 0;
annotateParams.n = 11;
annotateParams.maxL = 500;
featIDs = [4522,... % SP_Summaries_fft_logdev_q25
            4393,... % SP_Summaries_welch_rect_w_weighted_peak_prom
            1294,... % CO_AddNoise_1_kraskov1_4_firstUnder25
            6949,... % MF_steps_ahead_ar_best_6_mabserr_6
            3444,... % EX_MovingThreshold_1_01_meankickf
            4602,... % SP_Summaries_fft_logdev_area_4_2
            1720,... % DN_RemovePoints_absfar_08_median
            4310]; % SP_Summaries_pgram_hamm_sfm (spectral flatness measure)

f = figure('color','w');
for i = 1:length(featIDs)
    subplot(ceil(length(featIDs)/3),3,i);
    TS_SingleFeature(data,featIDs(i),1,0);
end

%-------------------------------------------------------------------------------
% Check out he distributional measure:t
annotateParams.maxL = 4320;
TS_FeatureSummary(1720, data, 1, annotateParams); % remove points -- distribution
TS_FeatureSummary(4310, data, 1, annotateParams); % spectral flatness measure

%-------------------------------------------------------------------------------
% Investigate spectral properties further:
% SP_Summaries(y,psdmeth,wmeth,nf,dologabs);

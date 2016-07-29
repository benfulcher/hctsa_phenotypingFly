%-------------------------------------------------------------------------------
% Time series similarity matrix
%-------------------------------------------------------------------------------
TS_normalize('scaledRobustSigmoid',[0.5,1]);
% Pairwise distances:
Dij = TS_PairwiseDist('ts','norm','euclidean');

% Order by individual, which have a unique experiment and ROI ID combination:
load('HCTSA_N.mat','TimeSeries');
[expID,recordingSegment] = getExperimentID(TimeSeries);
[expID,ix] = sort(expID);
recordingSegment = recordingSegment(ix);

% Re-sort by recording segment:
uExpID = unique(expID);
ix2 = 1:length(TimeSeries);
for i = 1:length(uExpID)
    tmp = ix2(expID==i);
    [~,ix_tmp] = sort(recordingSegment(expID==i));
    ix2(expID==i) = tmp(ix_tmp);
end
ixTot = ix(ix2);

Dij = squareform(Dij);
Dij_sorted = Dij(ixTot,ixTot);

unitRescale = @(x) (x-min(x))/(max(x)-min(x));

BF_PlotCorrMat([repmat(unitRescale(expID),1,100)*max(Dij(:)),Dij],'auto',1);

%-------------------------------------------------------------------------------
% Individual classification
%-------------------------------------------------------------------------------
regIDs = TS_LabelGroups({'reg2','reg4','reg6','reg8','reg10','reg11','reg13','reg15','reg17','reg19'},'raw',0)';
load('HCTSA.mat','TimeSeries');
[expIDs,recordingSegment] = getExperimentID(TimeSeries);
combID = 100*expIDs+regIDs; % 14 exps and 10 regs
[~,~,indLabels] = unique(combID);
% Make a cell version of group indices (to use cell2struct)
theGroupsCell = cell(1,length(TimeSeries));
for i = 1:length(theGroupsCell)
    theGroupsCell{i} = indLabels(i);
end
groupNames = cell(max(indLabels),1);
for j = 1:max(indLabels)
    groupNames{j} = num2str(j);
end
LabelBy(theGroupsCell,groupNames,TimeSeries,'HCTSA.mat');
TS_normalize('scaledRobustSigmoid',[0.5,1]);

%-------------------------------------------------------------------------------
% Region classification (individuals?)
%-------------------------------------------------------------------------------
TS_LabelGroups({'reg2','reg4','reg6','reg8','reg10','reg11','reg13','reg15','reg17','reg19'},'raw');
normHow = 'zscore'; % 'none', 'scaledRobustSigmoid', 'zscore'
TS_normalize(normHow,[0.5,1],[],1);
TS_classify('norm')
TS_plot_pca
TS_normalize('none',[0.5,1],[],1);
TS_TopFeatures('norm','fast_linear',doNull,'numHistogramFeatures',40)

%-------------------------------------------------------------------------------
% Day/night analysis:
%-------------------------------------------------------------------------------
TS_LabelGroups({'day','night'},'raw');
normHow = 'zscore'; % 'none', 'scaledRobustSigmoid', 'zscore'
TS_normalize(normHow,[0.5,1],[],1);
TS_classify('norm')
TS_plot_pca
TS_normalize('none',[0.5,1],[],1);
TS_TopFeatures('raw','fast_linear',0,'numHistogramFeatures',40)
TS_SingleFeature('raw',1039,1); set(gcf,'Position',[1000,910,269,167]);


%-------------------------------------------------------------------------------
% Male/Female analysis:
%-------------------------------------------------------------------------------
TS_LabelGroups({'F','M'},'raw');
TS_normalize('scaledRobustSigmoid',[0.5,1]);
TS_cluster('euclidean', 'average', 'corr', 'average');
% Ensure male/female sit together:
load('HCTSA_N.mat', 'ts_clust', 'TimeSeries','TS_DataMat');
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
TS_plot_DataMatrix('cl','colorGroups',1,'addTimeSeries',0)

TS_classify
annotateParams = struct('n',12,'textAnnotation','none','userInput',0,'maxL',600);
TS_plot_pca(normalizedFileName,1,'',annotateParams)
TS_normalize('none',[0.5,1],[],1);
doNull = 0;
TS_TopFeatures('raw','fast_linear',doNull,'numHistogramFeatures',40)
featID = 4292;
TS_SingleFeature('raw',featID);

%-------------------------------------------------------------------------------
% Effect of day number?
%-------------------------------------------------------------------------------
TS_LabelGroups({'day1','day2','day3','day4','day5'},'raw');
TS_normalize('scaledRobustSigmoid',[0.5,1]);
TS_classify
TS_plot_pca
TS_TopFeatures

%-------------------------------------------------------------------------------
% Combined:
%-------------------------------------------------------------------------------
% Label the combination M/F day/night:
labelCombination();
TS_normalize('mixedSigmoid',[0.5,1]);
TS_plot_timeseries('norm',5,[],[])

TS_classify
annotateParams = struct('n',0,'textAnnotation','none','userInput',0,'maxL',600);
TS_plot_pca('norm',0,'svm_linear',annotateParams)
set(gcf,'Position',[491   500   417   384])
doNull = 0;
TS_TopFeatures('raw','fast_linear',doNull,'numHistogramFeatures',40)
TS_SingleFeature('raw',7080,1)
TS_SingleFeature('raw',3533,1)
TS_SingleFeature('raw',744,1)
TS_SingleFeature('raw',4605,1)
TS_SingleFeature('raw',485,1)
TS_SingleFeature('raw',1294,1)

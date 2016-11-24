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
% Classification of region (tube ID) -- shouldn't be much of a signal
%-------------------------------------------------------------------------------
TS_LabelGroups({'reg2','reg4','reg6','reg8','reg10','reg11','reg13','reg15','reg17','reg19'},'raw');
normHow = 'zscore'; % 'none', 'scaledRobustSigmoid', 'zscore'
TS_normalize(normHow,[0.5,1],[],1);
TS_classify('norm')
TS_plot_pca
TS_normalize('none',[0.5,1],[],1);
TS_TopFeatures('norm','fast_linear',doNull,'numFeaturesDistr',40)

%-------------------------------------------------------------------------------
% Effect of day number?
%-------------------------------------------------------------------------------
TS_LabelGroups({'day1','day2','day3','day4','day5'},'raw');
TS_normalize('scaledRobustSigmoid',[0.5,1]);
TS_classify
TS_plot_pca
TS_TopFeatures

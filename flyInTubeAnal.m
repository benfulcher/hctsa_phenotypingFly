%-------------------------------------------------------------------------------
% Time series similarity matrix
%-------------------------------------------------------------------------------
TS_normalize('scaledRobustSigmoid',[0.5,1]);
% Pairwise distances:
Dij = TS_PairwiseDist('ts','norm','euclidean');

% Order by individual:
load('HCTSA_N.mat','TimeSeries');
[expID,recordingSegment] = getExperimentID(TimeSeries);
[expID,ix] = sort(expID);
recordingSegment = recordingSegment(ix);

% Resort by recording segment:
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
TS_TopFeatures('norm','fast_linear',doNull,'numHistogramFeatures',40)

%-------------------------------------------------------------------------------
% Male/Female analysis:
%-------------------------------------------------------------------------------
TS_LabelGroups({'F','M'},'raw');
TS_normalize('scaledRobustSigmoid',[0.5,1]);
TS_classify
annotateParams = struct('n',12,'textAnnotation','none','userInput',0,'maxL',600);
TS_plot_pca(normalizedFileName,1,'',annotateParams)
TS_normalize('none',[0.5,1],[],1);
TS_TopFeatures('norm','fast_linear',doNull,'numHistogramFeatures',40)
featID = 4292;
TS_SingleFeature('norm',featID);

%-------------------------------------------------------------------------------
% Day/night effect?
%-------------------------------------------------------------------------------
TS_LabelGroups({'day1','day2','day3','day4','day5'},'raw');
TS_normalize('scaledRobustSigmoid',[0.5,1]);
TS_classify
TS_plot_pca
TS_TopFeatures

%-------------------------------------------------------------------------------
% Combined:
%-------------------------------------------------------------------------------
theFile = 'HCTSA.mat';
[~,TimeSeries,~,theFile] = TS_LoadData(theFile);
sexGroups = TS_LabelGroups({'M','F'},theFile,0); % Male (1), Female (2)
dayGroups = TS_LabelGroups({'day','night'},theFile,0); % day (1), night(2)

% First append/overwrite group names
groupNames = {'MaleDay','MaleNight','FemaleDay','FemaleNight'}';

groupLabels = cell(4,1);
groupLabels{1} = find(sexGroups==1 & dayGroups==1);
groupLabels{2} = find(sexGroups==1 & dayGroups==2);
groupLabels{3} = find(sexGroups==2 & dayGroups==1);
groupLabels{4} = find(sexGroups==2 & dayGroups==2);

% Make a cell version of group indices (to use cell2struct)
theGroupsCell = cell(1,length(TimeSeries));
for i = 1:length(theGroupsCell)
    theGroupsCell{i} = find(cellfun(@(x)ismember(i,x),groupLabels));
end

LabelBy(theGroupsCell,groupNames,TimeSeries,theFile);
TS_normalize('scaledRobustSigmoid',[0.5,1]);

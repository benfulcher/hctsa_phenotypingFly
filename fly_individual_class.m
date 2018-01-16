%-------------------------------------------------------------------------------
% Ability to distinguish individuals:
%-------------------------------------------------------------------------------
theFile = 'HCTSA.mat';
load(theFile,'TimeSeries');
[expID,recordingSegment] = getExperimentID(TimeSeries);
theGroupsCell = arrayfun(@(x)x,expID,'UniformOutput',0);
groupNames = unique(expID);
groupNames = arrayfun(@(x)num2str(x),groupNames,'UniformOutput',0);
LabelBy(theGroupsCell,groupNames,TimeSeries,theFile);
normalizedFileName = TS_normalize('scaledRobustSigmoid',[0.5,1]);

% Not so much in the PCA
% TS_plot_pca;
TS_classify(normalizedFileName)
TS_normalize('none',[0.5,1],[],1);
numNulls = 0;
TS_TopFeatures('norm','fast_linear','numNulls',numNulls,'numFeaturesDistr',40)

featID = 3789;
TS_SingleFeature('norm',featID);

%-------------------------------------------------------------------------------
% Plot 3 time series from each class
plotOptions = struct();
plotOptions.howToFilter = 'rand';
TS_plot_timeseries('norm',3,[],[],plotOptions)

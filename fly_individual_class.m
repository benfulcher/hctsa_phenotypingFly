%-------------------------------------------------------------------------------
% Ability to distinguish individuals:
%-------------------------------------------------------------------------------
theFile = 'HCTSA.mat';
load(theFile,'TimeSeries');
[expID,recordingSegment] = getExperimentID(TimeSeries);
theGroupsCell = arrayfun(@(x)x,expID,'UniformOutput',false);
groupNames = unique(expID);
groupNames = arrayfun(@(x)num2str(x),groupNames,'UniformOutput',false);
LabelBy(theGroupsCell,groupNames,TimeSeries,theFile);
normalizedFileName = TS_Normalize('scaledRobustSigmoid',[0.5,1]);

% Not so much in the PCA
% TS_PlotLowDim;
TS_Classify(normalizedFileName)
TS_Normalize('none',[0.5,1],[],true);
numNulls = 0;
TS_TopFeatures('norm','fast_linear','numNulls',numNulls,'numFeaturesDistr',40)

featID = 3789;
TS_SingleFeature('norm',featID);

%-------------------------------------------------------------------------------
% Plot 3 time series from each class
plotOptions = struct();
plotOptions.howToFilter = 'rand';
TS_PlotTimeSeries('norm',3,[],[],plotOptions)

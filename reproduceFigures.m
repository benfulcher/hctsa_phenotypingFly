% Reproduce figures in the paper:
% (cf. fourWayClass for related analyses)

%-------------------------------------------------------------------------------
% Label and normalize data
%-------------------------------------------------------------------------------
labelCombination('raw');
TS_normalize('scaledRobustSigmoid',[0.5,1]);

%-------------------------------------------------------------------------------
% Plot 3 time series from each class (for combinations of male/female; day/night)
%-------------------------------------------------------------------------------
plotOptions = struct();
plotOptions.howToFilter = 'rand';
TS_plot_timeseries('norm',3,[],[],plotOptions)

%-------------------------------------------------------------------------------
% Zoom in on a feature of interest (identified using TS_TopFeatures):
%-------------------------------------------------------------------------------
TS_SingleFeature('raw',751,1,1); % SY_StdNthDer_1

%-------------------------------------------------------------------------------
% The PC plot
%-------------------------------------------------------------------------------
annotateParams = struct('n',0,'textAnnotation','none','userInput',0,'maxL',600);
TS_plot_pca('norm',0,'svm_linear',annotateParams)
set(gcf,'Position',[491,500,417,384])

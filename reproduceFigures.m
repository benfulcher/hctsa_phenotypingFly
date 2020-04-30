% Reproduce figures in the Cell Systems paper:

%-------------------------------------------------------------------------------
%% Label and normalize data
% (labeling by the combination of: (1) male-day, (2) male-night,
%                                  (3) female-day, (4) female-night)
%-------------------------------------------------------------------------------
labelCombination('raw');
whatNormalization = 'scaledRobustSigmoid'; % use a sigmoid normalization for features
filterParams = [0.5,1]; % filter out time series < 50% good values; features with < 100% good values
TS_Normalize(whatNormalization,filterParams);

%-------------------------------------------------------------------------------
%% Plot 3 time series from each of the four classes
%-------------------------------------------------------------------------------
numPerClass = 3;
plotOptions = struct('howToFilter','rand'); % select time series to plot from each class at random
TS_PlotTimeseries('raw',numPerClass,[],[],plotOptions);

%-------------------------------------------------------------------------------
%% Zoom in on a feature of interest (identified using TS_TopFeatures):
%-------------------------------------------------------------------------------
featureID = 751; % The feature: SY_StdNthDer_1
TS_SingleFeature('raw',featureID,true,true);

%-------------------------------------------------------------------------------
%% Plot a low-dimensional projection of the dataset:
%-------------------------------------------------------------------------------
numberToAnnotate = 0; % don't annotate any time series to the plot
whatAlgorithm = 'pca'; % 'tSNE'
whatClassifier = 'svm_linear'; % plot classification boundaries in the 2D space
annotateParams = struct('n',numberToAnnotate,'textAnnotation','none',...
                        'userInput',false,'maxL',600);
f = TS_PlotLowDim('norm',whatAlgorithm,false,whatClassifier,annotateParams);
f.Position = [491,500,417,384];

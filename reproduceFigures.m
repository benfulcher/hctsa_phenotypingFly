% Reproduce figures in the paper:

%-------------------------------------------------------------------------------
%% Label and normalize data
% (labeling by the combination of: (1) male-day, (2) male-night,
%                                  (3) female-day, (4) female-night)
%-------------------------------------------------------------------------------
labelCombination('raw');
whatNormalization = 'scaledRobustSigmoid'; % use a sigmoid normalization for features
filterParams = [0.5,1]; % filter out time series < 50% good values; features with < 100% good values
TS_normalize(whatNormalization,[0.5,1]);

%-------------------------------------------------------------------------------
%% Plot 3 time series from each of the four classes
%-------------------------------------------------------------------------------
plotOptions = struct();
plotOptions.howToFilter = 'rand';
TS_plot_timeseries('norm',3,[],[],plotOptions)

%-------------------------------------------------------------------------------
%% Zoom in on a feature of interest (identified using TS_TopFeatures):
%-------------------------------------------------------------------------------
featureID = 751; % The feature: SY_StdNthDer_1
TS_SingleFeature('raw',featureID,1,1);

%-------------------------------------------------------------------------------
%% Plot a principal components projection of the dataset
%-------------------------------------------------------------------------------
numberToAnnotate = 0; % don't annotate any time series to the plot
whatClassifier = 'svm_linear'; % plot classification boundaries in the 2D space
annotateParams = struct('n',numberToAnnotate,'textAnnotation','none',...
                        'userInput',0,'maxL',600);
TS_plot_pca('norm',0,whatClassifier,annotateParams)
f = gcf;
f.Position = [491,500,417,384];

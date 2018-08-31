function labelCombination(theData)
% Labels the combination M-day/M-night/F-day/F-night
%-------------------------------------------------------------------------------

if nargin < 1
    theData = 'HCTSA.mat';
end

%-------------------------------------------------------------------------------
[~,TimeSeries,~,theData] = TS_LoadData(theData);
sexGroups = TS_LabelGroups(theData,{'M','F'},false); % Male (1), Female (2)
dayGroups = TS_LabelGroups(theData,{'day','night'},false); % day (1), night(2)

% First append/overwrite group names
groupNames = {'MaleDay','MaleNight','FemaleDay','FemaleNight'}';

groupLabels = zeros(height(TimeSeries),1);
groupLabels(sexGroups==1 & dayGroups==1) = 1;
groupLabels(sexGroups==1 & dayGroups==2) = 2;
groupLabels(sexGroups==2 & dayGroups==1) = 3;
groupLabels(sexGroups==2 & dayGroups==2) = 4;

LabelBy(groupLabels,groupNames,TimeSeries,theData);

end

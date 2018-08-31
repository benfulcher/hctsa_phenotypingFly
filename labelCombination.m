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

groupLabels = cell(4,1);
groupLabels{1} = find(sexGroups==1 & dayGroups==1);
groupLabels{2} = find(sexGroups==1 & dayGroups==2);
groupLabels{3} = find(sexGroups==2 & dayGroups==1);
groupLabels{4} = find(sexGroups==2 & dayGroups==2);

LabelBy(groupLabels,groupNames,TimeSeries,theData);

end

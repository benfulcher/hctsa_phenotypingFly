function labelCombination(theData)
% Labels the combination M-day/M-night/F-day/F-night
%-------------------------------------------------------------------------------

if nargin < 1
    theData = 'HCTSA.mat';
end

%-------------------------------------------------------------------------------
TimeSeries = TS_GetFromData(theData,'TimeSeries');
sexGroups = TS_LabelGroups(theData,{'M','F'},false);
dayGroups = TS_LabelGroups(theData,{'day','night'},false);

% First append/overwrite group names
groupLabels = cell(height(TimeSeries),1);
groupLabels(sexGroups=='M' & dayGroups=='day') = {'maleDay'};
groupLabels(sexGroups=='M' & dayGroups=='night') = {'maleNight'};
groupLabels(sexGroups=='F' & dayGroups=='day') = {'femaleDay'};
groupLabels(sexGroups=='F' & dayGroups=='night') = {'femaleNight'};
groupLabels = categorical(groupLabels);

% Save everything back to file:
TimeSeries.Group = groupLabels;
save(theData,'TimeSeries','-append')

end

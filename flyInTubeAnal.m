%-------------------------------------------------------------------------------
% Day/night analysis:
%-------------------------------------------------------------------------------
TS_LabelGroups({'day','night'},'raw')
TS_normalize('scaledRobustSigmoid',[0.5,1])
TS_classify
TS_plot_pca
TS_TopFeatures

%-------------------------------------------------------------------------------
% Male/Female analysis:
%-------------------------------------------------------------------------------
TS_LabelGroups({'F','M'},'raw');
TS_normalize('scaledRobustSigmoid',[0.5,1])
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
theGroupsCell = cell(length(TimeSeries),1);
for i = 1:length(theGroupsCell)
    theGroupsCell{i} = find(cellfun(@(x)ismember(i,x),groupLabels));
end

% First remove Group field if it exists
if isfield(TimeSeries,'Group')
    TimeSeries = rmfield(TimeSeries,'Group');
end

% Add new field to the TimeSeries structure array
newFieldNames = fieldnames(TimeSeries);
newFieldNames{length(newFieldNames)+1} = 'Group';

% Then append the new group information:
% (some weird bug -- squeeze is sometimes needed here...:)
TimeSeries = cell2struct([squeeze(struct2cell(TimeSeries));theGroupsCell'],newFieldNames);

% Save everything back to file:
save(theFile,'TimeSeries','groupNames','-append')
fprintf(1,' Saved.\n');

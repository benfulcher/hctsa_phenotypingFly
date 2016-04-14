function [expID,recordingSegment] = getExperimentID(TimeSeries)
% Returns a set of experiment IDs from a set of time series
% Also the recordingSegment (the 12 hour block taken from that experiment)

% First we want the names:
fileNames = {TimeSeries.Name};

% New method: split on the dot:
splitDot = regexp(fileNames,'\.','split');
splitDot_ID = cellfun(@(x)x{1},splitDot,'UniformOutput',0);
[uniqueIDs,~,expID] = unique(splitDot_ID);

keyboard

% Then we want to split on underscore:
splitUnderscore = regexp(fileNames,'_','split');

% Experiment IDs as the first three numbers of third component?:
% splitUnderscore_ID = cellfun(@(x)x{3},splitUnderscore,'UniformOutput',0);
% expID = cellfun(@(x)str2num(x(1:3)),splitUnderscore_ID,'UniformOutput',1);

% recordingSegment as the numbers of final component?:
if nargout > 1
    splitUnderscore_segment = cellfun(@(x)x{5},splitUnderscore,'UniformOutput',0);
    recordingSegment = cellfun(@(x)str2num(x),splitUnderscore_segment,'UniformOutput',1);
end

end

function LabelBy(theGroupsCell,groupNames,TimeSeries,theFile)

if size(theGroupsCell,1)>size(theGroupsCell,2)
   theGroupsCell = theGroupsCell';
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
TimeSeries = cell2struct([squeeze(struct2cell(TimeSeries));theGroupsCell],newFieldNames);

% Save everything back to file:
save(theFile,'TimeSeries','groupNames','-append')
fprintf(1,' Saved.\n');

end

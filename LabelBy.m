function LabelBy(groupLabels,groupNames,TimeSeries,theFile)

% First remove Group field if it exists
if ismember('Group',TimeSeries.Properties.VariableNames)
    TimeSeries(:,'Group') = [];
end
TimeSeries.Group = groupLabels';

% Save everything back to file:
save(theFile,'TimeSeries','groupNames','-append')
fprintf(1,' Saved.\n');

end

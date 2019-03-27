function [timeDayMatrix, totalNanEpochs, totalNanHours]  = convert2Hours(activityThisSubject, timestampsThisSubject)

% timeDayMatrix = convert2Hours(activityThisSubject, timestampsThisSubject)
% 
% Overview
%    Converts activity record into format required by rest-activity
%    functions
%     
% Input
%   activityThisSubject: Acvtivity vector
%   timestampsThisSubject: Time stamps of subject in datetime data type of
%   MATLAB
%
% Output
%    timeDayMatrix: Columns =  unique days 
%                   Rows = Hours from midnight that day to next day
%
% Reference(s)
%   Paquet, Jean, Anna Kawinska, and Julie Carrier. "Wake detection capacity
%   of actigraphy during sleep." Sleep 30.10 (2007): 1362-1369.
% 
% Copyright (C) 2017 Ayse Cakmak <acakmak3@gatech.edu>
% All rights reserved.
%
% This software may be modified & distributed under the terms
% of the BSD license. See LICENSE file in repo for details.
totalNanEpochs = 0; totalNanHours = 0;
% Isolate days in this data
dv = datevec(timestampsThisSubject);
days = dv(:,1:3);
[uniqueDays,~,idxDays] = unique(days,'rows');
uniqueDayCount = size(uniqueDays,1);

% Create time/day matrix
timeDayMatrix = zeros(24,length(uniqueDayCount));
for i=1:uniqueDayCount
    hours = nan(24,1);
    todayData = activityThisSubject(idxDays==i);
    todayHour = dv(idxDays==i,4);
    [uniqueHour,~,idxHour] = unique(todayHour,'rows');
    for j=1:length(uniqueHour)
        hours(uniqueHour(j)+1)=sum(todayData(idxHour==j));
        totalNanEpochs = totalNanEpochs + sum(isnan(todayData(idxHour==j)));
    end
    timeDayMatrix(:,i) = hours;
    totalNanHours = totalNanHours + sum(isnan(hours));
end

end

function timeDayMatrix = convert2Counts(activityThisSubject, timestampsThisSubject)
% 
% Overview
%    A second attempt on creating day-time matrix. If there is activity in
%    a minute, count is increased by one. Hourly counts are stored.
%     
% Input
%   activityThisSubject: Actiwatch activity counts for the subject
%   timestampsThisSubject: Time stamps corresponding to activity coints in
%   serial date number
% 
% Copyright (C) 2017 Ayse Cakmak <acakmak3@gatech.edu>
% All rights reserved.
%
% This software may be modified & distributed under the terms
% of the BSD license. See LICENSE file in repo for details.
% Isolate days in this data

dv = datevec(timestampsThisSubject);
days = dv(:,1:3);
[uniqueDays,~,idxDays] = unique(days,'rows');
uniqueDayCount = size(uniqueDays,1);

% Create time/day matrix
timeDayMatrix = zeros(24,length(uniqueDayCount));
for i=1:uniqueDayCount
    hourlyCount = nan(24,1);
    todayData = activityThisSubject(idxDays==i);
    todayTime = dv(idxDays==i,:);
    todayHour = dv(idxDays==i,4);
    [uniqueHour,~,idxHour] = unique(todayHour);
    for j=1:length(uniqueHour) 
        thisHourMin = todayTime(idxHour==j,5);
        [uniqueMin,~,idxMin] = unique(thisHourMin);
        thisHourData = todayData(idxHour==j);

        count = 0;
        for k=1:length(uniqueMin)
            if sum(thisHourData(idxMin==k)) > 10
                count = count+1;
            end
        end
        hourlyCount(uniqueHour(j)+1) = count;
    end
    
    timeDayMatrix(:,i) = hourlyCount;
end

end

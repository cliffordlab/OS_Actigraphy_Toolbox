function data = preprocessRA(dataMissingHours)

% data = preprocessRA(dataMissingHours)
% 
% Overview
%    Preprocessing step for RA Metrics; if missing hours >4 remove that
%    day,otherwise interpolate
%     
% Input
%    dataMissingHours = Data with missing hours
% 
% Copyright (C) 2017 Ayse Cakmak <acakmak3@gatech.edu>
% All rights reserved.
%
% This software may be modified and distributed under the terms
% of the BSD license.  See the LICENSE file in this repo for details.

% Remove days that have too much missing data
j = 1;
data = [];
for iDay = 1:size(dataMissingHours,2)
    if sum(isnan(dataMissingHours(:,iDay)))<5
       data(:,j) = dataMissingHours(:,iDay);
       j = j + 1;
    end
end

if isempty(data)
    return;
end

% Interpolate the rest
data = fillmissing(data,'pchip');
data(data < 0) = 0; % Activity counts cannot be <0

end
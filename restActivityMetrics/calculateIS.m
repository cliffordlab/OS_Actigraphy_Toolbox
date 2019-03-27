function is = calculateIS(data)

% is = calculateInterdayStability(data)
% 
% Overview
%   Calculate interday stability
%     
% Input
%   data [matrix] - time series data in format specified by convert2hours.m
%
% Output
%	is [double]
%
% Reference(s)
%   https://github.com/cliffordlab/activityToolbox#references 
%
% Copyright (C) 2017 Ayse Cakmak <acakmak3@gatech.edu>
% All rights reserved.
%
% This software may be modified and distributed under the terms
% of the BSD license. See the LICENSE file in this repo for details.

dataVec = data(:);

% Calculate grand mean
xGrandMean = mean(dataVec);

n = length(dataVec);
p = 24;

% Calculate hourly means
xHourly = mean(data,2);

% Calculate interday stability, ignoring NaNs
isNumerator = n * sum((xHourly - xGrandMean).^2);
isDenominator = p * sum((dataVec - xGrandMean).^2);
is = isNumerator / isDenominator;

end 
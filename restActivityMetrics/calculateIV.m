function iv = calculateIV(data)

% iv = calculateIntradayVariability(data)
% 
% Overview
%   Calculate intraday variability
%     
% Input
%   data [matrix] - time series data in format specified by convert2hours.m
%
% Output
%	iv [double]
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
x_bar = mean(dataVec);

n = length(dataVec);

% Calculate intraday variability
iv_numerator = n * sum((dataVec(2:n) - dataVec(1:n-1)).^2);
iv_denominator = (n - 1) * sum((dataVec - x_bar).^2);
iv = iv_numerator / iv_denominator;

end 
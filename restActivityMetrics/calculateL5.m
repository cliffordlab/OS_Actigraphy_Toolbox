function l5 = calculateL5(data)
% 
% Overview
%   Calculate levels during least active 5 hours.
%     
% Input
%   data [matrix] - time series data in format specified by convert2hours.m
%
% Output
%	l5 [double]
%
% Copyright (C) 2017 Ayse Cakmak <acakmak3@gatech.edu>
% All rights reserved.
%
% This software may be modified and distributed under the terms
% of the BSD license. See the LICENSE file in this repo for details.

xHourly = mean(data,2);

xHourly = sort(xHourly,'ascend'); % Sort hours in ascending order

l5 = mean(xHourly(1:5));

end 

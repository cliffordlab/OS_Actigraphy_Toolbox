function m10 = calculateM10(data)
% 
% Overview
%   Calculate levels during most active 10 hours.
%     
% Input
%   data [matrix] - time series data in format specified by convert2hours.m
%
% Output
%	m10 [double] 
%
% Copyright (C) 2017 Ayse Cakmak <acakmak3@gatech.edu>
% All rights reserved.
%
% This software may be modified and distributed under the terms
% of the BSD license. See the LICENSE file in this repo for details.

xHourly = mean(data,2);

xHourly = sort(xHourly,'descend'); % Sort hours in descending order

m10 = mean(xHourly(1:10));

end 
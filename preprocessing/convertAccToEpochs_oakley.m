function epochCount = convertAccToEpochs_oakley(acc, time, epochLength)
% 
% Overview
%   Converts raw accelerometer signal into activity counts - Oakley method
%     
% Input
%   acc: 1D raw accelerometer signal, z axis
%   time: Recording time of acc signal (seconds elapsed from beginning)
%   epochLength: Desired length for epochs (seconds)
%
% Reference(s)
%   [1] Borazio, Marko, et al. "Towards benchmarked sleep detection with 
%   wrist-worn sensing units." Healthcare Informatics (ICHI), 2014 IEEE 
%   International Conference on. IEEE, 2014.
%
%   [2] https://actigraph.desk.com/customer/en/portal/articles/2515508-actigraph-data-conversion-process
%
% Authors
%   Ayse Cakmak <acakmak3@gatech.edu>
%   Qiao Li <qiaolibme@gmail.com>
% 
% Copyright (C) 2017 Authors, all rights reserved.
%
% This software may be modified and distributed under the terms
% of the BSD license. See the LICENSE file in this repo for details.

% Band pass butterworth filter (0.25Hz to 2.5Hz)
acc = accBPFilter_clifford_30Hz(acc); % This filter is for Fs = 30Hz;

% Determine the maximum absolute value inside 1-second windows
iEpoch = 1;
epochStart = 0;
epochLength1 = 1;

fstart=1; % start index for find()
ftemp=find(time==0); % the index for time == 0
if ~isempty(ftemp)
    fstart=ftemp(1); % set fstart as the index where time == 0 if exist
end
fseg=epochLength*3; % set a 3 * epochLength buffer for find()
fend=length(time);

while epochStart <= time(end)
    
    if (epochStart + epochLength1) <= time(end)
        epochEnd = epochStart + epochLength1;
    else
        epochEnd = time(end);
    end
    
    % Find data inside this epoch    
    dataIdx=fstart+find(time(fstart:min(fstart+fseg,fend))>=epochStart &time(fstart:min(fstart+fseg,fend))<= epochEnd)-1;
    if ~isempty(dataIdx)
        fstart=dataIdx(1);
    end
    
    % Calculate max absolute acc in current window
    if ~isempty(dataIdx)
        accEpoch = max(abs(acc(dataIdx)));          
        epochCount1(iEpoch) = accEpoch;
    else
        epochCount1(iEpoch) = nan;
    end
    
    epochStart = iEpoch * epochLength1;   
    iEpoch = iEpoch + 1;
end
time1 = 1:1:length(epochCount1);

% Sum data in epochs and output epoch counts
iEpoch = 1;
epochStart = 0;
while epochStart <= time1(end)   
        
    if (epochStart + epochLength) <= time1(end)
        epochEnd = epochStart + epochLength;
    else
        epochEnd = time1(end);
    end
    
    % Find data inside this epoch
    dataIdx = time1 >=epochStart & time1 <=epochEnd;
    accEpoch = epochCount1(dataIdx);
    
    if isempty(dataIdx)
        stop = 1;
    end
    
    % Sum data in this epoch and scale according to parameters in reference
    epochCount(iEpoch) = sum(accEpoch) * 66 - 3.3;
    
    epochStart = iEpoch * epochLength;   
    iEpoch = iEpoch + 1;
end

end
function epochCount = convertAccToEpochs_cole(acc, time, epochLength)
% 
% Overview
%   Converts raw accelerometer signal into activity counts using zero crossing
%   - Cole method
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
% Authors
%   Ayse Cakmak <acakmak3@gatech.edu>
% 
% Copyright (C) 2017 Authors, all rights reserved.
%
% This software may be modified and distributed under the terms
% of the BSD license. See the LICENSE file in this repo for details.

% Band pass filter (0.25Hz to 3Hz)
acc = accBPFilter_virkkala(acc); % This filter is for Fs = 30Hz;

% Determine the maximum absolute value inside 1-second windows
iEpoch = 1;
epochStart = 0;
epochLength1 = 1;
while epochStart <= time(end)   
        
    if (epochStart + epochLength1) <= time(end)
        epochEnd = epochStart + epochLength1;
    else
        epochEnd = time(end);
    end
    
    % Find data inside this epoch
    dataIdx = find(time >=epochStart & time <=epochEnd);
    
    % Use zero crossing method to find activity counts
    data = acc(dataIdx);
    zc = 0;
    for i = 2:length(data)
        if sign(data(i)) ~= sign(data(i-1))
            zc = zc + 1;
        end
    end
    epochCount1(iEpoch) = zc;
    
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
    
    % Sum data in this epoch 
    epochCount(iEpoch) = sum(accEpoch);
    
    epochStart = iEpoch * epochLength;   
    iEpoch = iEpoch + 1;
end

end
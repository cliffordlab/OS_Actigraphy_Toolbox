function IO = dichotomyIndex(subject)
%
% Overview
%     
% Input
%   subject: Struct that contains data for all subjects. Has field
%   activity. Activity should be in 30 second epoch format.
%
% Output
%   IO: Dichotomy index
%
% Reference(s)
%   Mormont, M.C., Waterhouse, J., Bleuzen, P., Giacchetti, S., Jami, A., 
%   Bogdan, A., Lellouch, J., Misset, J.L., Touitou, Y. and Lévi, F., 2000. 
%   Marked 24-h rest/activity rhythms are associated with better quality of 
%   life, better response, and longer survival in patients with metastatic 
%   colorectal cancer and good performance status. Clinical Cancer Research, 
%   6(8), pp.3038-3045.
%
% Authors
%   Ayse Cakmak <acakmak3@gatech.edu>
% 
% Copyright (C) 2018 Authors, all rights reserved.
%
% This software may be modified and distributed under the terms
% of the BSD license. See the LICENSE file in this repo for details.
%

for i = 1:length(subject)
    inBedIdx = [];
    days = subject(i).time;
    activity = subject(i).activity;
    tInBed = subject(i).tInBed;
    tOutBed = subject(i).tOutBed;
    
    for day = 1:length(tInBed)           
        timeStart = tInBed(day);
        timeEnd = tOutBed(day);  

        inBedIdx = [inBedIdx; find(days >= timeStart & days <= timeEnd)];
    end

    inBed = activity(inBedIdx);
    outBed = activity;
    outBed(inBedIdx) = [];
    %mOutBed = nanmedian(outBed); % Does not work with Emory PTSD data
    mOutBed = nanmean(outBed);
    IO(i,1) = length(find(inBed < mOutBed)) / length(inBed);
end

end
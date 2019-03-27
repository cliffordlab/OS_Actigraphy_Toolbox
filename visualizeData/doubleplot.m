function timeDay = doubleplot(accZAll, accSec, accStart, binSize, sleepWake, titleText, plotThis)
% 
% Overview
%   Plots accelerometer files over a range of days in color plots.
%   Shows sleep sections with letter 'S'
%   Shows missing data with 'NaN' letters
%     
% Input
%   accZAll: Z axis of accelerometer file, cell array. Each cell should be
%   accelerometer data from one day.
%   accSec: Second ellapsed since the start of accelerometer recording,
%   cell array. Each cell should belong to a different day.
%   accStart: Start of record, in matlab time number
%   binSize: Length of each bin (in hours)
%   sleepWake: Sleep-Wake vector. Subject is decided to be asleep or wake
%   by looking at accelerometer data. Initially epoch lengths are set to be
%   30 sec in this function, fix if needed. You can use detectSleep_oakley
%   function from repo to decide on sleep stages.
%
% Output 
%   Returns double plot actigraphy and timeday matrix for various
%   calculations
%
% Dependencies
%   https://github.com/cliffordlab/actigraphyToolbox
%
% Authors
%   Ayse Cakmak <acakmak3@gatech.edu>
%   Gari Clifford
% 
% Copyright (C) 2017 Authors, all rights reserved.
%
% This software may be modified and distributed under the terms
% of the BSD license. See the LICENSE file in this repo for details.
%

if ~isempty(sleepWake)
    sleep = 1; % Indicate detected sleep sections on plot
else
    sleep = 0;
end

binSizeSec = binSize * 3600;

% How many bins in one day
binsPerDay = 24 / binSize;

% Calculate what bin in a day accStart correspond to
[~,~,~,H,M,~] = datevec(accStart);
hourStart = H + M/60;
startBin = ceil(hourStart / 24 * binsPerDay);
if startBin == 0
    startBin = 1;
end

% Fill bins
bins = nan(binsPerDay,size(accSec,2));
for iDay = 1:size(accSec,2)
    time = accSec{iDay};
    acc = accZAll{iDay};
    
    for iBin = 1:binsPerDay
       binStart = (iBin - 1) * binSizeSec;
       binEnd = binStart + binSizeSec;

       accIdxBin = find(time >= binStart & time <= binEnd);
       if ~isempty(accIdxBin)
           s = nansum(abs(acc(accIdxBin)));
           s(s > 10 * 30000) = 10 * 30000;
           
           bins(iBin,iDay) = s; 
       end
    end
end

% Fix first day using starting time
firstDay = bins(:,1);
bins(:,1) = nan(binsPerDay,1);
bins(startBin:end,1) = firstDay(1:binsPerDay - startBin + 1);

% Make matrix
matrix1 = bins(:,1:end-1);
matrix2 = bins(:,2:end);
timeDay = [matrix1; matrix2];

% Do the same for sleep data if given by user
if sleep ~= 0
    bins_sleep = nan(binsPerDay,size(accSec,2));
    for iDay = 1:size(accSec,2)
        ss = sleepWake{iDay};
        tSleep = 0:30:(length(ss)-1)*30;
        
        % Fill bins
        for iBin = 1:binsPerDay
           binStart = (iBin - 1) * binSizeSec;
           binEnd = binStart + binSizeSec;

           accIdxBin = find(tSleep >= binStart & tSleep <= binEnd);

           if ~isempty(accIdxBin)
               seg = ss(accIdxBin);
               % If more than 80% are marked as sleep
               if length(find(seg == 0)) > round(length(seg) * 0.8) 
                   bins_sleep(iBin,iDay) = 1; 
               else
                   bins_sleep(iBin,iDay) = 0;
               end
           else
               bins_sleep(iBin,iDay) = 0;
           end
        end
    end
    
    firstDay = bins_sleep(:,1);
    bins_sleep(:,1) = nan(binsPerDay,1);
    bins_sleep(startBin:end,1) = firstDay(1:binsPerDay - startBin + 1);

    % Make sleep matrix
    matrix1 = bins_sleep(:,1:end-1);
    matrix2 = bins_sleep(:,2:end);
    timeDay_sleep = [matrix1; matrix2];
end  
    
% Plot doubleplot
if plotThis == 1
    %figure('Position', [10 10 1000 400]);

    colormap('hot');
    b = imagesc(timeDay);
    c = colorbar;
    c.Ticks = [87.112, 300000.0];
    c.TickLabels = ({'Low Act.','High Act.'});
    xlabel('Time(days)');
    ylabel(['Time bins (' num2str(binSize) ' hour)']);
    yticks(0:6:48)
    yticklabels([0:6:24 6:6:24])
    [~,c] = find(isnan(timeDay)) ;
    hold on ; 
    set(b,'AlphaData',~isnan(timeDay));
    set(gcf,'color','w');
    set(gca,'FontSize',18)
    colorbar off;
    title(titleText)
    %tightfig;

    % Indicate nans on plot
    for ii = 1:length(c)
        %text(c(ii),r(ii),'NaN','Color','r', 'FontSize', 7, 'HorizontalAlignment','center');
    end

    % Indicate sleep bins on plot
    if sleep ~= 0
        [r,c] = find(timeDay_sleep == 1) ;
        hold on ; 
        for ii = 1:length(c)
            text(c(ii),r(ii),'S','Color','b', 'FontSize', 7, 'HorizontalAlignment','center');
        end
    end
end

end
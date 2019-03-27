% testMissingData
% 
% Overview
%   Tests to find optimal solution for missing hours in activity data
%   method 1: Remove days that have missing data
%   method 2: Interpolate missing data
%   Result: Interpolate if missing data per day is <= 4 hours, otherwise
%   remove the day
%
% Dependencies
%    https://github.com/cliffordlab/dmd
%
% Copyright (C) 2017 Ayse Cakmak <acakmak3@gatech.edu>
% All rights reserved.
%
% This software may be modified & distributed under the terms
% of the BSD license. See LICENSE file in repo for details.

hold off; close all; 

%% Use DMD Study data
pathToData = '/Users/ayse/box/Phan_Duchenne_Activity_Study/data/';
[activityAll, activityID] = getActivity(pathToData);
timeDayMatrix = getTDM(activityAll);
cd('~/repos/');

%% Scenario 1: For each record remove hours from one day one by one and 
%try performance of methods
for iSubject = 1:length(timeDayMatrix)
    
    % Obtain days with no-missing data and remove small records    
    k = 1;
    clear data;
    for j=1:size(timeDayMatrix{iSubject},2)
        if sum(isnan(timeDayMatrix{iSubject}(:,j))) == 0
            data(:,k) = timeDayMatrix{iSubject}(:,j);
            k = k + 1;
        end
    end
    
    if size(data,2) < 6
        continue;
    end
    
    DaysLeft(iSubject) = size(data,2);
        
    % Calculate true rest-activity statistics
    is_true = calculateIS(data);
    iv_true = calculateIV(data);
    l5_true = calculateL5(data);
    m10_true = calculateM10(data);
    
    % Method 1: Remove day with missing hours
    data1 = data;
    data1(:,2) = [];
    is_m1_error(iSubject) = abs(calculateIS(data1)-is_true)/is_true;
    iv_m1_error(iSubject) = abs(calculateIV(data1)-iv_true)/iv_true;
    l5_m1_error(iSubject) = abs(calculateL5(data1)-l5_true)/l5_true;
    m10_m1_error(iSubject) = abs(calculateM10(data1)-m10_true)/m10_true; 

    % Remove hours from second day and record percent error
    for missingHour = 1:12
        data(1:missingHour,2) = nan;
        
        % Method 2: Interpolate through missing hours  
        data2 = fillmissing(data,'pchip');
        data2(data2 < 0) = 0; % Activity counts cannot be negative 
        is_m2_error(missingHour,iSubject) = abs(calculateIS(data2)-is_true)/is_true;
        iv_m2_error(missingHour,iSubject) = abs(calculateIV(data2)-iv_true)/iv_true;
        l5_m2_error(missingHour,iSubject) = abs(calculateL5(data2)-l5_true)/l5_true;
        m10_m2_error(missingHour,iSubject) = abs(calculateM10(data2)-m10_true)/m10_true; 

    end

end

is_m1_error = mean(is_m1_error);
iv_m1_error = mean(iv_m1_error);
l5_m1_error = mean(l5_m1_error);
m10_m1_error = mean(m10_m1_error);

is_m2_error = mean(is_m2_error,2);
iv_m2_error = mean(iv_m2_error,2);
l5_m2_error = mean(l5_m2_error,2);
m10_m2_error = mean(m10_m2_error,2);

% Plot results 
subplot(3,4,1)
plot(1:12,is_m2_error,'color',[0.7216 0.2510 0.4118],'linewidth',2);
hold on;
plot(1:12,repmat(is_m1_error,12,1),'color',[0.4784 0.6784 0.9412],'linewidth',2);
xlim([1 12]);
legend({'Interpolate','Remove Days'},'Location','best');
title('Case 1 IS Metric');
xlabel('Hours'); 
ylabel('Average Percent Error')

subplot(3,4,2)
plot(1:12,iv_m2_error,'color',[0.7216 0.2510 0.4118],'linewidth',2);
hold on;
plot(1:12,repmat(iv_m1_error,12,1),'color',[0.4784 0.6784 0.9412],'linewidth',2);
xlim([1 12]);
legend({'Interpolate','Remove Days'},'Location','best');
title('Case 1 IV Metric');
xlabel('Hours'); 
ylabel('Average Percent Error') 
   
subplot(3,4,3)
plot(1:12,m10_m2_error,'color',[0.7216 0.2510 0.4118],'linewidth',2);
hold on;
plot(1:12,repmat(m10_m1_error,12,1),'color',[0.4784 0.6784 0.9412],'linewidth',2);
xlim([1 12]);
legend({'Interpolate','Remove Days'},'Location','best');
title('Case 1 M10 Metric');
xlabel('Hours'); 
ylabel('Average Percent Error')

subplot(3,4,4)
plot(1:12,l5_m2_error,'color',[0.7216 0.2510 0.4118],'linewidth',2);
hold on;
plot(1:12,repmat(l5_m1_error,12,1),'color',[0.4784 0.6784 0.9412],'linewidth',2);
xlim([1 12]);
legend({'Interpolate','Remove Days'},'Location','best');
title('Case 1 L5 Metric');
xlabel('Hours'); 
ylabel('Average Percent Error')

%% Scenario 2: For each record remove hours from day 2 one by one 
% while there is already missing 6 hours on day 3
for iSubject = 1:length(timeDayMatrix)
    
    % Obtain days with no-missing data and remove small records    
    k = 1;
    clear data;
    for j=1:size(timeDayMatrix{iSubject},2)
        if sum(isnan(timeDayMatrix{iSubject}(:,j))) == 0
            data(:,k) = timeDayMatrix{iSubject}(:,j);
            k = k + 1;
        end
    end
    
    if size(data,2) < 6
        continue;
    end
        
    % Calculate true rest-activity statistics
    is_true = calculateIS(data);
    iv_true = calculateIV(data);
    l5_true = calculateL5(data);
    m10_true = calculateM10(data);
    
    % Method 1: Remove day2 with missing hours
    data1 = data;
    data1(:,2:3) = [];
    is_m1_error(iSubject) = abs(calculateIS(data1)-is_true)/is_true;
    iv_m1_error(iSubject) = abs(calculateIV(data1)-iv_true)/iv_true;
    l5_m1_error(iSubject) = abs(calculateL5(data1)-l5_true)/l5_true;
    m10_m1_error(iSubject) = abs(calculateM10(data1)-m10_true)/m10_true; 

    % Remove hours from second day and record percent error
    for missingHour = 1:12
        data(1:missingHour,2) = nan;
        data(8:14,3) = nan;
        
        % Method 2: Interpolate through missing hours  
        data2 = fillmissing(data,'pchip');
        data2(data2 < 0) = 0; % Activity counts cannot be negative 
        is_m2_error(missingHour,iSubject) = abs(calculateIS(data2)-is_true)/is_true;
        iv_m2_error(missingHour,iSubject) = abs(calculateIV(data2)-iv_true)/iv_true;
        l5_m2_error(missingHour,iSubject) = abs(calculateL5(data2)-l5_true)/l5_true;
        m10_m2_error(missingHour,iSubject) = abs(calculateM10(data2)-m10_true)/m10_true; 

    end

end

is_m1_error = mean(is_m1_error);
iv_m1_error = mean(iv_m1_error);
l5_m1_error = mean(l5_m1_error);
m10_m1_error = mean(m10_m1_error);

is_m2_error = mean(is_m2_error,2);
iv_m2_error = mean(iv_m2_error,2);
l5_m2_error = mean(l5_m2_error,2);
m10_m2_error = mean(m10_m2_error,2);

% Plot results 
subplot(3,4,5)
plot(1:12,is_m2_error,'color',[0.7216 0.2510 0.4118],'linewidth',2);
hold on;
plot(1:12,repmat(is_m1_error,12,1),'color',[0.4784 0.6784 0.9412],'linewidth',2);
xlim([1 12]);
legend({'Interpolate','Remove Days'},'Location','best');
title('Case 2 IS Metric');
xlabel('Hours'); 
ylabel('Average Percent Error')

subplot(3,4,6)
plot(1:12,iv_m2_error,'color',[0.7216 0.2510 0.4118],'linewidth',2);
hold on;
plot(1:12,repmat(iv_m1_error,12,1),'color',[0.4784 0.6784 0.9412],'linewidth',2);
xlim([1 12]);
legend({'Interpolate','Remove Days'},'Location','best');
title('Case 2 IV Metric');
xlabel('Hours'); 
ylabel('Average Percent Error') 
   
subplot(3,4,7)
plot(1:12,m10_m2_error,'color',[0.7216 0.2510 0.4118],'linewidth',2);
hold on;
plot(1:12,repmat(m10_m1_error,12,1),'color',[0.4784 0.6784 0.9412],'linewidth',2);
xlim([1 12]);
legend({'Interpolate','Remove Days'},'Location','best');
title('Case 2 M10 Metric');
xlabel('Hours'); 
ylabel('Average Percent Error')

subplot(3,4,8)
plot(1:12,l5_m2_error,'color',[0.7216 0.2510 0.4118],'linewidth',2);
hold on;
plot(1:12,repmat(l5_m1_error,12,1),'color',[0.4784 0.6784 0.9412],'linewidth',2);
xlim([1 12]);
legend({'Interpolate','Remove Days'},'Location','best');
title('Case 2 L5 Metric');
xlabel('Hours'); 
ylabel('Average Percent Error')
   
%% Scenario 3: For each record remove hours from day 2 one by one while
% there is already missing 6 hours on day 3 and missing 2 hours on day 4
for iSubject = 1:length(timeDayMatrix)
    
    % Obtain days with no-missing data and remove small records    
    k = 1;
    clear data;
    for j=1:size(timeDayMatrix{iSubject},2)
        if sum(isnan(timeDayMatrix{iSubject}(:,j))) == 0
            data(:,k) = timeDayMatrix{iSubject}(:,j);
            k = k + 1;
        end
    end
    
    if size(data,2) < 6
        continue;
    end
        
    % Calculate true rest-activity statistics
    is_true = calculateIS(data);
    iv_true = calculateIV(data);
    l5_true = calculateL5(data);
    m10_true = calculateM10(data);
    
    % Method 1: Remove day2 with missing hours
    data1 = data;
    data1(:,2:4) = [];

    is_m1_error(iSubject) = abs(calculateIS(data1)-is_true)/is_true;
    iv_m1_error(iSubject) = abs(calculateIV(data1)-iv_true)/iv_true;
    l5_m1_error(iSubject) = abs(calculateL5(data1)-l5_true)/l5_true;
    m10_m1_error(iSubject) = abs(calculateM10(data1)-m10_true)/m10_true; 

    % Remove hours from second day and record percent error
    for missingHour = 1:12
        data(1:missingHour,2) = nan;
        data(8:14,3) = nan;
        data(1:2,4) = nan;
        
        % Method 2: Interpolate through missing hours  
        data2 = fillmissing(data,'pchip');
        data2(data2 < 0) = 0; % Activity counts cannot be negative 
        is_m2_error(missingHour,iSubject) = abs(calculateIS(data2)-is_true)/is_true;
        iv_m2_error(missingHour,iSubject) = abs(calculateIV(data2)-iv_true)/iv_true;
        l5_m2_error(missingHour,iSubject) = abs(calculateL5(data2)-l5_true)/l5_true;
        m10_m2_error(missingHour,iSubject) = abs(calculateM10(data2)-m10_true)/m10_true; 

    end

end

is_m1_error = mean(is_m1_error);
iv_m1_error = mean(iv_m1_error);
l5_m1_error = mean(l5_m1_error);
m10_m1_error = mean(m10_m1_error);

is_m2_error = mean(is_m2_error,2);
iv_m2_error = mean(iv_m2_error,2);
l5_m2_error = mean(l5_m2_error,2);
m10_m2_error = mean(m10_m2_error,2);

% Plot results 
subplot(3,4,9)
plot(1:12,is_m2_error,'color',[0.7216 0.2510 0.4118],'linewidth',2);
hold on;
plot(1:12,repmat(is_m1_error,12,1),'color',[0.4784 0.6784 0.9412],'linewidth',2);
xlim([1 12]);
legend({'Interpolate','Remove Days'},'Location','best');
title(' Case 3 IS Metric');
xlabel('Hours'); 
ylabel('Average Percent Error')

subplot(3,4,10)
plot(1:12,iv_m2_error,'color',[0.7216 0.2510 0.4118],'linewidth',2);
hold on;
plot(1:12,repmat(iv_m1_error,12,1),'color',[0.4784 0.6784 0.9412],'linewidth',2);
xlim([1 12]);
legend({'Interpolate','Remove Days'},'Location','best');
title('Case 3 IV Metric');
xlabel('Hours'); 
ylabel('Average Percent Error') 
   
subplot(3,4,11)
plot(1:12,m10_m2_error,'color',[0.7216 0.2510 0.4118],'linewidth',2);
hold on;
plot(1:12,repmat(m10_m1_error,12,1),'color',[0.4784 0.6784 0.9412],'linewidth',2);
xlim([1 12]);
legend({'Interpolate','Remove Days'},'Location','best');
title('Case 3 M10 Metric');
xlabel('Hours'); 
ylabel('Average Percent Error')

subplot(3,4,12)
plot(1:12,l5_m2_error,'color',[0.7216 0.2510 0.4118],'linewidth',2);
hold on;
plot(1:12,repmat(l5_m1_error,12,1),'color',[0.4784 0.6784 0.9412],'linewidth',2);
xlim([1 12]);
legend({'Interpolate','Remove Days'},'Location','best');
title('Case 3 L5 Metric');
xlabel('Hours'); 
ylabel('Average Percent Error')
   
tightfig;



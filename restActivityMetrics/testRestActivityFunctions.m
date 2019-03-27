function testRestActivityFunctions()

clc; close all;

% Set number of days
numDays = 7;

% Load google colors
gcl = loadGoogleColors();

% Generate Gaussian noise
gaussiannoise = randn(24 * numDays, 1);

% Generate data with the same pattern every day
regularOneDay = randi([1 5], 24, 1);
regularWeek = repmat(regularOneDay, numDays, 1);

% Plot the data

% Subplot Gaussian noise
figure('position', [0 0 1200 500]);
subplot(2,1,1);
plot(gaussiannoise, '.--', 'markersize', 20, ...
    'color', gcl.blue, 'linewidth', 2);

title({'Gaussian noise'})
legend boxoff;
box off;

ylabel('Amplitude');

xticks([0:6:numDays*24]);
xlim([1 numDays*24]);
xlabel('Hours from start');
set(gca, 'fontsize', 16);

% Subplot regular week
subplot(2,1,2);
plot(regularWeek, '.--', 'markersize', 20, ...
    'color', gcl.blue, 'linewidth', 2);

title({''; 'Regular week'})
legend boxoff;
box off;

ylabel('Amplitude');

xticks([0:6:numDays*24]);
xlim([1 numDays*24]);
xlabel('Hours from start');
set(gca, 'fontsize', 16);

set(gcf,'color','w');
tightfig;

% Reshape data from vector into [hour values, day] format
gaussiannoise = round(reshape(gaussiannoise, 24, numDays) * 100);
regularWeek = round(reshape(regularWeek, 24, numDays) * 100);

% Should be 0 for large N
fprintf('\nIS for Gaussian noise (close to 0 for large N): %1.4f\n', ...
calculateInterdayStability2(gaussiannoise));

% Should be 2
fprintf('IV for Gaussian noise (should be 2): %1.4f\n', ...
calculateIntradayVariability2(gaussiannoise));

% Should be 1 for perfect routines
fprintf('IS for perfect IS (should be 1): %1.4f\n', ...
calculateInterdayStability2(regularWeek));


%% Test IV of sine wave vs. period length (hrs)

figure('position', [0 0 1000 1200]);

% Generate a sine wave with 120-hour period
period = 240;
timestamps = [1:numDays*24]';
radians = timestamps / period * 2 * pi;
sinewave = sin(radians);

subplot(5,1,1);
stem(timestamps, sinewave);
title('Sine wave with 120-hour period');
grid on;

xticks([0:6:numDays*24]);
xlim([1 numDays*24]);
xlabel('Hours from start');
set(gca, 'fontsize', 16);

fprintf('IV for sine wave with 120-hr period: %1.4f\n', ...
        calculateIntradayVariability2(sinewave));
    

% Generate a sine wave with 30-hour period
period = 30;
timestamps = [1:numDays*24]';
radians = timestamps / period * 2 * pi;
sinewave = sin(radians);

subplot(5,1,2);
stem(timestamps, sinewave);
title('Sine wave with 30-hour period');
grid on;

xticks([0:6:numDays*24]);
xlim([1 numDays*24]);
xlabel('Hours from start');
set(gca, 'fontsize', 16);

fprintf('IV for sine wave with 30-hr period: %1.4f\n', ...
        calculateIntradayVariability2(sinewave));


% Generate a sine wave with 24-hour period
period = 24;
radians = timestamps / period * 2 * pi;
sinewave = sin(radians);

subplot(5,1,3);
stem(timestamps, sinewave);
title({''; 'Sine wave with 24-hour period'});
grid on;

xticks([0:6:numDays*24]);
xlim([1 numDays*24]);
xlabel('Hours from start');
set(gca, 'fontsize', 16);

fprintf('IV for sine wave with 24-hr period: %1.4f\n', ...
        calculateIntradayVariability2(sinewave));

% Generate a sine wave with 16-hour period
period = 16;
radians = timestamps / period * 2 * pi;
sinewave = sin(radians);

subplot(5,1,4);
stem(timestamps, sinewave);
title({''; 'Sine wave with 16-hour period'});
grid on;

xticks([0:6:numDays*24]);
xlim([1 numDays*24]);
xlabel('Hours from start');
set(gca, 'fontsize', 16);

fprintf('IV for sine wave with 16-hr period: %1.4f\n', ...
        calculateIntradayVariability2(sinewave));

% Generate a sine wave with 12-hour period
period = 12;
radians = timestamps / period * 2 * pi;
sinewave = sin(radians);

subplot(5,1,5);
stem(timestamps, sinewave);
title({''; 'Sine wave with 12-hour period'});
grid on;

xticks([0:6:numDays*24]);
xlim([1 numDays*24]);
xlabel('Hours from start');
set(gca, 'fontsize', 16);

fprintf('IV for sine wave with 12-hr period: %1.4f\n', ...
        calculateIntradayVariability2(sinewave));
    
set(gcf,'color','w');


% Try many periods
iv = [];
x = 6:6:6*20;
for period = 6:6:6*20
    radians = timestamps / period * 2 * pi;
    sinewave = sin(radians);
    iv = [iv, calculateIntradayVariability2(sinewave)];
end

figure('position', [0 0 600 200]);
plot(iv, '.-', 'markersize', 10, 'color', gcl.blue); 
grid on;
xlabel('Period length (hrs)');
ylabel('IV');
xticklabels(num2cell(x));
set(gca, 'fontsize', 16);
tightfig;
    
    
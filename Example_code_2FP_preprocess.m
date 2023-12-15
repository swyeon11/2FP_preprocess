%% In vivo Dual-Color Fiber Photometry in the mouse thalamus 
% Almas Serikov, Iryna Martsishevska, Wooyeon Shin, and Jeongjin Kim
% https://github.com/swyeon11/2FP_preprocess

addpath('helper functions') % Add path to helper functions
%% Data load
clc
clear

filename = '2color_fp_example_demodulated'; % Load csv file exported from Doricstudio
data = readmatrix(filename+'.csv','Numheaderlines',1);

%% Preprocess
time = data(:,1); %Timestamps in the first column (seconds)
time_use = (time>90); %Skip first 90 seconds to avoid large fluctuation at start

time = data(time_use,1);
gcamp = data(time_use,2); % GCaMP signal data in the second column
rcamp = data(time_use,3); % RCaMP signal data in the third column
data = [time, gcamp, rcamp];

%Plot raw data - Figure 4B
figure('Units', 'centimeters', 'Position', [3 3 9 7]); hold on;
title('Raw data');
plot(time, gcamp, 'g');
plot(time, rcamp, 'r');
% legend('Gcamp demodulated signal', 'Rcamp demodulated signal')
xlabel('Time(s)');
ylabel('Demodulated voltage');
xlim([0 time(end)]);

Fs = 1/(time(2)-time(1)); %Sampling rate

temp=fillmissing(data, 'nearest'); % Fill nan data

temp = FP_downsampling(temp,300); % Downsample data to 300Hz
temp = FP_lowpass(temp, 40); % Filter data with 40Hz lowpass
Fs = 300;

temp = FP_running_dff(temp); % Calculate dF/F with 1min bin moving average as F0

% Plot detrended dF/F data - Figure 4C black
fg = figure('Units', 'centimeters', 'Position', [3 3 7 3]); hold on;
plot(temp(:,1), temp(:,2), 'k');
title('GCaMP signal');
fr = figure('Units', 'centimeters', 'Position', [3 3 7 3]); hold on;
plot(temp(:,1), temp(:,3), 'k');
title('RCaMP signal');

temp = WY_FP_smoothing(temp); % Smoothing with conventional filter

% Plot smoothed dF/F data - Figure 4C color
figure(fg); hold on;
plot(temp(:,1), temp(:,2), 'g');
% legend('raw signal', 'smoothed signal');
xlim([6000 7000])
figure(fr); hold on;
plot(temp(:,1), temp(:,3), 'r');
% legend('raw signal', 'smoothed signal');
xlim([6000 7000])

% temp(:,2:end) = zscore(temp(:,2:end)); % Zscore the data if you want

preprocessed_data = temp;

%% Save preprocessed data into csv file

filename = [filename, '_preprocessed.csv'];

header = {'Time(s)' 'Gcamp(dF/F)' 'Rcamp(dF/F)'};
T = array2table(preprocessed_data);
T.Properties.VariableNames = header;
writetable(T, filename);



%% Extract signals around target event times
eventTs= [
13450
13490
13530
14090
14260
]-8214.906; 
% Enter the time points of the measured behavior in seconds.

timerange = [0, 8000]; % Select the time range to process only signals without big artifacts

eventTs = eventTs(and(eventTs>=timerange(1), eventTs<=timerange(2)));


%% Spot the event time on the signal - Figure 4D

figure('Units', 'centimeters', 'Position', [3 3 10 8]); hold on;
%GCaMP signals with events
subplot(2,1,1);
plot(preprocessed_data(:,1)-(eventTs(1)-100), preprocessed_data(:,2), 'g');
y = ylim;
line([eventTs, eventTs]'-(eventTs(1)-100), [ones(length(eventTs),1)*y(1), ones(length(eventTs),1)*y(2)]','Color','k');
xlim([eventTs(1)-100 eventTs(end)+100]-(eventTs(1)-100))
box off
ylabel('{\Delta}F/F')
xlabel('Time(s)');

%RCaMP signals with events
subplot(2,1,2);
plot(preprocessed_data(:,1)-(eventTs(1)-100), preprocessed_data(:,3), 'r');
y = ylim;
line([eventTs, eventTs]'-(eventTs(1)-100), [ones(length(eventTs),1)*y(1), ones(length(eventTs),1)*y(2)]','Color','k');
xlim([eventTs(1)-100 eventTs(end)+100]-(eventTs(1)-100))
box off
ylabel('{\Delta}F/F')
xlabel('Time(s)');


%% Extract all -10s to 10s signal around behavior events
% Read details explanation in extractPhotometryEvents.m
events = extractPhotometryEvents(preprocessed_data, eventTs,10,10,[-10 0]);

% Plot all events
figure('Units', 'centimeters', 'Position', [3 3 5 5]); hold on; title('Cue Start')
for i = 1:size(events,1)
    temp_e = events{i,1};
    plot(temp_e(:,1)-temp_e(1,1)-10, temp_e(:,2), 'g');
end
hold off;

figure('Units', 'centimeters', 'Position', [3 3 5 5]); hold on; title('Cue Start')
for i = 1:size(events,1)
    temp_e = events{i,1};
    plot(temp_e(:,1)-temp_e(1,1)-10, temp_e(:,3), 'r');
end
hold off;

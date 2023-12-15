function [outputData] = FP_smoothing(inputData)
% 2023-12-15 Wooyeon Shin
%   Smoothing by moving average of data points in 1s(Fs)
% 
% 
%  Input arguments
%  - 'inputData' matrix with 1st column time, other columns with photometry
%  signals(any number of columns). Each row corresponds to a timepoint.
% 
%  Output arguments
%  - 'outputData' smoothed matrix with 1st column time, other columns
%  with photometry signals.
% 
% 
 time = inputData(:,1);
 outputData(:,1) = time;
 
 Fs = floor(1/(time(2) - time(1)));
 
 a = 1;
 b = ones(1,Fs)/Fs;
 
 
 for i = 2:size(inputData,2)
     data = inputData(:,i);
     
%      smth_data = filter(b,a,data); % normal filter
%      smth_data = filtfilt(b,a,data); % 20231212  0-phase filter
     smth_data = smooth(data, Fs, 'sgolay'); % 20231212 sgolay filter
%      
     outputData(:,i) = smth_data;
     
%      figure; hold on;
%      plot(time,data);
%      plot(time, smth_data);
%      title(['Smoothed data ch.' num2str(i-1)]);
%      xlabel('time(s)');
 end
end


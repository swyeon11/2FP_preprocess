function [outputData] = FP_downsampling(inputData, ds_freq, Fs)
% 2023-12-15 Wooyeon Shin
%   downsample
% 
% 
%  Input arguments
%  - 'inputData' matrix with 1st column time, other columns with photometry
%  signals(any number of columns). Each row corresponds to a timepoint.
%  - 'ds_freq' is a frequency in units of (Hz) that you want to downsample to.
%  200~300 Hz is suitable. If input doesn't exist, default is 300 Hz.
%  - 'Fs' is a sampling frequency. (optional) default = calculate from time stamps
%  
% 
%  Output arguments
%  - 'outputData' downsampled matrix with 1st column time, other columns
%  with photometry signals.
% 
% 
 if ~exist('ds_freq', 'var')
     % downsampling freq input does not exist, so default is to 200Hz.
      ds_freq = 300;
 end
 
 
 time = inputData(:,1);
 if ~exist('Fs', 'var')
    Fs = floor(1/(time(2) - time(1)));
 end

 downsampleNum = round(Fs/ds_freq);
 
 
 ds_time = downsample(time,downsampleNum);
 outputData(:,1) = ds_time;
 
 for i = 2:size(inputData,2)
     data = inputData(:,i);
     ds_data = downsample(data,downsampleNum);
     outputData(:,i) = ds_data;
     
%      figure; hold on;
%      plot(time,data);
%      plot(ds_time, ds_data);
%      title(['Data ch.' num2str(i-1)]);
%      xlabel('time(s)');       
 end
end


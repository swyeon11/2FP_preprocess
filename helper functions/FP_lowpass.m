function [outputData] = FP_lowpass(inputData, lp_freq, Fs)
% 2023-12-15 Wooyeon Shin
%   lowpass 
% 
% 
%  Input arguments
%  - 'inputData' matrix with 1st column time, other columns with photometry
%  signals(any number of columns). Each row corresponds to a timepoint.
%  - 'lp_freq' is a filter frequency for lowpass filter. default = 100Hz
%  - 'Fs' is a sampling frequency. (optional) default = calculate from time stamps
% 
%  Output arguments
%  - 'outputData' matrix with 1st column time, other columns with filtered data.
% 
% 
 if ~exist('lp_freq', 'var')
     % lowpass freq input does not exist, so default is to 100Hz.
     lp_freq = 100;
 end
 
time = inputData(:,1);
if ~exist('Fs', 'var')
    Fs = floor(1/(time(2) - time(1)));
end

Wn = lp_freq;
if lp_freq<1
    n = 2;
else
    n = 4;
end

Fn = Fs/2;
ftype = 'low';
[b, a] = butter(n, Wn/Fn, ftype);

outputData(:,1) = time;
 for i = 2:size(inputData,2)
     data = inputData(:,i);
     
     lp_data = filtfilt(b,a,data);
     
     outputData(:,i) = lp_data;
 end
end
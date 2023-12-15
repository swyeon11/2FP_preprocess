function [outputData] = FP_running_dff(inputData)
% 2023-12-15 Wooyeon Shin
%   dF/F with running average method((Cui et al., 2014, NATURE PROTOCOLS)
%   Define F as the mean of value per 1 min
%   to select baseline during transients(decreasing in fluorescence).
%   No need for detrending after this.
%
%
%  Input arguments
%  - 'inputData' matrix with 1st column time, other columns with photometry
%  signals(any number of columns). Each row corresponds to a timestamp in seconds.
% 
%  Output arguments
%  - 'outputData' matrix with 1st column time, other columns with dF/F of input data.
% 
% 
outputData = inputData;



% dF/F calculation using Running average method from (G. Cui et al. 2014
% nature protocol)
 time = inputData(:,1);
 Fs = round(1/(time(2) - time(1)));
 n = Fs*60; %number of values for 1 min
 
 
 for i = 2:size(inputData,2)
     data = inputData(:,i);
     
     seg_F = movmean(data,n, 'Endpoints', 'shrink'); 
     
     dff_data = (data-seg_F)./seg_F;
     
     outputData(:,i) = dff_data;
 end
 
end


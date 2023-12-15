function outputCell = FP_extractPhotometryEvents(inputData,eventTimes,preWindow,postWindow,shiftWindow)
% For photometry recordings, saves data before/after an event and shifts so
% the data is aligned at 0. For example, given a long recording and the 
% times when a mouse goes from sleep->awake, this function can save 
% the 10 sec before/after each waking.
%
%  Input arguments
%  - 'inputData' matrix has 1st column time, other columns the photometry
%     signals (the function can handle any number of columns). Each row
%     corresponds to a timepoint
%
%  - 'eventTimes' is a vector containing the times of each event trigger
%
%  - 'preWindow' is the length of time before the event to save. For example,
%     if preWindow=10, then the function saves values from -10sec 
%  - 'postWindow' is the length of time after the event to save. For example,
%     if postWindow=10, then the function saves values to +10sec
%
%  - 'shiftWindow' determines what time range is used as the 'zero' value.
%     For example, if shiftWindow=[-10,-5] then this function will find the
%     average between -10 to -5 seconds, and shift the data so the new
%     average is 0. 
%
%
%  Output arguments
%  - 'outputCell' is a cell array. The first column contains matrices of the
%     saved data (formatted like the input). The 2nd column has the time of
%     the event. The 3rd column has the mean signal from prewindow to the event 
%     time. The 4th column has the mean signal from the event time to postWindow.

outputCell = cell(length(eventTimes),4); 

times = inputData(:,1);

Fs = round((1/(times(4)-times(3)))/10)*10;

windowIdx = Fs*(preWindow+postWindow); 
preWindowIdx = Fs*preWindow;
postWindowIdx = Fs*postWindow;

% loop over each event
for i = 1:length(eventTimes)
    shiftedTime = times-eventTimes(i);
    
    startIdx = find(shiftedTime >= -preWindow, 1);
    
    if(startIdx+windowIdx-1 < size(inputData,1)) 
        eventVals = inputData(startIdx:startIdx+windowIdx-1,:);

        % find mean value within shiftWindow
        swidx = (eventVals(:,1)-eventTimes(i))<shiftWindow(2) & (eventVals(:,1)-eventTimes(i))>shiftWindow(1);
        swVals = eventVals(swidx,2:end);
        swMean = mean(swVals);
		
        eventVals = [eventVals(:,1) (eventVals(:,2:end)-swMean) eventVals(:,2:end)]; 

        % save to output
        outputCell{i,1} = eventVals;
        outputCell{i,2} = eventTimes(i);
        outputCell{i,3} = mean(eventVals(1:preWindowIdx,2)); %20200804 WY
        outputCell{i,4} = mean(eventVals(preWindowIdx+1:end,2)); %20200804 WY
    end
end




end
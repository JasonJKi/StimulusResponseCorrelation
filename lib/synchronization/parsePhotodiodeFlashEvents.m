function [stimulusflashIndx,tStart, tEnd, nFlash, startIndex, endIndex] = parsePhotodiodeFlashEvents(photodiode,triggerCode,timestamp)
n = length(photodiode);
% get ppt flash and frame marker events
% index frame marking events based on the trigger identifier
flashEventIndx = find(photodiode==triggerCode);
firstFlashEventIndx = flashEventIndx(abs(diff([0;flashEventIndx])) > 2);

% index flash events on the monitor based on the trigger identifier
itervalIndex = findFlashEventIntervals(firstFlashEventIndx);
longestInterval = findLongestInterval(itervalIndex);
longestInterval = checkEndIndex1(firstFlashEventIndx,longestInterval);

stimulusflashIndx =  firstFlashEventIndx(longestInterval);

% get start and end time of the longest marker chain
startIndex = stimulusflashIndx(1);
[endIndex, stimulusflashIndx]= checkEndIndex2(stimulusflashIndx,photodiode);

tStart = timestamp(startIndex); 
tEnd = timestamp(endIndex);
nFlash = length(stimulusflashIndx);
 
% figure;clf;hold on;
% p1 = plot(photodiode,'b','DisplayName',''); % plot all events
% p2 = plot(flashEventIndx,photodiode(flashEventIndx),'y.');
% p3 = plot(firstFlashEventIndx,photodiode(firstFlashEventIndx),'r.');
% p4 = plot(stimulusflashIndx,photodiode(stimulusflashIndx),'g.');
% p5 = plot([startIndex endIndex],photodiode([startIndex endIndex]),'k*');
% legend([p3 p4 p5],'flash on screen','stimulus flash marker', 'start & end','Location','southwest');
end

function itervalIndex = findFlashEventIntervals(firstFlashEventIndx)
%find chains
diffFlashMarker = diff(firstFlashEventIndx);
medianDiffFlashMarker = median(diffFlashMarker);
diffThreshold = medianDiffFlashMarker*.4;
intervals = abs(diffFlashMarker-medianDiffFlashMarker) < diffThreshold;
itervalIndex = find(intervals);
end

function longestInterval = findLongestInterval(itervalIndex)
intervalIndex_ = [-1; itervalIndex;-1];
intervals = find(abs(diff(intervalIndex_ )) >1);
if length(intervals) < 2
    longestInterval =itervalIndex;
else
    intervalDiff = diff(intervals);
    maxInterval = find(max(intervalDiff) == intervalDiff);
    i0_ = intervals(maxInterval);
    iT_ = intervals(maxInterval+1);
    longestInterval = itervalIndex(i0_:(iT_-1));
end
end

function longestInterval = checkEndIndex1(firstFlashEventIndx,longestInterval) 
diffFlashThresh =  firstFlashEventIndx(longestInterval)*.1;
endIndex = firstFlashEventIndx(longestInterval(end));
endIndexNew = firstFlashEventIndx(longestInterval(end)+1);
if abs(endIndex - endIndexNew) < diffFlashThresh
    longestInterval = [longestInterval; longestInterval(end)+1];
end
end

function [endIndex, stimulusflashIndx] = checkEndIndex2(stimulusflashIndx,photodiode)
endIndex = stimulusflashIndx(end);
threshold = sum(diff(photodiode(endIndex:endIndex+250)));
if threshold == 0
    stimulusflashIndx(end) = [];
    endIndex = stimulusflashIndx(end);
end
end

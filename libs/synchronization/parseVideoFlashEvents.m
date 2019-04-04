function [FlashInfo] = parseVideoFlashEvents(flashEvents,threshold,show)
n = length(flashEvents);
flashEvents = double(flashEvents);

if nargin < 2 || isempty(threshold) || threshold == 0
    threshold = max(flashEvents)*.85;
end

if nargin < 3
    show = 1;
end

diffFlashFrameIndex = [0; diff(flashEvents)];
flashFrameIndex = find(diffFlashFrameIndex > threshold);
flashFps = mean(diff(flashFrameIndex));
flashFpsStd = std(diff(flashFrameIndex));
flashFrameIndex = checkLastIndex(flashEvents,flashFrameIndex);
nFlash = length(flashFrameIndex);
startIndex = flashFrameIndex(1);
endIndex = flashFrameIndex(end);

FlashInfo.flashEvents = flashEvents;
FlashInfo.flashFrameIndex = flashFrameIndex;
FlashInfo.flashFps = flashFps;
FlashInfo.flashFpsStd = flashFpsStd;
FlashInfo.nFlash = nFlash;
FlashInfo.startIndex = startIndex;
FlashInfo.endIndex = endIndex;
FlashInfo.threshold = threshold;

if show
    figure;clf;hold on;
    plot(FlashInfo.flashEvents);
    h1 = plot(1:n,repmat(FlashInfo.threshold,1,n));
    h2 = plot(FlashInfo.flashFrameIndex,FlashInfo.flashEvents(FlashInfo.flashFrameIndex)','.');
    h3 = plot([FlashInfo.startIndex FlashInfo.endIndex],flashEvents([FlashInfo.startIndex FlashInfo.endIndex]),'*k')
    legend([h1 h2 h3],{'threshold', 'flash occurence' 'start & finish'},'Location','southwest');
end

function flashFrameIndex = checkLastIndex(flashEvents,flashFrameIndex)
stimulusEvents = flashEvents(flashFrameIndex);
stdFlashIntensity = std(stimulusEvents);
meanFlashIntensity = mean(stimulusEvents);

threshold = meanFlashIntensity - stdFlashIntensity*3;
lastIndex = stimulusEvents(end);
if threshold > lastIndex
    flashFrameIndex(end) = [];
end








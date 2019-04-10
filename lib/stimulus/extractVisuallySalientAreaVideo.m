function [videoSalientAreaIndex]= extractVisuallySalientAreaVideo(videoSalienceMap, outSize, threshPercentage)

if nargin < 3
    threshPercentage = 75;
end

height = outSize(1);
width = outSize(2);
numFrames = size(videoSalienceMap,1);

videoSalientAreaIndex = boolean(zeros(numFrames, height, width));
for iFrame = 1:numFrames
    salienceMap = squeeze(videoSalienceMap(iFrame,:,:,:));
    [imgThesholdIndex, ~] = extractVisuallySalientArea(salienceMap,[height, width], threshPercentage);
    videoSalientAreaIndex(iFrame,:,:)  = imgThesholdIndex;
end

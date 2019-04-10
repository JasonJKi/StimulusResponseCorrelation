function [imgThesholdIndex, saliencMapResized] = extractVisuallySalientArea(salienceMap, imgSize, thresholdPercentage)
% show result in a pretty way
imgHeight = imgSize(1);
imgWidth = imgSize(2);
if nargin < 3
    thresholdPercentage = 75;
end

saliencMapResized = [];
[height, width] =   size(salienceMap);
if ~((height == imgHeight) && (width == imgWidth))
    salienceMap = imresize( salienceMap , [imgHeight, imgWidth] , 'bicubic' );
    saliencMapResized = salienceMap;
end

imgThesholdIndex =  salienceMap >= prctile(salienceMap(:),thresholdPercentage);

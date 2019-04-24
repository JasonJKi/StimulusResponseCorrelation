function [ videoOut ] = videoPool(video, kernelSize)

[numFrames, height, width, numChannels] = size(video);
if nargin < 2
    kernelSize = [5 5];
end

% [h, w] = poolSize(height, width, kernelSize);
% poolIndx = poolIndex(height, width, kernelSize);
% dataType = 'single';
% videoOut = zeros(h, w, nFrames, dataType);

for iFrame = 1:numFrames
    frame = squeeze(video(iFrame,:,:,:));
    videoOut(iFrame,:,:,:) = sepblockfun(frame,kernelSize,'max');
%     videoOut = pooling(frame, kernel, @max, poolIndx);    
end

end


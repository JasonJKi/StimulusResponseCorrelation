function [ videoOut ] = videoPool(video, kernel, preview)

if nargin < 2
    kernel = 0;
end

if ndims(video) > 3
    [nFrames, height, width, nChannels] = size(video);
else
    [nFrames, height, width] = size(video);
    nChannels = 1;
end

dataType = 'single';
% pre-allocate features
if nargin < 3
    preview = 0;
end

[hResized, wResized] = poolSize(height,width,kernel);
poolIndx = poolIndex(height,width,kernel);
videoOut = zeros(nFrames, hResized, wResized,dataType);


for i=1:nFrames
    
    frame = squeeze(video(i,:,:,:));
    frame = pooling(frame,kernel,@max,poolIndx);
    
    if preview
        disp(['frame number: ' num2str(i)]);
        imagesc(frame)
        pause(.001);
    end
    videoOut(i,:,:) = frame;
end


function previewFrames(video,numFrames,fps)
if nargin < 3 || isempty(fps)
    fps = 30;
end

if nargin < 2 
    numFrames = size(video,1);
end



figure
for iFrame = 1:numFrames    
    frame = squeeze(video(iFrame,:,:,:));
    imshow(frame);
    pause(1/fps)
    clf
end

function videoOut = resizeVideo(video, ratio)

[numFrames, height, width, numChannels] = size(video);

for i = 1:numFrames
    frame = squeeze(video(i,:,:,:));
    frameResized = imresize(frame, ratio);
    videoOut(i,:,:,:) = frameResized;
end
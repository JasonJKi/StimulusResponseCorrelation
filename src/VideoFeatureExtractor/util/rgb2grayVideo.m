function grayVideo = rgb2grayVideo(rgbVideo)
%RGB2GRAYVIDEO Convert rgb video to gray scale
[nFrames, height, width, ~] = size(rgbVideo);
grayVideo = zeros(nFrames,height,width,'uint8');
for i = 1:nFrames
    frame = squeeze(rgbVideo(i,:,:,:));
    grayVideo(i,:,:,:) = rgb2gray(frame);
end

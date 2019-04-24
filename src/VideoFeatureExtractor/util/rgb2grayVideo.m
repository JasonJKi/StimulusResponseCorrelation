function grayVideo = rgb2grayVideo(rgbVideo)
%RGB2GRAYVIDEO Convert rgb video to gray scale
[height, width, ~, nFrames] = size(rgbVideo);
grayVideo = zeros(height,width,nFrames,'uint8');
for i = 1:nFrames
    grayVideo(i,:,:,:) = rgb2gray(rgbVideo(i,:,:,:));
end
end
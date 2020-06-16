function videoFrameMean = videoMean2(video)
%VIDEOMEAN2 Compute the mean intensity of a video for every frame.
%   VIDEOMEAN2 is a function that takes a video and computes mean across 
%   all pixels for every single frame. This function is written
%   specifically to take advantage of matlab's parallel processing
%   computation thus avoid writing a for loop for every frame. 

% Get the number of dimensions for the video.
nDimensions = length(size(video));

% If the dimension is greater than 3 convert video to gray scale.
if nDimensions > 3 
    video = rgb2grayVideo(video);
end

[nFrames, height, width] = size(video);
% Reshaping video into 2 dimensions 
videoReshaped = reshape(video,[nFrames height*width]);
% get average intensity of each frame
videoFrameMean = mean(videoReshaped,2); % transpose to return a colum vector

% for i = 1:nFrames
%     frame = squeeze(video(i,:,:));
%     mean = mean2(frame);
%     videoMean(i) = mean;
% end


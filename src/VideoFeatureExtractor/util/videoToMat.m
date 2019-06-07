function [video, videoGray, videoObj] = videoToMat(inpath,outpath,scale,color,preview)

boolSave = true;
if nargin < 2 || isempty(outpath)
    boolSave  = false;
end

if nargin < 3 || isempty(scale) 
    scale = 1;
end

if nargin < 4 || isempty(color)
    color = 'rgb'
    channels = 3;
    boolGray = false;
end

if strcmp(color,'gray')
    boolGray = true;
    channels = 1;
else
    boolGray = false;
    channels = 3;
end
    


if nargin < 5 || isempty(preview) || (preview == false) || (preview == 0)
    boolPreview  = false;
else
    boolPreview = true;
    currentAxes = axes;
    disp('preview video')
end

% create video object using VideoReader
videoObj = VideoReader(inpath);
% video details
duration = videoObj.Duration;
fps = videoObj.FrameRate;
nFrames = floor(duration * fps);
width = videoObj.Width;
height = videoObj.Height;
% 
% if scale
%     width = round(width*.5);
%     height = round(height*.5);
% end

i = 1;
while hasFrame(videoObj)
    frame = readFrame(videoObj);
    
    if scale
        frame = imresize(frame,scale); 
    end
    
    frameGray = rgb2gray(frame);   
    
    if boolPreview
        previewFrame(frame,currentAxes,fps);
    end
    
    if i == 1
        [height, width, ~] = size(frame);
        video = zeros(nFrames,height, width, channels,'uint8');
        videoGray = zeros(nFrames,height ,width, 'uint8');
    end
    
    video(i,:,:,:) = frame;
    videoGray(i,:,:) = frameGray;
    i = i+1;
end

if boolGray
    video = squeeze(video);
end

if boolSave
   save(outpath,'video','videoObj')
end
end


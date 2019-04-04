function localizedVideoView =  localizeVideoView(video,px,py,scale)
%LOCALIZEVIDEOVIEW  A function for localizing the video to a single pixel
% pixel point of interest.

% Get height and width of the video.
if ndims(video) > 3
    [nFrames, height, width, nChannels] = size(video);
else
    [nFrames, height, width] = size(video);
    nChannels = 1;
end
% distance from the center of the region of interest based
dx = 1;
dy = 1;

% Scale height and width for the region of interest relative to the video
% aspect ratio.
if nargin > 3
localWidth = floor(scale*width);
localHeight = floor(scale*height);

% Set max and min distance from the center of the region of interest based
% on aspect ratio.
dx = floor(localWidth/2);
dy = floor(localHeight/2);
end

% If pixel arguments are empty than localize at the top right corner
% as default.
if nargin < 2
    px = width - dx;
    py = 1 + dy;    
end

% set localized x and y regions 
xMin = px - dx; xMax = px + dx;
yMin = py - dy; yMax = py + dy;
xRangeIndex = (xMin:xMax); 
yRangeIndex = (yMin:yMax)';


localizedVideoView = video(:,yRangeIndex,xRangeIndex,:);




function videoFeature = computeVideoFeature(func, video, kernel, preview)

if nargin <3
    kernel = 0;
end

if ndims(video) > 4
    [height, width, nChannels, nFrames] = size(video);
else
    [height, width, nFrames] = size(video);
    nChannels = 1;
end

% set up optical opticalFlow computation
% opticFlowModel = vision.OpticalFlow('ReferenceFrameSource','Input port');
dataType = 'single';

% pre-allocate features
if nargin < 4
    preview = 0;
end

if preview 
    currentAxes = axes;
end

if kernel
    [h, w] = poolSize(height,width,kernel);
    poolIndx = kron(reshape(1:(height*width/(kernel^2)),width/kernel,[])',ones(kernel));
    videoFeature = zeros(h, w, nFrames, dataType);
else
    videoFeature = zeros(height, width, nFrames, dataType);
end

img1 = zeros(height, width, dataType);
img2 = zeros(height, width, dataType);
for i=1:nFrames
    
    if i > 1
        if nChannels > 1
            frame1 = rgb2gray(video(:,:,:,i-1));
            frame2 = rgb2gray(video(:,:,:,i));
        else
            frame1 = video(:,:,i-1);
            frame2 = video(:,:,i);
        end
        img1=single(frame1);
        img2=single(frame2);
    end
    
    % optical flow
    frame = func(img1,img2,i);
    
    % perform max pooling downsample
    if kernel 
        frame = pooling(frame,kernel,@max,poolIndx);
    end
    
    if preview
        disp(['frame number: ' num2str(i)])
        previewFrame(frame,currentAxes);
    end
    
    videoFeature(:,:,i) = frame;
end

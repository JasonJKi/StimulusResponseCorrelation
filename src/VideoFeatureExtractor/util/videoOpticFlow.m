function [opticFlow] = videoOpticFlow(video,kernel,preview)

if nargin < 2
    kernel = 0;
end

if ndims(video) > 3
    [nFrames, height, width, nChannels] = size(video);
else
    [nFrames, height, width] = size(video);
    nChannels = 1;
end

% set up optical opticalFlow computation
opticFlowModel = vision.OpticalFlow('ReferenceFrameSource','Input port');
dataType = 'single';

% pre-allocate features
if nargin < 3
    preview = 0;
end
if preview 
    currentAxes = axes;
end
if kernel
    [hResized, wResized] = poolSize(height,width,kernel);
    poolIndx = poolIndex(height,width,kernel);
    opticFlow=zeros(nFrames, hResized, wResized,dataType);
else
    opticFlow=zeros(nFrames, height,width,dataType);
end

img1 = zeros(height,width,dataType);
img2 = zeros(height,width,dataType);
for i=1:nFrames
    
    if i > 1
        if nChannels > 1
            frame1 = rgb2gray(squeeze(video(i-1,:,:,:)));
            frame2 = rgb2gray(squeeze(video(i,:,:,:)));
        else
            frame1 = squeeze(video(i-1,:,:));
            frame2 = squeeze(video(i,:,:));
        end
        img1=single(frame1);
        img2=single(frame2);
    end
    
    % optical flow
    flow = step(opticFlowModel,img2,img1);

    % opticFlowModel2 = vision.OpticalFlow('ReferenceFrameSource','Input port');
    % opticFlowModel2.OutputValue = 'Horizontal and vertical components in complex form';

    % flow2 = step(opticFlowModel2, img2, img1);
    % flow2_ = abs(flow2).^2;
    
    % perform max pooling downsample
    if kernel >1
        flow = pooling(flow,kernel,@max,poolIndx);
    end
    
    if preview
        disp(['frame number: ' num2str(i)]);
        previewFrame(flow, currentAxes);
        pause(.001);
    end
    
    opticFlow(i,:,:) = flow;
end

return 

vidReader = VideoReader('viptraffic.avi');
opticFlow = opticalFlowLK('NoiseThreshold',0.009);

while hasFrame(vidReader)
    frameRGB = readFrame(vidReader);
    frameGray = rgb2gray(frameRGB);
  
    flow = estimateFlow(opticFlow,frameGray); 

    imshow(frameRGB) 
    hold on
    plot(flow,'DecimationFactor',[5 5],'ScaleFactor',10)
    imagesc(flow.Magnitude)
    hold off 
end

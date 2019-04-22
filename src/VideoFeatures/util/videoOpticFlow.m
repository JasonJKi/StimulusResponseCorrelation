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
if kernel;
    [h w] = poolSize(height,width,kernel);
    poolIndx = poolIndex(height,width,kernel);
    opticFlow=zeros(h,w,nFrames,dataType);
else
    opticFlow=zeros(height,width,nFrames,dataType);
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
    opticFlow_ = step(opticFlowModel,img2,img1);
%      flow = estimateFlow(opticalFlowHS,img1);
%      opticFlow__ = flow.Magnitude;
%      sum(opticFlow__ - opticFlow_)
     
    % perform max pooling downsample
    if kernel 
        opticFlow_ = pooling(opticFlow_,kernel,@max,poolIndx);
    end
    
    if preview
        disp(['frame number: ' num2str(i)])
        previewFrame(opticFlow_, currentAxes);
        pause(.001)
    end
    
    opticFlow(i,:,:) = opticFlow_;
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

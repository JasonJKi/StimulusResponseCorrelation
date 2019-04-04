function features = extractStimulusFeatures(stimFilename,outFilename)
% read in a movie and return visual and auditory features
% stimFilename: string movie file
% outFilename: string mat file where features will be stored

if nargin<2
    outFilename=[stimFilename(1:end-4) '-features-' date '.mat'];
end

% read in stimulus file
vidObj=VideoReader(stimFilename);
vidFrames=read(vidObj);
nFrames=size(vidFrames,4);
fsVideo=vidObj.FrameRate;
% set up optical flow computation
opticalFlow = vision.OpticalFlow('ReferenceFrameSource','Input port');

dataType = 'single'
% pre-allocate features
muFlow=zeros(nFrames,1,dataType);
muSqFlow=zeros(nFrames,1,dataType);
muLuminance=zeros(nFrames,1,dataType);
muSqLuminance=zeros(nFrames,1,dataType);
muLocalContrast=zeros(nFrames,1,dataType);
muSqLocalContrast=zeros(nFrames,1,dataType);
stdLocalContrast=zeros(nFrames,1,dataType);
muTemporalContrast=zeros(nFrames,1,dataType);
muSqTemporalContrast=zeros(nFrames,1,dataType);
kern=ones(30);  % TODO: make this a parameter, or at least check image size
diode=zeros(nFrames,1);

for f=1:nFrames
    f/nFrames*100
    img=squeeze(vidFrames(:,:,:,f));
    grayImg=rgb2gray(img);
    floatGrayImg=double(grayImg);
    
    if f>1
        imgRef=squeeze(vidFrames(:,:,:,f-1));
        floatGrayImgRef=double(rgb2gray(imgRef));
    else
        floatGrayImgRef=zeros(size(vidFrames,1),size(vidFrames,2));
    end
    
    flow=step(opticalFlow,floatGrayImg,floatGrayImgRef);
    muFlow(f)=mean2(flow);
    muSqFlow(f)=mean2(flow.^2);
    
    if ~mod(f,2)
        for i = 1:width
        flow=step(opticalFlow,floatGrayImg,floatGrayImgRef);
%         flow=step(opticalFlow,floatGrayImg,floatGrayImgRef);
        end
    end
    
    topCorner=floatGrayImg(1:3,end-2:end); % 3 x 3 square, for now
    topCorner=topCorner(:);
    diode(f)=mean(topCorner);
    
    muTemporalContrast(f)=mean2(floatGrayImg-floatGrayImgRef);
    muSqTemporalContrast(f)=mean2((floatGrayImg-floatGrayImgRef).^2);
    
    % compute luminance
    muLuminance(f)=mean2(floatGrayImg);
    muSqLuminance(f)=mean2((floatGrayImg).^2);
    
    % local contrast
    bg = conv2(floatGrayImg,kern,'same');
    bg(isnan(bg)) = 0;
    lc = abs((floatGrayImg - bg) ./ bg);
    lc(isnan(lc)) = 0;
    muLocalContrast(f)=mean2(lc);
    muSqLocalContrast(f)=mean2((lc).^2);
    stdLocalContrast(f)=std2(lc);
end

% read in soundtrack
try
    [y,fsAudio]=audioread(stimFilename);
catch
    error('failed to read audio file');
end


yh=hilbert(y(:,1));  % soundtrack is mono
soundEnvelope=sqrt(real(yh).^2+imag(yh).^2);
fsVideo=round(fsVideo);fsAudio=round(fsAudio)
soundEnvelopeDown=resample(soundEnvelope,fsVideo,fsAudio); % downsample to video frame rate

% legacy
fs=fsVideo;

% output features
features.fs=fs;
features.fsVideo=fsVideo;
features.fsAudio=fsAudio;
features.flow;
features.muFlow=muFlow;
features.muSqFlow=muSqFlow;
features.muTemporalContrast=muTemporalContrast;
features.muSqTemporalContrast=muSqTemporalContrast;
features.muLuminance=muLuminance;
features.muSqLuminance=muSqLuminance;
features.muLocalContrast=muLocalContrast;
features.muSqLocalContrast=muSqLocalContrast;
features.stdLocalContrast=stdLocalContrast;
features.soundEnvelope=soundEnvelope;
features.soundEnvelopeDown=soundEnvelopeDown;

features.diode=diode;

% output to file
save(outFilename,'features','fs','fsVideo','fsAudio',...
    'muFlow','muSqFlow',...
    'muTemporalContrast','muSqTemporalContrast',...
    'muLuminance','muSqLuminance',...
    'muLocalContrast','muSqLocalContrast','stdLocalContrast',...
    'soundEnvelope','soundEnvelopeDown','diode');
end
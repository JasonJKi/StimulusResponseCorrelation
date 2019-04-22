classdef Video < handle
    %VIDEO - functionality for reading array input types that has video structure.
    %   Detailed explanation goes here
    
    properties
         % Video dimension.
        height;
        width;
        numChannels;
        numFrames;
        frameRate;
        duration;
        videoFormat;
        
        data;
        currentFrameIndex = 0;
        
        messageStr
    end
    
    methods
        function this = Video(video, frameRate)
            %VIDEO Construct a object for efficiently handling matlab array with video structure.
            % video (numFrames x height x width x numChannels)
            if nargin < 1
                return
            end
            this.data = video;
            setDimensions(video)
            setTimeInfo(frameRate, this.numFrames)
        end
        
        function setDimensions(this, video)
            [this.numFrames, this.height, this.width, this.numChannels] = size(video);
        end
        
        function setTimeInfo(this, frameRate, numFrames)
            this.duration = frameRate * numFrames;
            this.frameRate = frameRate;
        end
        
        function [numFrames, height, width, numChannels] = getDimensions(this)
            numFrames = this.numFrames;
            height = this.height;
            width = this.width;
            numChannels = this.numChannels;
        end
        
        function frame = readFrame(this)
            frame = squeeze(this.data(this.currentFrameIndex,:,:,:));
        end
        
        function status = hasFrame(this)
            frameIndex = this.currentFrameIndex;
            
            status = ~(this.currentFrameIndex >= this.numFrames);
            if status
                this.currentFrameIndex = frameIndex + 1;
            else
                resetFrameIndex(this)
            end
            
        end
                 
        function resetFrameIndex(this)
            this.currentFrameIndex=0;
        end
        
        
        function this = initFromVideoReader(this, VideoReader)
            setVideoReaderInfo(this,VideoReader);
            vid = this.allocateOutputMemory(this.numFrames, this.height, this.width, this.numChannels);
            
            iFrame = 1;
            while hasFrame(VideoReader)
                
                frame = readFrame(VideoReader);
                vid(:,:,:,iFrame) = frame;
                
                statusMessage(this, iFrame)
                
                iFrame = iFrame + 1;
            end
            
            numDims = numel(size(vid));
            this.data = shiftdim(vid, numDims-1);
        end
        
        function statusMessage(this, iFrame)
            if iFrame == 1
                this.messageStr = '';
            end
            
            if ~mod(iFrame,100) || (iFrame == 1) || iFrame == this.numFrames
                msg = sprintf('Loading %d/%d Frames', iFrame, this.numFrames);
                fprintf([this.messageStr, msg]);
                this.messageStr = repmat(sprintf('\b'), 1, length(msg));
            end
        end
        
        function this = setVideoReaderInfo(this, video)
            this.height = video.Height;
            this.width =  video.Width;
            this.frameRate = video.FrameRate;
            this.duration = video.Duration;
            this.numFrames = video.Duration*video.FrameRate;
            
            if strcmp(video.VideoFormat,'Grayscale')
                this.numChannels = 1;
            else
                this.numChannels = 3;
            end
                       
        end
    end
    
    methods (Static = true)
        
        function output = allocateOutputMemory(numFrames, height, width, numChannels)
            output = zeros(height, width, numChannels, numFrames, 'uint8');
        end
        
    end    
end


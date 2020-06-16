classdef Video < handle
    %VIDEO - functionality for reading array input types that has video structure.
    %   Detailed explanation goes here
    
    properties
         % Video dimension.
        height;
        width;
        num_channels;
        num_frames;
        frame_rate;
        duration;
        video_format;
        name = 'unknown';
        timestamp
        
        data;
        currentFrameIndex = 0;
        
        messageStr
    end
    
    methods

        %----------------------------------------------------------------------
        % Constructor
        %----------------------------------------------------------------------
        function this = Video(video, frame_rate, name)
            %VIDEO Construct a object for efficiently handling matlab array with video structure.
            % video (num_frames x height x width x num_channels)
            if nargin < 1
                return
            end
            if nargin > 2
                this.name = name;
            end
                
            this.data = video;
            setDimensions(this, video)
            setTimeInfo(this, frame_rate, this.num_frames)
        end
        
        function setDimensions(this, video)
            [this.num_frames, this.height, this.width, this.num_channels] = size(video);
        end
        
        function setTimeInfo(this, frame_rate, num_frames)
            this.duration = frame_rate * num_frames;
            this.frame_rate = frame_rate;
            this.timestamp = (1:num_frames)'/frame_rate;
        end
        
        function [num_frames, height, width, num_channels] = getDimensions(this)
            num_frames = this.num_frames;
            height = this.height;
            width = this.width;
            num_channels = this.num_channels;
        end
        
        function frame = readFrame(this)
            frame = squeeze(this.data(this.currentFrameIndex,:,:,:));
        end
        
        function status = hasFrame(this)
            frameIndex = this.currentFrameIndex;
            
            status = ~(this.currentFrameIndex >= this.num_frames);
            if status
                this.currentFrameIndex = frameIndex + 1;
            else
                resetFrameIndex(this)
            end
            
        end
                 
        function resetFrameIndex(this)
            this.currentFrameIndex=0;
        end
        
        
        function this = initFromVideoReader(this, VideoReader, resizeRatio)
            if nargin < 3
                resizeRatio = 0;
            end
                        
            iFrame = 1;
            while hasFrame(VideoReader)
                frame = readFrame(VideoReader);
                
                if resizeRatio
                    frame = imresize(frame, resizeRatio);
                end
                
                if iFrame == 1
                    setVideoReaderInfo(this, VideoReader, frame);
                    this.data = this.allocateOutputMemory(this.num_frames, this.height, this.width, this.num_channels);
                end
                
                
                
                this.data(:,:,:,iFrame) = frame;
                
                statusMessage(this, iFrame)
                
                iFrame = iFrame + 1;
            end
            
            numDims = numel(size(this.data));
            this.data = shiftdim(this.data, numDims-1);
            
        end
        
        function statusMessage(this, iFrame)
            if iFrame == 1
                this.messageStr = '';
            end
            
            if ~mod(iFrame,100) || (iFrame == 1) || iFrame == this.num_frames
                msg = sprintf('Loading %d/%d Frames', iFrame, this.num_frames);
                fprintf([this.messageStr, msg]);
                this.messageStr = repmat(sprintf('\b'), 1, length(msg));
            end
        end
        
        function this = setVideoReaderInfo(this, video, frame)
            [height, width, num_channels] = size(frame);
            this.height = height;
            this.width = width;
            this.frame_rate = video.FrameRate;
            this.duration = video.Duration;
            this.num_frames = floor(video.Duration*video.FrameRate);
            this.name = video.name;
            this.num_channels = num_channels;
            this.timestamp = (1:this.num_frames)'/this.frame_rate;
        end
        
    end
    
    methods (Static = true)
        
        function output = allocateOutputMemory(num_frames, height, width, num_channels)
            output = zeros(height, width, num_channels, num_frames, 'uint8');
        end
        
    end    
end


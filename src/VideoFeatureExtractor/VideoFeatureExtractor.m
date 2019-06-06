classdef VideoFeatureExtractor < handle
    % VideoFeatureExtractor - Time Series Feature Extractor 
    %   The TSFeatureExtractor provides organized and computationally efficient
    % way of performing feature extraction of timeseries video data.
    
    properties
        video
        
        % Video dimension.
        height;
        width;
        numFrames;
        frameRate;
        duration;
        numChannels;
        
        method = {};
        numMethods = 0;

        features = {};
        resizeRatio = 1;
        isResized =  false;
        
        iFrame = 1;
        
    end
    
    properties (Access = public, Constant)
        % Available feature extraction method info data
    end

    properties (Access = private) 
            messageStr = ''
    end
    
    properties (Access = private)
        % Video method types
        currentFrameIndex = [];
        currentFrame = [];
        colonsForMultiDimIndex = [];
        
        imageResized = false;        
    end
    
    methods
        
        % CONSTRUCTOR VideoFeatureExtractor(videoReader)
        %
        % CONSTRUCTOR VideoFeatureExtractor(videoArray) 
        % videoArray - (NumFrames x height x width x numChannels)
        %
        % You could create a videoArray by
        % video = initFromVideoReader(Video(), videoReader); % Create a Video object with preloaded videos
        % vidFeatureExtractor = Extractor(videoReader); % Load video as extractor computes.
        function this = VideoFeatureExtractor(video)
            if nargin < 1
                return;
            end
            initVideo(this, video)
        end
        
        function initVideo(this, video)
             if isa(video, 'Video')                
                setVideoInfo(this, video);
            elseif isa(video, 'VideoReader') 
                setVideoReaderInfo(this, video);
            else
                error('Input to Extractor must be type Video or VideoReader')                
            end
        end
        
        function  this = setVideoReader(this, videoReader)
            setVideoReaderInfo(this, videoReader);
        end
        
        function this = setVideoInfo(this, video)
            this.video = video;
            this.height = video.width;
            this.width =  video.height;
            this.frameRate = video.frameRate;
            this.duration = video.duration;
            this.numFrames = video.numFrames;
            this.numChannels = video.numChannels;
        end
        
        % Set video dimensions
        function this = setVideoReaderInfo(this, video)
            this.video = video;
            this.height = video.Width;
            this.width =  video.Height;
            this.frameRate = video.FrameRate;
            this.duration = video.Duration;
            this.numFrames = video.Duration*video.FrameRate;
            
            if strcmp(video.VideoFormat, 'Grayscale')
                this.numChannels = 1;
            else
                this.numChannels = 3;
            end
        end
        
        function add(this, method)
            this.method = [this.method, {method}];
            videoFeature = VideoIterator(method, this.numFrames);
            this.features = [this.features, {videoFeature}];
            this.numMethods = this.numMethods + 1;
        end
        
        function videoFeature = get(this, index)
            if nargin < 2
                index = 1;
            end
            videoFeature = this.features{index};
        end
        
      
        
        % Search for available feature extaction methods.
        function searchMethods(this, methodStr)
            index = strcmp(this.availableMethods, methodStr);
            if index == 0
                listAvailableMethods(this)
                return 
            end
        end    
        
        function showAvailableMethods(methodList)
            fprintf('Following feature extraction methods available: \n')
            for i = 1:length(methodList)
                fprintf('- %s \n', methodList{i} )
            end
        end
        
        function initVideoExtraction(this, video)
            setVideoDims(this, size(video));
            this.currentFrame = [];
            this.currentFrameIndex = 1;
        end
        
        function initExtractionMethods(this)
            msg = sprintf(['\nPerforming Extractions for '  this.video.Name '\n'] );
            fprintf(msg);

            for iFeature = 1:this.numMethods
                vidFeature = this.features{iFeature};
                msg = sprintf(['%d. ', vidFeature.methodName, '\n'], iFeature);
                fprintf(msg)
                reset(vidFeature);
            end
        end
        
        function Features = createFeatureOutput(this)
            Features = cell(this.numMethods,1);
            for iFeature = 1:this.numMethods
                Features{iFeature} = VideoFeature(this.features{iFeature}, this.numFrames);
            end
        end
        
        function resizeFrame(this, resizeRatio)
            if resizeRatio ~= 1
                this.isResized = true;
                this.resizeRatio = resizeRatio;
            end    
        end
        
        function frame = resize(this, frame)
            if this.imageResized == true
                frame = imresize(frame, this.resizeRatio);
            end
        end
        
        % Start the computation of the video feature extraction.
        function compute(this, video)
             if nargin > 1
                initVideo(this, video)
            end
            
            this.iFrame = 1;
            initExtractionMethods(this)
            
            while hasFrame(this.video)
                
                % Read frame and resize if resizeRatio ~= 1.
                frame = this.resize(readFrame(this.video));
                
                % Loop through all the feature extraction method for given
                % frame.
                for iFeature = 1:this.numMethods
                    % Select feature extraction method.
                    feature = get(this.features{iFeature});
                    % Compute the select feature for the current frame.
                    output = feature.compute(frame);
                    % Iterate the feature output into a video timeseries structure.
                    this.features{iFeature}.addFrame(output);
                end
                
                % Write status of frames processed in the command window.
                statusMessage(this);
                
                % Count and index the frames.
                this.iFrame = this.iFrame + 1;
            end
            
        end
        
        function statusMessage(this)
            if this.iFrame == 1
               this.messageStr = '';
            end
            
            if ~mod(this.iFrame,100) || (this.iFrame == 1) || this.iFrame == this.numFrames
                msg = sprintf('Processed %d/%d Frames', this.iFrame, this.numFrames);
                fprintf([this.messageStr, msg]);
                this.messageStr = repmat(sprintf('\b'), 1, length(msg));
            end
        end
        
        function reset(this)
            this.currentFrameIndex = [];
        end
        
    end
    
    methods (Static)
        % Compute temporal contrast on the sequence of two frames
        function tmpContrast = computeTemporalContrast(img1, img2)
            tmpContrast = img2-img1;
        end
        
        % Compute locally contrast boosted image via blurring
        function localContrast = computeLocalContrast(image, kern)
            % Check if the image is RGB
            if numel(size(image)) > 2; image = rgb2gray(image); end
            
            % Assign filter kernel size if undefined. 
            if nargin < 2
                [height, ~] = size(image);
                kern=ones(round(height/10));
            end
            
            bluuredGaussianFiltered = conv2(image,kern,'same');
            bluuredGaussianFiltered(isnan(bluuredGaussianFiltered)) = 0;
            localContrast = abs((image - bluuredGaussianFiltered) ./ bluuredGaussianFiltered);
        end
        
        % Compute temporal contrast on the entire video
        function tmpContrast = computeVideoTemporalContrast(video)
            if numel(size(video)) < 3
                videoGray = video;
            else
                videoGray = Extractor.rgbToGrayVideo(video);
            end
            [height,width, ~] = size(videoGray);
            tmpContrast = diff(videoGray,1,3);
            zeroPadgFirstFrame = zeros(height,width);
            tmpContrast = cat(3,zeroPadgFirstFrame, tmpContrast);
        end

        % Convert RGB video to Gray scale.
        function videoGray = rgbToGrayVideo(rgbVideo)
           [height, width, ~, numFrames] = size(rgbVideo);
           videoGray = zeros(height, width, numFrames);
            for iFrame = 1:numFrames
                frameRGB = rgbVideo(:,:,:,iFrame);
                frameGray = rgb2gray(frameRGB); 
                videoGray(:,:,iFrame) = frameGray;
            end
        end

        % Preview a frame. This can be used in a loop.
        function previewImage(frame, feature, fs)
            imshow(frame)
            plot(feature,'DecimationFactor',[5 5],'ScaleFactor',10)
            pause(1/fs)
        end
    end
    
end
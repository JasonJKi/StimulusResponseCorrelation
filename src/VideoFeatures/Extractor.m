classdef Extractor < handle
    %Extractor - 
    %   Detailed explanation goes here
    
    properties
        videoReader
        
        % Video dimension.
        height;
        width;
        numChannels;
        numFrames;
        frameRate;
        duration;
        videoFormat;
        
        videoFeatures = {};
        numfeatures = 0;
        resizeRatio = 1;
        
        iFrame = 1;
    end
    
    properties (Access = public, Constant)
        % Available feature extraction method info data
    end
        
    properties (Access = private)
        % Video method types
        currentFrameIndex = [];
        currentFrame = [];
        colonsForMultiDimIndex = [];
        
        imageResized = false;        
    end
    
    methods
        % Instantiate video feature extractor class 
        function this = Extractor()
            if nargin < 1
                return;
            end
        end
        
        function  this = setVideoReader(this, videoReader);
            setVideoInfo(this, videoReader)
        end
        
        % Set video dimensions
        function this = setVideoInfo(this, video)
            this.videoReader = video;
            this.height = video.Width;
            this.width =  video.Height;
            this.frameRate = video.FrameRate;
            this.duration = video.Duration;
            this.numFrames = video.Duration*video.FrameRate;
            this.videoFormat = video.VideoFormat;
        end
        
        function this = add(this, method)
            videoFeature = VideoIterator(method, this.numFrames);
            this.videoFeatures = [this.videoFeatures, {videoFeature}];
            this.numfeatures = this.numfeatures + 1;
        end
        
        function videoFeature = get(this, index)
            if nargin < 2
                index = 1;
            end
            videoFeature = this.videoFeatures{index};
        end
        
        function this = resizeImage(this,resizeRatio)
            if resizeRatio <= 0
                disp('Resize ratio cannot be 0 or a negative number')
                return
            end
            this.imageResized = true;
            this.resizeRatio = resizeRatio;
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
        
        function status = hasFrame(this)
            status = false;
            video = this.video;
            if this.currentFrameIndex > this.numFrames
                return
            end
            
            this.currentFrame = getVideoFrame(this, video);
            
            if this.imageResized 
                this.currentFrame = imresize(this.currentFrame, this.resizeRatio);
            end
            
            if ~isempty(this.currentFrame)
                status = true;
                this.currentFrameIndex = this.currentFrameIndex + 1;
            end
        end
        
        % Index a specific frame without using matlab's index convention
        function frame = getVideoFrame(this, video, frameIndex)
            if nargin < 3
                frameIndex =  this.currentFrameIndex;
            end
            % video - [width, height, ..., numFrame]
            % Colons for indexing multi-dimensional matlab array
            
            frame = squeeze(video(frameIndex, this.colonsForMultiDimIndex{:}));
        end
        
        function initVideoExtraction(this, video)
            setVideoDims(this, size(video));
            this.currentFrame = [];
            this.currentFrameIndex = 1;
        end
        
        function initExtractionMethods(this)
            for iFeature = 1:this.numfeatures
                reset(this.videoFeatures{iFeature});
            end
        end
        
        function Features = createFeatureOutput(this)
            Features = cell(this.numfeatures,1);
            for iFeature = 1:this.numfeatures
                Features{iFeature} = VideoFeature(this.videoFeatures{iFeature}, this.numFrames);
            end
        end
        
        function frame = readFrame(this, video)
            frame = readFrame(video);
            this.iFrame = this.iFrame + 1;
            
            if mod(this.iFrame, 100) == 0
                disp(this.iFrame)
            end
        end
        
        % Start the computation of the video feature extraction.
        function compute(this)
                        
            if ~isempty(this.videoReader);
                video = this.videoReader;
            else
                video = this;
            end
            
            while hasFrame(video)
                frame = readFrame(this, video);
                for iFeature = 1:this.numfeatures
                    feature = get(this.videoFeatures{iFeature});
                    output = feature.compute(frame);
                    this.videoFeatures{iFeature}.addFrame(output);
                end
                
            end
            
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
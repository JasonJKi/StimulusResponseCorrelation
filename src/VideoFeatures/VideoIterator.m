classdef VideoIterator < handle
   
    properties
        feature
        
        name
        param
        paramLabel
        numFeatures
        numFrames
        
        video
    end
    
    properties (Access = private, Hidden = true)
        frameIndex = 1
        featureFieldNames 
    end
        
    methods
        function feature = get(this)
            feature = this.feature;
        end

        function this = VideoIterator(feature, numFrames)
            this.feature = feature;
            this.name = feature.NAME;
            this.param = feature.param;
            this.numFeatures = feature.numOutputs;
            this.paramLabel = feature.paramLabel;
            this.numFrames = numFrames;
        end
        
        function addFrame(this, frame)
            if this.frameIndex == 1
                this.video = this.allocateOutputMemory(frame, this.numFrames);
            end    
            iFrame = this.frameIndex;
            for i = 1:this.numFeatures
                this.video(iFrame,i,:,:,:) = uint8(frame(:,:,i));
            end
            this.frameIndex = iFrame + 1;
        end
        
    end
    
    methods (Static = true)
        
        function output = allocateOutputMemory(input, numFrames)
            [height, width, numFeatures] = size(input);            
            output = zeros(numFrames, numFeatures, height, width,'single');
        end
        
    end
end
classdef VideoFeatureStuct < handle
   
    properties
        methodName
        methodParam
        methodParamName
        
        FeatureNames
        numFrames
        numFeatures
        Features
    end
    
    properties (Access = private, Hidden = true)
        frameIndex = 1
        featureFieldNames 
    end
        
    methods
        function this = VideoFeatureStuct(FeatureExtractionMethod, numFrames)
            this.numFrames = numFrames;
            this.methodName = FeatureExtractionMethod.methodName;
            this.methodParam = FeatureExtractionMethod.methodParam;
            this.methodParamName = FeatureExtractionMethod.methodParamName;
            this.featureFieldNames = fieldnames(FeatureExtractionMethod.OutputStruct);
            this.numFeatures = length(this.featureFieldNames);
        end
        
        function addFrame(this, inputFeatures)
            
            for iFeature = 1:numel(this.featureFieldNames)
                featureName = this.featureFieldNames{iFeature};
                if this.frameIndex == 1
                    this.FeatureNames{1,iFeature} = featureName;
                    initOutFeatureFields(this, inputFeatures, featureName, iFeature);
                end
                this.Features{iFeature}(this.frameIndex,:,:,:) = single(inputFeatures.(featureName));
            end
            this.frameIndex = this.frameIndex + 1;
            
        end
        
        function initOutFeatureFields(this, inFeature, featureName, iFeature)
            [height, width, numChannels] = size(inFeature.(featureName));
            this.Features{iFeature} = single(zeros(this.numFrames, height, width, numChannels));
        end
    end
end
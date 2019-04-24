classdef ImageIntensity < VisualSalienceFeature
    
    properties (Access = public)
        % Declared in VisualSalienceFeatures (super)
        %        params
        outputNames = {''};
    end
    
    properties (Access = private)
        
    end

    methods (Access = public)
        function this = ImageIntensity()
            this.methodName = 'image_intensity';
            init(this)
            initOutputStruct(this)
        end

        function init(this)
            this.weight = 1;
            this.numFeatureTypes = 1;
            this.methodParamName =  this.methodName;
        end

        function Features = estimate(this, image)
            intensity = rgbIntensity(image);
            Features.Intensity = intensity;
        end
        
        function initOutputStruct(this)
            this.OutputStruct.Intensity = [];
        end
        
        function reset(this)
        end
    end
    
    methods (Access = private)
      
    end
    
end
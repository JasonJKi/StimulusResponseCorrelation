classdef ImageContrast < VisualSalienceFeatures

    properties (Access = public)
% Declared in VisualSalienceFeatures (super)
%        params
        outputNames = {''};
    end
    properties (Access = private)
        contrastWidthWeight = .1;
    end

    methods (Access = public)
        function this = ImageContrast(contrastWidthWeight)
            if nargin < 1
                contrastWidthWeight = this.contrastWidthWeight;
            end
            this.methodName = 'contrast';
            init(this, contrastWidthWeight)
            initOutputStruct(this)
        end

        function init(this, contrastWidthWeight)
            this.weight = 1;
            this.numFeatureTypes = 1;
            this.methodParamName =  this.methodName;
            this.contrastWidthWeight = contrastWidthWeight;
        end

        function Features = estimate(this, image)
            img_height = round(size(image,1));
            image = double(image);
            image = rgbIntensity(image);
            contrastWidth = img_height * this.contrastWidthWeight;
            Features.Contrast = myContrast(image, contrastWidth);
        end
        
        function initOutputStruct(this)
            this.OutputStruct.Contrast = [];
        end
        
        function reset(this)
        end
    end
    
    methods (Access = private)
      
    end
    
end
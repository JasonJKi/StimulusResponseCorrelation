classdef TemporalContrast < FeatureExtractionMethod
    %OPTICFLOW Computes Optical Flow of Image for 
    properties (Access = public)
% declared in FeatureExtractionMethod (super)        
%         methodName 
%         methodParam
%         methodParamName
%         
%         OutputStruct;
        outputNames = {''};

    end
    
    properties (Access = private)
        imagePrev = [];
    end
    
    methods
        
        function this = TemporalContrast(methodParam)
            
            this.methodName = 'temporal_contrast';

            if nargin < 2
                methodParam = 'None';
            end
        
            init(this, methodParam);
            initOutputStruct(this)
           
        end

        function init(this, methodParam)
            this.methodParam = methodParam;
            this.methodParamName = this.methodName;
        end
            
        function Features = estimate(this, image)
            
            grayImage = convertToGrayImage(image);
            Features = computeTemporalContrast(this, grayImage);
            
        end
        
        function Features = computeTemporalContrast(this, imageCurrent)
            
            if isempty(this.imagePrev)
                [heigth, width] = size(imageCurrent);
                Features.contrast = zeros(heigth, width,'single');
            else
                Features.contrast = abs(imageCurrent - this.imagePrev);
            end
            
            this.imagePrev = imageCurrent;
        end
        
        function reset(this)
            this.imagePrev = [];
        end
       
    end
    
    methods (Access = private)
    
        function initOutputStruct(this)
            this.OutputStruct.contrast = [];
        end
        
    end
    
end

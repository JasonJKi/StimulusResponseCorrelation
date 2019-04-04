classdef Luminance < FeatureExtractionMethod
    %OPTICFLOW Computes Optical Flow of Two Image Sequence using the Vision Toolbox
    
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
        kernelSizeDefault = 2;
    end
    
    methods
        
        function this = Luminance(methodParam)
            
            this.methodName = 'luminance';

            if nargin < 2
                methodParam = this.kernelSizeDefault;
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
            Features.intensity = computeLocalContrast(this, grayImage);
            
        end       
        
         % Compute locally contrast boosted image via blurring
        function localContrast = computeLocalContrast(this, image)
            
            image = double(image);
            % Assign filter kernel size 
            kernSize = this.methodParam;           
            if this.methodParam < 3
                [height, ~] = size(image);
                kernSize=round(height/10);
            end
            kern=ones(kernSize);            
            
            bluuredGaussianFiltered = conv2(image,kern,'same');
            bluuredGaussianFiltered(isnan(bluuredGaussianFiltered)) = 0;
            localContrast = abs((image - bluuredGaussianFiltered) ./ bluuredGaussianFiltered);
        end
        
        function reset(this)
            this.methodParam = this.kernelSizeDefault;
        end
       
    end
    
    methods (Access = private)
    
        function initOutputStruct(this)
            this.OutputStruct.intensity = [];
        end
        
    end
    
end


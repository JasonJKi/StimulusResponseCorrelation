classdef Luminance < ImageFeature
    %OPTICFLOW Computes Optical Flow of Two Image Sequence using the Vision Toolbox
    
    properties (Access = public)
% declared in FeatureExtractionMethod (super)        
        name = [];
        
        params;
        paramsName = [];

        output;
        outputLabel = {''};
    end
    
    properties (Access = private)
        kernelSizeDefault = 2;
    end
    
    methods
        
        function this = Luminance(params)
            
            this.name = 'luminance';

            if nargin < 2
                params = this.kernelSizeDefault;
            end
        
            init(this, params);
            initoutput(this)
           
        end

        function init(this, params)
            this.params = params;
            this.paramsName = this.name;
        end
            
        function Features = estimate(this, image)
            
            grayImage = convertToGrayImage(image);
            Features.intensity = computeLocalContrast(this, grayImage);
            
        end       
        
         % Compute locally contrast boosted image via blurring
        function localContrast = computeLocalContrast(this, image)
            
            image = double(image);
            % Assign filter kernel size 
            kernSize = this.params;           
            if this.params < 3
                [height, ~] = size(image);
                kernSize=round(height/10);
            end
            kern=ones(kernSize);            
            
            bluuredGaussianFiltered = conv2(image,kern,'same');
            bluuredGaussianFiltered(isnan(bluuredGaussianFiltered)) = 0;
            localContrast = abs((image - bluuredGaussianFiltered) ./ bluuredGaussianFiltered);
        end
        
        function reset(this)
            this.params = this.kernelSizeDefault;
        end
       
    end
    
    methods (Access = private)
    
        function initoutput(this)
            this.output.intensity = [];
        end
        
    end
    
end


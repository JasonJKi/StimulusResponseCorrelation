classdef OpticalFlow < FeatureExtractionMethod
    %OPTICFLOW Computes Optical Flow of Image for 
    properties (Access = public)
% declared in FeatureExtractionMethod (super)        
%         methodName 
%         methodParam
%         methodParamName
%         
%         outputStruct;
        outputNames 
    end
    
    properties (Access = private)
        
        obsoleteVisionMethod = false;
        prevImage = [];
        
    end
    
    methods
        
        function this = OpticalFlow(methodParam)
            methodName = 'optical_flow';
            if nargin < 1
                methodParam = vision.OpticalFlow('ReferenceFrameSource','Input port');
                this.obsoleteVisionMethod = true;
                this.outputNames = {'magnitude'};

                postfix = '_vs_obsolete';
            else
                this.methodParamName = class(methodParam);
                this.outputNames = {'vx','vy','orientation','magnitude'};
                postfix= ['_' lower(this.methodParamName(12:end))];
            end
            this.methodName = [methodName postfix];
            init(this, methodParam);
            initOutputStruct(this)
            
        end

        function init(this, methodParam)
            this.methodParam = methodParam;
            this.prevImage = [];
        end
            
        function Features = estimate(this, image)

            grayImage = convertToGrayImage(image);
            
            if this.obsoleteVisionMethod
                Features = estimateFlowVisionToolBox(this, grayImage);
            else
                Features = estimateFlow(this.methodParam, grayImage);
            end
            
        end
        
        
        function Features = estimateFlowVisionToolBox(this, imageCurrent)
            
            if isempty(this.prevImage)
                [heigth, width] = size(imageCurrent);
                Features.magnitude = zeros(heigth, width,'single');
            else
                Features.magnitude = step(this.methodParam, double(this.prevImage), double(imageCurrent));
            end
            
            this.prevImage = imageCurrent;
            
        end
        
        function reset(this)
            this.prevImage = [];
            this.methodParam.reset()
        end
       
    end
    
    methods (Access = private)
    
        function initOutputStruct(this)
            if ~this.obsoleteVisionMethod
                this.OutputStruct = estimateFlow(this.methodParam, []);
            else
                this.OutputStruct.magnitude = [];
            end
        end
        
    end
    
end


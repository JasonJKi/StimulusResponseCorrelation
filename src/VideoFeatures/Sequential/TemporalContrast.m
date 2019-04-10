classdef TemporalContrast < SequentialFeature
    %TemporalContrast Computes pixel difference of frames
    
    properties (Constant)
        NAME = 'temporal_contrast'
    end

    properties (Access = public)
    % Declared in super class SequentialFeature  
    %    img
    %    imgPrev
    
    %    params;
    %    paramsLabel;
    % 
    %    output;
    %    outputLabel;
    end
    
    properties (Access = private)
        imagePrev = [];
    end
    
    methods
        
        function this = TemporalContrast(param)
            setDefaultParam(this)
            if (nargin > 1)
                init(this, param)
            end
        end
        
        function init(this, param)
            this.param = param;
        end
        
        function setDefaultParam(this)
            this.param = [];
            this.paramLabel = [];
            this.numOutputs = 1;
        end
        
        function output = compute(this, img)
            setInitImage(this, img)
            img0 = this.imgPrev;
            img1 = convertToGrayImage(img);

            output = this.temporalContrast(img1, img0);
            setOutput(this, output);
            setPrevImage(this, img1);
        end
       
        function reset(this)
            this.imagePrev = [];
        end
        
       
    end
    
    methods (Static = true)
        
        function output = temporalContrast(img1, img0)
            output = abs(img1 - img0);
        end
        
    end
    
    methods (Access = private)
    
        function initOutputStruct(this)
            this.OutputStruct.contrast = [];
        end
        
    end
    
end
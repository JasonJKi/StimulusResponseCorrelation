classdef SequentialFeature < handle
    %FEATUREMETHODS Summary of this class goes here
    %   Detailed explanation goes here
    properties (Abstract, Constant)
        NAME
    end

    properties (Access = public)
        isReset = true
        
        image
        imagePrev = [];
        param
        paramLabel

        output
        outputLabel
        
        numOutputs
        method
        methodName
    end
    
    methods (Abstract)
        init(this, param)
        setDefaultParam(this)
        output = compute(this, img1, img0)
    end
    
    methods 
        function this = SequentialFeature()
        end
                
        function setInput(this, img1, img0)
            this.imgPrev = img1;
            this.image = img0;
        end
        
        function [img0, img1] = getInput(this)
            img0 = this.imagePrev;
            img1 = this.image;
        end
        
        function setInitImage(this, image)
            if this.isReset
                [heigth, width, numChannel] = size(image);
                this.imagePrev = zeros(heigth, width, 'uint8');
                this.isReset = false;
            end
        end
        
        function setPrevImage(this, image)            
            this.imagePrev = image;
        end
        
        function setOutput(this, output)
            this.output = output;
        end
        
        function output = getOutput(this)
            output = this.output;
        end
        
        function setParam(this, param)
            this.param = param;
        end
        
        function param = getParam(this)
            param = this.param;
        end
        
        function reset(this)
            this.imagePrev = [];
        end
        
    end
    
    
end


classdef SequentialFeature < handle
    %FEATUREMETHODS Summary of this class goes here
    %   Detailed explanation goes here
    properties (Abstract, Constant)
        NAME
    end

    properties (Access = public)
        isReset = true
        
        img
        imgPrev
        
        param
        paramLabel

        output
        outputLabel
        
        numOutputs
        method = 'None';
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
            this.img = img0;
        end
        
        function [img0, img1] = getInput(this)
            img0 = this.imgPrev;
            img1 = this.img;
        end
        
        function setInitImage(this, img)
            if this.isReset
                [heigth, width, numChannel] = size(img);
                this.imgPrev = zeros(heigth, width, 'uint8');
                this.isReset = false;
            end
        end
        
        function setPrevImage(this, img)            
            this.imgPrev = img;
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
            setDefaultParam(this);
            setInput(this, [], []);
            
            this.output = [];
            this.outputLabel = [];
        end
    end
    
    
end


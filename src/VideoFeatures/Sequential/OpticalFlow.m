classdef OpticalFlow < SequentialFeature
    %OpticalFlow Computes pixel difference of frames
    
    properties (Constant)
        NAME = 'optical_flow'
    end

    properties (Access = public)
    % declared in super class SequentialFeature  
    %    img
    %    imgPrev
    
    %    params;
    %    paramsLabel;
    % 
    %    output;
    %    outputLabel;
    %    numOutputs;
    end
    
    properties (Access = private)
        imagePrev = [];
    end
    
    methods
        
        function this = OpticalFlow(param)
            setDefaultParam(this)
            if nargin > 1
                init(this, param)
            end
        end
        
        function init(this, param)
            this.param = param;
            this.method = param;
            this.paramLabel = fieldnames(this.method);
        end
        
        function setDefaultParam(this)
            this.method = opticalFlowHS;
            this.paramLabel = fieldnames(this.method);
            this.numOutputs = 4;
        end
        
        function output = compute(this, img)
            setInitImage(this, img)
            img1 = convertToGrayImage(img);

            output = estimateFlow(this.method, img1); 
            output = convertOpticFlowOutput(this, output);
            this.setPrevImage(img1)
        end
       
        function reset(this)
            this.imagePrev = [];
        end
        
         function output = convertOpticFlowOutput(this, input)
            this.outputLabel = fieldnames(input);
            for iFeature = 1:numel(this.outputLabel)
                featureName = this.outputLabel{iFeature};
                output(:,:,iFeature) = single(input.(featureName));
            end     
        end
        
       
    end
    
    methods (Static, Access = private)
    
       
        
    end
    
end

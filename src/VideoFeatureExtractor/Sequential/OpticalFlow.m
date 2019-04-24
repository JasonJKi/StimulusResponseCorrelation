classdef OpticalFlow < SequentialFeature
    %OpticalFlow Computes pixel difference of frames
    
    properties (Constant)
        NAME = 'opticalFlow';
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
            init(this, param)
        end
        
        function init(this, method)
            this.method = method;
            this.methodName = ['opticFlow' class(method)];
            this.paramLabel = fieldnames(this.method);
            this.numOutputs = 4;
        end
        
        function setDefaultParam(this)
            this.method = opticalFlowHS;
            this.methodName = ['opticFlow' class(this.method)];
            this.paramLabel = fieldnames(this.method);
            this.numOutputs = 4;
        end
        
        function output = compute(this, img)
            setInitImage(this, img)
            img1 = convertToGrayImage(img);

            flow = estimateFlow(this.method, img1); 
            output = convertOpticFlowOutput(this, flow);
            this.setPrevImage(img1)
        end
        
        function reset(this)
            this.imagePrev = [];
        end
        
        function output = convertOpticFlowOutput(this, flow)
            vx = flow.Vx;
            vy = flow.Vy;
            theta = flow.Orientation;
            magnitude = flow.Magnitude;
            output(:,:,1) = single(vx);
            output(:,:,2) = single(vy);
            output(:,:,3) = single(theta);
            output(:,:,4) = single(magnitude);
            this.output = output;
        end
        
        function flow = getFlow(this)
            if isempty(this.output)
                flow =estimateFlow();
                return
            end
            vx = this.output(:,:,1);
            vy = this.output(:,:,2);
            flow = opticalFlow(vx, vy);
        end
       
        
    end
    
    methods (Static, Access = private)
    
       
        
    end
    
end

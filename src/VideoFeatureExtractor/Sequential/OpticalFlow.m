classdef OpticalFlow < SequentialFeature
    %OpticalFlow Computes pixel difference of frames
    
    properties (Constant)
        NAME = 'opticalFlow';
    end

    properties (Access = public)
    end
    
    properties (Access = private)
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
            this.outputLabel = {'vx', 'vy', 'theta', 'magnitude'};
        end
        
        function output = compute(this, img)
            setInitImage(this, img)
            
            img1 = convertToGrayImage(img);

            flow = estimateFlow(this.method, img1); 
            
            output = getOutput(this, flow);
            
            this.setPrevImage(img1)
        end
                
        function output = getOutput(this, computedValue)
            output = convertOpticFlowOutput(this, computedValue);
        end
        
        function output = convertOpticFlowOutput(this, flow)
%             vx = flow.Vx;
%             vy = flow.Vy;
            output = flow.Magnitude;
            
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

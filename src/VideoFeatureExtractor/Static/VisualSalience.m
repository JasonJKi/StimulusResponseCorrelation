classdef VisualSalience < StaticFeature
    %VISUALSALIENCE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Constant)
        NAME = 'GBVS';
    end

    properties (Access = private)

    end
    
    properties (Access = private)    
    end
    
    methods
        
        function this = VisualSalience()
            setDefaultParam(this)
            init(this, this.method);
        end
        
        function setDefaultParam(this)
           this.method = makeGBVSParams();
        end
        
        function init(this, method)
            this.numOutputs = 1;
            this.outputLabel = 'gbvs';
            this.methodName = this.NAME;
        end
        
        function output = compute(this, image)
            minLength = 128;
            image = resizeImageToMinLength(image, minLength);
            [gbvsMaps, ~]= gbvs(image, this.method);
            output = gbvsMaps.master_map_resized;
        end
        
        function reset(this)
            this.prevMotionInfo = [];
        end
        

    end
    
    methods (Access = private)
        
        
       
        
    end
    
end


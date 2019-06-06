classdef TemporalContrast < SequentialFeature
    %TemporalContrast Computes pixel difference of frames
    
    properties (Constant)
        NAME = 'temporalContrast';
    end

    properties (Access = public)
    end
    
    properties (Access = private)
    end
    
    methods
        
        function this = TemporalContrast()
            init(this)
        end
        
        function init(this)
            setDefaultParam(this)
        end
        
        function setDefaultParam(this)
            this.param = [];
            this.paramLabel = [];
            this.method = this;
            this.methodName = this.NAME;
            this.numOutputs = 1;
            this.outputLabel = 'temporalContrast';
        end
        
        function output = compute(this, image)
            setInitImage(this, image)
            image0 = this.imagePrev;
            image1 = convertToGrayImage(image);

            output = this.temporalContrast(image1, image0);
            setOutput(this, output);
            setPrevImage(this, image1);
        end
       
        function reset(this)
            this.imagePrev = [];
        end
        
       
    end
    
    methods (Static = true)
        
        function output = temporalContrast(image1, image0)
            output = abs(image1 - image0);
        end
        
    end
    
    methods (Access = private)
    
        function initOutputStruct(this)
            this.OutputStruct.contrast = [];
        end
        
    end
    
end
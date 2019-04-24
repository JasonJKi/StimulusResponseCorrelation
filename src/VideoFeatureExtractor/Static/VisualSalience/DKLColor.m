classdef DKLColor < VisualSalienceFeature
    % CHROMATIC MECHANISMS IN LATERAL 
    % GENICULATE NUCLEUS OF MACAQUE 
    % BY A. M. DERRINGTON, J. KRAUSKOPF AND P. LENNIE
    properties (Access = public)
        % Declared in VisualSalienceFeatures (super)
        %        params
        outputNames = {''};

    end
    properties (Access = private)
        
    end

    methods (Access = public)
        function this = DKLColor()
            this.methodName = 'dkl_color';
            init(this)
            initOutputStruct(this)
        end

        function init(this)
            this.weight = 1;
            this.numFeatureTypes = 3;
            this.description = {
                'DKL Luminosity Channel', ...
                'DKL Color Channel 1', ... 
                'DKL Color Channel 2'...
                };
            this.methodParamName = this.methodName;
        end

        function Features = estimate(this, image)
            image = double(image);
            DKL = rgb2dkl(image);
            Features.DKL = DKL;
        end
        
        function reset(this)
        end
        
        function initOutputStruct(this)
            this.OutputStruct.DKL = [];
        end
        
    end
    
    methods (Access = private)
        
    end

end

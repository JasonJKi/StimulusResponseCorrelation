classdef (Abstract) VisualSalienceFeatures < FeatureExtractionMethod
    
    properties (Access = public)
        weight = 1
        feature
        description
        numFeatureTypes
    end

    methods (Abstract)
        init(this, param)
        reset(this)
        initOutputStruct(this)
    end
end

classdef (Abstract) FeatureExtractionMethod < handle
    %FEATUREMETHODS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access = public)
        
        methodName = [];
        methodParam = [];
        methodParamName = [];

        OutputStruct;
    end
    
    properties (Access = private)
        privateVar
    end
    
    methods (Abstract)
        
        Features = estimate(this,params)
        reset(this)
        
    end
    
    methods (Access = private)
        
        init(this, methodObj)
        initOutputStruct(this)

    end
    
end


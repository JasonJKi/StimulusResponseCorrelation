classdef (Abstract) ImageFeature < handle
    %FEATUREMETHODS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access = public)
        name;
        input;
        
        params;
        paramsLabel;

        output;
        outputLabel;
    end
    
    properties (Access = private)
    
    end
    
    methods (Abstract)
    
        setInput(this, img)
        getInput(this)
        
        setOutput(this, img)
        getOutput(this)
        
        setParams(this, params)
        getParams(this)
        
        output = compute(this);
        reset(this);
    end
    
    methods (Access = private)
        
        init(this);
        initoutput(this);
        
    end
    
end


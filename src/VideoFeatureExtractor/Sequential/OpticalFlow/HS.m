classdef HS < opticalFlowHS
    %FARNEBACK Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
    end
    
    methods
        function this = HS()
            this.Smoothness = 1;
            this.MaxIteration = 10;
            this.VelocityDifference = 0;
        end
        
    end
end  


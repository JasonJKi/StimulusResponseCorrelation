classdef Farneback < opticalFlowFarneback
    %FARNEBACK Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
    end
    
    methods
        function this = Farneback()
            this.NumPyramidLevels = 3;
            this.PyramidScale = 0.5;
            this.NumIterations =  3;
            this.NeighborhoodSize = 5;
            this.FilterSize = 15;
        end
        
    end
end


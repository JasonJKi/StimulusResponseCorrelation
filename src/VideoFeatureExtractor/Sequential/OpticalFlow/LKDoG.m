classdef LKDoG < opticalFlowLKDoG
    %FARNEBACK Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
    end
    
    methods
        function this = LKDoG()
          this.NumFrames = 3;
          this.ImageFilterSigma =  1.5;
          this.GradientFilterSigma = 1;
          this.NoiseThreshold = 0.0039;
        end
        
    end
end

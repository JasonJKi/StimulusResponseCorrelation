classdef EEGPreProcessor < handle
    %EEGPREPROCESSOR Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        addedMethods = {}
        
        numChannels
        eegChannels
        eogChannels 
    end

    properties (Access = private)
        numAddedMethods = 0;
        virtualEOG
        colonsForMultiDimIndex = [];
    end
    
    
    methods
        function this = EEGPreProcessor(params)
            if nargin < 1
                return;
            end
            setParams(params)
        end
        
        function add(this, method)
            this.addedMethods = [this.addedMethods, {method}];
        end        
        
        function compute(this, eeg)
            this.addedMethods = [this.addedMethods, {method}];
            for iFeature = 1:this.numAddedMethods
                output = this.addedMethods{iFeature};
            end
        end
        
        function useVirtualEOG(this)
            this.virtualEOG=zeros(this.numChannels,4);
            this.virtualEOG([1 34],1)=1;
            this.virtualEOG([2 35],2)=1;
            this.virtualEOG(1,3)=1;
            this.virtualEOG(2,3)=-1;
            this.virtualEOG(33,4)=1;
            this.virtualEOG(36,4)=-1;
        end
        
        function setParams(params)
            this.numSensors
            this.eegChannels
            this.eogChannels 
        end
        
    end
    

end


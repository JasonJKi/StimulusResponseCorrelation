classdef Dataset < handle
    %DATASET Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        timeseries = struct()
        dataFieldname;
        numfeatures
        
        iter = 1;
        numSamples
    end
    
    methods
        function this = Dataset(extractor)
            initDataset(this, extractor)
            
        end
        
        function initDataset(this, extractor)
            for i = 1:extractor.numMethods
                fieldname = extractor.method{i}.methodName;
                this.timeseries.(fieldname) = {};
                this.dataFieldname{i} = fieldname;
            end
        end
        
        function this = add(this, extractor)
            for i = 1:extractor.numMethods
                fieldName = this.dataFieldname{i};
                feature = extractor.get(i);
                this.timeseries(this.iter).(fieldName) = feature.data;
            end
            this.iter = this.iter + 1;
        end
        
    end
end


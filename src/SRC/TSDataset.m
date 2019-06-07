classdef TSDataset < handle
    %TSDATASET - Input pipeline of time series dataset 
    %   Detailed explanation goes here
    
    properties
        timeseries = struct();        
        numSamples = 0;
        outputDir;
    end
    
    properties (Access = private)
        iter = 1;
    end
    
    methods
        function this = TSDataset(input)
            if isa(input, 'VideoFeatureExtractor')
                initVFEDataset(this, input)
            end
        end
        
        function initVFEDataset(this, extractor)
            for i = 1:extractor.numMethods
                fieldname = extractor.get(i).methodName;
                outputlabel = extractor.get(i).outputLabel;
                add(this, [], fieldname, extractor.frameRate, outputlabel, 'videoFeatures')
            end
        end
        
        function addFromVFExtractor(this, extractor)
            for i = 1:extractor.numMethods
                feature = extractor.get(i);
                data = shiftdim(feature.data,  ndims(feature.data)-1);
                fieldname = extractor.get(i).methodName;
                outputLabel = extractor.get(i).outputLabel;
                add(this, data, fieldname, extractor.frameRate, outputLabel, 'videoFeatures')
            end
        end
        
        function add(this, data, fieldname, fs, outputlabel, fileType)
            this.timeseries(this.iter).(fieldname).data = data;
            this.timeseries(this.iter).(fieldname).fs = fs;
            this.timeseries(this.iter).(fieldname).length = size(data,1);
            
            if nargin < 5
                outputlabel = fieldname;
            end
            
            if nargin < 6
                fileType = fieldname;
            end

            
            this.timeseries(this.iter).(fieldname).outputlabel = outputlabel;
            this.timeseries(this.iter).(fieldname).fileType = fileType;
        end
        
        function setName(this, filename)
            this.timeseries(this.iter).filename = filename;
        end
        
        function filename = getName(this, iter)
            if nargin < 2
                iter = this.iter;
            end
            filename = this.timeseries(iter).filename;
        end
        
        function next(this, iter)
            if nargin > 1
                this.iter = iter + 1;
                this.numSamples = iter;
                return
            end
            this.iter = this.iter + 1;
            this.numSamples = this.numSamples + 1;
        end
        
        function save(this, filename, index)
            if nargin < 2
                filename = getName(this, this.iter);
            end
            
            if nargin < 3
                index = this.iter;
            end
            
            data = this.timeseries(index);
            save([this.outputDir filename '_features'], '-struct', 'data'), 
        end
    end
end


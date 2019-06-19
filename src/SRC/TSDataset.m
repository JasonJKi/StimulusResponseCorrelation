classdef TSDataset < handle
    %TSDATASET - Input pipeline of time series dataset 
    %   Detailed explanation goes here
    
    properties
        data = struct(); 
        filenames = {};
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
                add(this, [], fieldname, extractor.frameRate, outputlabel)
            end
        end
        
        function addFromVFExtractor(this, extractor)
            for i = 1:extractor.numMethods
                feature = extractor.get(i);
                data = shiftdim(feature.data,  ndims(feature.data)-1);
                fieldname = extractor.get(i).methodName;
                outputLabel = extractor.get(i).outputLabel;
                add(this, data, fieldname, extractor.frameRate, outputLabel)
            end
        end
        
        function add(this, data, fieldname, fs, outputlabel)
            this.data(this.iter).(fieldname).timeseries = data;
            this.data(this.iter).(fieldname).fs = fs;
            this.data(this.iter).(fieldname).shape = size(data);
            
            if nargin < 5
                outputlabel = fieldname;
            end

            this.data(this.iter).(fieldname).outputlabel = outputlabel;            
        end
        
        
        function setFilename(this, filename)
            this.filenames{this.iter} = filename;            
        end
        
        function filename = getName(this, iter)
            if nargin < 2
                iter = this.iter;
            end
            filename = this.timeseries(iter).filename;
        end
        
        function next(this, iter)
            if nargin > 1
                this.numSamples = iter;
                this.iter = iter + 1;
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
        
        function X = videoTRF(this,fieldname,fs)
            for i = 1:length(this.data)
                x = this.data(i).(fieldname).timeseries;
                for ii = 1:size(x, 4)
                    X{i,ii} = videoTRF(x(:,:,:,ii), fs);
                end
            end
        end
        
        function X = toCell(this, fieldname)
            for i = 1:length(this.data)
                x = this.data(i).(fieldname).timeseries;
                X{i,1} = x;
            end
        end
        
    end
end


classdef ImageOrientation < VisualSalienceFeatures
    
    properties (Access = public)
% Declared in VisualSalienceFeatures (super)
        GaborParams
        outputNames = {''};
    end
    properties (Access = private)
        
    end

   
    methods (Access = public)
        function this = ImageOrientation(orientationAngles)
            this.methodName = 'image_orientation';
            init(this, orientationAngles)
            initOutputStruct(this)
        end

        function init(this, orientationAngles)
            this.numFeatureTypes = length(orientationAngles);
            initGaborParams(this)
            this.methodParam.GaborFilters = this.createGaborFilters(orientationAngles, this.GaborParams);
            this.methodParamName = this.methodName;
        end

        function Features = estimate(this, image)
            image = rgbIntensity(image);
            gaborFilters = this.methodParam.GaborFilters;
            
            [width, height, ~] = size(image);
            numGabors = length(gaborFilters);
            FilteredImage = zeros(width, height, numGabors);
            for i = 1:numGabors
                f0 = myconv2(image, gaborFilters{i}.g0);
                f90 = myconv2(image, gaborFilters{i}.g90);
                phaseSum = abs(f0) + abs(f90);
                FilteredImage(:,:,i) = attenuateBordersGBVS(phaseSum,13);
            end
            Features.gaborFiltered = FilteredImage;
        end
        
        function initGaborParams(this)
            this.GaborParams.stddev = 2;
            this.GaborParams.elongation = 2;
            this.GaborParams.filterSize = -1;
            this.GaborParams.filterPeriod = pi;
        end
        
        function reset(this)
        end
        
        function initOutputStruct(this)
            this.OutputStruct.gaborFiltered = [];
        end
    end
    
    methods (Access = private)
        
        
        
    end
    
    methods (Static)
        
        function [GaborFilters] = createGaborFilters(orientationAngles, GaborParams)
            % Create Gabor Filters
            GaborFilters = struct([]);
            for i = 1 : length(orientationAngles)
                theta = orientationAngles(i);
                GaborFilters{i}.g0 = makeGaborFilterGBVS(GaborParams, theta, 0);
                GaborFilters{i}.g90 = makeGaborFilterGBVS(GaborParams, theta, 90);
            end
        end
        
    end

end

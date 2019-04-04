classdef ImageMotion < VisualSalienceFeatures
    
    properties (Access = public)
        % Declared in VisualSalienceFeatures (super)
        %        params
        outputNames = {''};
    end
    
    properties (Access = private)
        prevImage = [];
        prevImageShift =[];
        orientationAngles
    end

    methods (Access = public)
        function this = ImageMotion(orientationAngles)
            this.methodName = 'image_motion';
            init(this, orientationAngles)
            initOutputStruct(this)
        end

        function init(this, orientationAngles)
            this.orientationAngles = orientationAngles;
            this.numFeatureTypes = length(orientationAngles);
            this.methodParamName = this.methodName;
        end
        
        function Features = estimate(this, image)
            
            
            intensity = double(rgbIntensity(image));
            numAngles = length(this.orientationAngles);
            
            if isempty(this.prevImage)
                [height, width] = size(intensity);
                this.prevImage = zeros(height,width);
                this.prevImageShift = zeros(height,width,numAngles);
            end
                 
            for i = 1:numAngles
                motionDirection = this.orientationAngles(i);
                imageShift(:,:,i) = this.shiftImage(intensity, motionDirection);
                prevShift = this.prevImageShift(:,:,i);
                prevImg = this.prevImage;
                map(:,:,i) = abs(intensity .* prevShift - prevImg .* imageShift(:,:,i));
            end
%             Features.ImageShift = imageShift;
            Features.Map = map;
            
            this.prevImage = intensity;
            this.prevImageShift = imageShift;
        end
        
        function initOutputStruct(this)
            this.OutputStruct.Map = [];
%             this.OutputStruct.ImageShift = [];

        end
        
        function reset(this)
            this.prevImage = [];
            this.prevImageShift = [];
        end
    end
    
    methods (Access = private)
    end
    
    methods (Static)
        function imgShift = shiftImage( img , theta )
            
            Worig = size(img,2);
            Horig = size(img,1);
            
            pad = 2;
            imgpad = padImage(img,pad);
            
            W = size(imgpad,2);
            H = size(imgpad,1);
            xi = repmat((1:W) , [H 1]);
            yi = repmat((1:H)', [1 W]);
            
            dx = cos(theta * pi / 180 );
            dy = -sin(theta * pi / 180);
            imgpadshift = interp2(xi , yi , imgpad , xi + dx , yi + dy);
            
            imgShift = imgpadshift(pad + 1:pad + Horig , pad + 1:pad + Worig);
        end
    end
    
        
    
end
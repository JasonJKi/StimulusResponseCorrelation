classdef DirectionalMotion < SequentialFeature
    
    properties (Constant)
        NAME = 'DirectionalMotion';
    end

    properties (Access = public)

    end
    
    properties (Access = private)
        shiftPrev = [];
        orientationAngles = [];   
    end
    
    properties (Access = private)

    end

    methods (Access = public)
        
        function this = DirectionalMotion(orientationAngles)
            setDefaultParam(this);
            
            if nargin > 0               
                return
            end
            
            init(this, orientationAngles);
        end
        
        function init(this, orientationAngles)
            this.numOutputs = length(orientationAngles);
            this.orientationAngles = orientationAngles;
            this.outputLabel = num2cell(num2str(orientationAngles'))';
        end
        
        function setDefaultParam(this)
            this.orientationAngles = [0 45 90 135];
            this.method = this;
            this.methodName = this.NAME;
            this.numOutputs = length(this.orientationAngles);
        end

        function setPrevImage(this, image)
            setInitImage(this, image);
            [height, width] = size(image);
            if isempty(this.shiftPrev)
                this.shiftPrev = zeros(height, width, this.numOutputs, 'uint8');
            end
        end

        function output = compute(this, image)
            image = double(rgbIntensity(image));
            setPrevImage(this, image)
            prevImg = double(this.imagePrev);
            prevShift = double(this.shiftPrev);
            
            map = [];
            for i = 1:this.numOutputs
                angle = this.orientationAngles(i);
                imageShift(:,:,i) = this.shiftImage(image, angle);
                map(:,:,i) = abs(image .* prevShift(:,:,i) - prevImg .* imageShift(:,:,i));
            end
            
            output = map;
            this.shiftPrev = imageShift;            
            this.setPrevImage(image)            
        end
        
        function initOutputStruct(this)
            this.OutputStruct.Map = [];
            %             this.OutputStruct.ImageShift = [];

        end
        
        function reset(this)
            this.imagePrev = [];
            this.imageShift = [];
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
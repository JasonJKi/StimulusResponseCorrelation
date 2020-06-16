classdef VTdeprecated < handle
    % The deprecated vision toolbox method for opticalflow using the
    % step function.
    
    properties
        prevFrame;
        iFrame = 1;
        opticFlowModel;
    end
    
    methods
        function this = VTdeprecated()
            this.opticFlowModel = vision.OpticalFlow('ReferenceFrameSource','Input port');
%             this.opticFlowModel.OutputValue = 'Horizontal and vertical components in complex form';
        end
        
        function frame = estimateFlow(this,img)
            [height, width] = size(img);
            
            if this.iFrame > 1
                img1=single(this.prevFrame);
                img2=single(img);
            else
                img1 = zeros(height,width,'single');
                img2 = zeros(height,width,'single');
            end

            z = step(this.opticFlowModel,img2,img1);

%             frame.Vx = real(z);
%             frame.Vy = imag(z);
%             frame.Orientation = angle(z);
             frame.Magnitude = z;
            this.prevFrame = img;
            %frame_ = opticFlowVTDeprecated(this.prevFrame,img);
            this.iFrame = this.iFrame + 1;
        end
        
        function reset(this)
            this.iFrame = 1;
        end
        
        function [frame] = opticFlowVTDeprecated(img1,img2)
            %OPTICFLOW Summary of this function goes here
            %   Detailed explanation goes here
            warning('off','all')
            opticFlowModel = vision.OpticalFlow('ReferenceFrameSource','Input port');
            
            % optical flow
            frame = step(opticFlowModel,double(img2),double(img1));
        end



    end
end

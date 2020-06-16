function [frame] = opticFlowVTDeprecated(img1,img2)
%OPTICFLOW Summary of this function goes here
%   Detailed explanation goes here
warning('off','all')
opticFlowModel = vision.OpticalFlow('ReferenceFrameSource','Input port');

% optical flow
frame = step(opticFlowModel,double(img2),double(img1));
end


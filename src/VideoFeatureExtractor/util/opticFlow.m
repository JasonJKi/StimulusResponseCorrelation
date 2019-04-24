function [frame] = opticFlow(img1,img2,i)
%OPTICFLOW Summary of this function goes here
%   Detailed explanation goes here
warning('off','all')
opticFlowModel = vision.OpticalFlow('ReferenceFrameSource','Input port');
% optical flow
frame = step(opticFlowModel,img2,img1);
end


function [imgPooled] = pooling(img,kernel,method,poolIndx)
%maxpool [imgPooled] = pooling(img,kernel,method, poolIdx)    
% Check image size and set kernel size accordingly.
[height, width, nChannels] = size(img);
if nargin < 2
    kernel = round(height*.01);
end

if nargin < 3 || ~isa(method,'function_handle')
   method = @max;
end

if nargin < 4
    [h, w] = poolSize(height,width,kernel);
    poolIndx = kron(reshape(1:(height*width/(kernel^2)),width/kernel,[])',ones(kernel));
    videoFeature = zeros(h, w, nFrames, dataType);
end

%   Detailed explanation goes here
imgPooled = zeros(round(height/kernel),round(width/kernel),'uint8');
accumulatedArray = accumarray(poolIndx(:),img(:),[],method);
imgPooled = reshape(accumulatedArray, width/kernel, []).';


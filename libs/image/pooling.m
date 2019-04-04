function [imgPooled] = pooling(img,kernel,method,poolIdx)
%maxpool [imgPooled] = pooling(img,kernel,method)

[height, width, nChannels] = size(img);
if nargin < 2
    kernel = round(height*.01);
end

if nargin < 3 || ~isa(method,'function_handle')
   method = @max;
end

if nargin < 4
    disp('create pool index')
    return
end

%   Detailed explanation goes here

imgPooled = zeros(round(height/kernel),round(width/kernel),nChannels,'uint8');
for i = 1:nChannels
    imgPooled(:,:,i) = reshape(accumarray(poolIdx(:),img(:),[],method),width/kernel,[]).';
end


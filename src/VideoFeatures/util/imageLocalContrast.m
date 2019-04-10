function localContrast = imageLocalContrast(img,kern)    

[height, width] = size(video);
if nargin < 2
    kern=ones(round(height/10));
end

img = single(img);
bg = single(conv2(img,kern,'same'));
bg(isnan(bg)) = 0;
localContrast = abs((img - bg) ./ bg);
end
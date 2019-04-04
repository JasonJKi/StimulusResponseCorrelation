function image = resizeImageToMinLength(image, minLength)
[height, width]  = size(image);
if (height < minLength || width < minLength)
    resizeRatioHeight = (minLength/height);
    resizeRatioWidth = (minLength/width);
    resizeRatio = resizeRatioHeight;
    if resizeRatioWidth > resizeRatioHeight
        resizeRatio = resizeRatioWidth;
    end
    image = imresize(image,resizeRatio);
end
end
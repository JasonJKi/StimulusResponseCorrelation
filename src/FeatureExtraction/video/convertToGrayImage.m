function image = convertToGrayImage(image)
if numel(size(image)) > 2
    image = rgb2gray(image);
end
end
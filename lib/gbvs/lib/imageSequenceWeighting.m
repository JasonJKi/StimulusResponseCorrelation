function weightedImage = imageSequenceWeighting(image, previousImage, weight)
w = weight;
weightedImage =  w * image + ( 1 - w ) * previousImage;
end
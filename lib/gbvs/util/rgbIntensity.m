function l = rgbIntensity(img)
l = img;
isColor = (size(img,3) == 3);
if isColor
    r = img(:,:,1);
    g = img(:,:,2);
    b = img(:,:,3);
    l = max(max(r,g),b);
end



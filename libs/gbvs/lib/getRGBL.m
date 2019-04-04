function [rgbl] = getRGBL( img )
isColor = (size(img,3) == 3);
if ~isColor
    disp('Input not RGB image')
    rgbl = [];
    return
end
l = rgbIntensity(img);
rgbl = cat(3,img,l);
end

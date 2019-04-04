function [h, w] = poolSize(height,width,kernel)
h = round(height/kernel);
w = round(width/kernel);


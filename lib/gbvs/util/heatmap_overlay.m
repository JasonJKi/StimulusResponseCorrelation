
% img = image on which to overlay heatmap
% heatmap = the heatmap
% (optional) colorfunc .. this can be 'jet' , or 'hot' , or 'flag'

function omap = heatmap_overlay( img , heatmap, colorfun )

if ( strcmp(class(img),'char') == 1 ) img = imread(img); end
if ( strcmp(class(img),'uint8') == 1 ) img = double(img)/255; end

szh = size(heatmap);
szi = size(img);

if ( (szh(1)~=szi(1)) | (szh(2)~=szi(2)) )
  heatmap = imresize( heatmap , [ szi(1) szi(2) ] , 'bicubic' );
end
  
if ( size(img,3) == 1 )
  img = repmat(img,[1 1 3]);
end
  
if ( nargin == 2 )
    colorfun = 'jet';
end
colorfunc = eval(sprintf('%s(50)',colorfun));

heatmap = double(heatmap) / max(heatmap(:));

a = 1*(1-repmat(heatmap.^0.8,[1 1 3]));

b = double(img)/max(double(img(:))) ;

c = repmat(heatmap.^0.8,[1 1 3]);

e =  reshape( heatmap , [ prod(size(heatmap))  1 ] );
f = interp2(1:3,1:50,colorfunc,1:3,1+49 * e)';
g = shiftdim(reshape(f,[ 3 size(heatmap) ]),1);
g(isnan(g)) = 0;
omap = (a .* b) + (c .* g);
omap = real(omap);
% 
% figure(1)
% subplot(4,2,1)
% imshow(real(a))
% title('a')
% subplot(4,2,2)
% imshow(b)
% title('b')
% subplot(4,2,3)
% imshow(c)
% title('c')
% subplot(4,2,4)
% imshow(g)
% title('g')
% subplot(4,2,5)
% imshow(heatmap)
% title('heatmap')
% subplot(4,2,6)
% imshow((c .* g))
% title('a')
% subplot(4,2,7)
% imshow((a .* b))
% title('a')
% subplot(4,2,8)
% imshow(omap)
% title('a')



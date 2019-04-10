% This file is a demonstration of how to call gbvs()

% make some parameters
params = makeGBVSParams();

% could change params like this
params.contrastwidth = .11;

img = imread('samplepics/1.jpg');
% example of itti/koch saliency map call
% params.useIttiKochInsteadOfGBVS = 1;
outitti = gbvs(img,params);

outW = 200;
s = outW / size(img,2) ;
sz = size(img); sz = sz(1:2);
sz = round( sz * s );
img = imresize( img , sz , 'bicubic' );
saliency_map = imresize( outitti.master_map , sz , 'bicubic' );
if ( max(img(:)) > 2 ) img = double(img) / 255; end
img_thresholded = img .* repmat( saliency_map >= prctile(saliency_map(:),75) , [ 1 1 size(img,3) ] );

figure(1);
subplot(2,2,1);
imshow(img);
title('image');

subplot(2,2,2);
imshow(outitti.master_map_resized);
title('Itti, Koch Saliency Map');

subplot(2,2,3);
imshow(img_thresholded);
title('most salient (75%ile) parts');

subplot(2,2,4);
show_imgnmap(img,outitti.master_map);
title('saliency map overlayed');

out = gbvs( img );   
figure(2);
subplot(2,2,1);
imshow(img);
title('image');

subplot(2,2,2);
imshow(out.master_map_resized);
title('Itti, Koch Saliency Map');

subplot(2,2,3);
imshow(img_thresholded);
title('most salient (75%ile) parts');

subplot(2,2,4);
show_imgnmap(img,out.master_map);
title('saliency map overlayed');





% example of calling gbvs() with default params and then displaying result
outW = 200;
out = {};
% compute saliency maps for some images
for i = 1 : 5
  
  img = imread(sprintf('samplepics/%d.jpg',i));

  tic; 

    % this is how you call gbvs
    % leaving out params reset them to all default values (from
    % algsrc/makeGBVSParams.m)
    out{i} = gbvs( img );   
  
  toc;

  % show result in a pretty way  
  
  s = outW / size(img,2) ; 
  sz = size(img); sz = sz(1:2);
  sz = round( sz * s );

  img = imresize( img , sz , 'bicubic' );  
  saliency_map = imresize( out{i}.master_map , sz , 'bicubic' );
  if ( max(img(:)) > 2 ) img = double(img) / 255; end
  img_thresholded = img .* repmat( saliency_map >= prctile(saliency_map(:),75) , [ 1 1 size(img,3) ] );  
  
  figure;
  subplot(2,2,1);
  imshow(img);
  title('original image');
    
  subplot(2,2,2);
  imshow(saliency_map);
  title('GBVS map');
  
  subplot(2,2,3);
  imshow(img_thresholded);
  title('most salient (75%ile) parts');
  
  subplot(2,2,4);
  show_imgnmap(img,out{i});
  title('saliency map overlayed');
  
  if ( i < 5 )
    fprintf(1,'Now waiting for user to press enter...\n');
    pause;
  end

end

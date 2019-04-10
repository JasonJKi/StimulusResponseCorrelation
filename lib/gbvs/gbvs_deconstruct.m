img = imread('autumn.tif');
img = double(img)/255;

param = makeGBVSParams;
[grframe,param] = initGBVS(param,size(img));

[ImageGaborFiltered, motionInfo] = gbvs(img);
prevMotionInfo = [];

% [rawfeatmaps motionInfo] = getFeatureMaps( image , param , prevMotionInfo );
%% STEP 1 : form image pyramid and prune levels if pyramid levels get too small.
maxLevel =  4;

[ImageSampled, maxLevel]= subSampleRGB(img, maxLevel);

for i = 2:maxLevel
img = ImageSampled{i};
Intensity = compute(ImageIntensity(),img);
    for ii = 1:Intensity.numFeatureTypes
        img  = Intensity.feature;
        imgResized = imresize( img , param.salmapsize , 'bicubic' );
        rawfeatmaps.('intensity').maps.origval{ii}{i} = img;
        rawfeatmaps.('intensity').maps.val{ii}{i} = imgResized;
    end
end

for i = 2:maxLevel
img = ImageSampled{i};
DKLIntensity = compute(DKLColor(),img);
    for ii = 1:DKLIntensity.numFeatureTypes
        feature  = DKLIntensity.feature;
        featureResized = imresize( img , param.salmapsize , 'bicubic' );
        rawfeatmaps.('DKLColor').maps.origval{ii }{i} = feature;
        rawfeatmaps.('DKLColor').maps.val{ii }{i} = featureResized;
    end
end

gaborAngles = [0 45 90 135];
for i = 2:maxLevel
img = ImageSampled{i};
ImageGaborFiltered = compute(ImageOrientation(gaborAngles),imgIntensity{i});
   for ii = 1:ImageGaborFiltered.numFeatureTypes
        feature  = ImageGaborFiltered.feature;
        featureResized = imresize( img , param.salmapsize , 'bicubic' );
        rawfeatmaps.('orientation').maps.origval{ii}{i} = feature;
        rawfeatmaps.('orientation').maps.val{ii}{i} = featureResized;
    end
end

% previousImage = prevMotionInfo.imgL{i};
% image = ImageSampled.I{i}; 
% motionImageL{i} =  imageSequenceWeighting(image, previousImage, w);

for i = 2:maxLevel
    img = ImageSampled{i};
    Intensity = compute(ImageIntensity(),img);
    DKLIntensity = compute(DKLColor(),img);
    ImageGaborFiltered = compute(ImageOrientation(gaborAngles),imgIntensity{i});
end    
%% NEW FUNCTION HERE

A = mapsobj.maps.val{typei}{lev};
frame = grframe;
sigma_frac = param.sigma_frac_act;
num_iters = 1;
algtype = 2;
tol = param.tol;

mapnames = fieldnames(rawfeatmaps);
mapweights = zeros(1,length(mapnames));
map_types = {};
allmaps = {};
for fmapi=1:length(mapnames)
    mapsobj = eval( [ 'rawfeatmaps.' mapnames{1} ';'] );
    numtypes = mapsobj.info.numtypes;
    mapweights = mapsobj.info.weight;
    map_types = mapsobj.description;
    for iType = 1:numtypes
        for lev = param.levels
            mymessage(param,'making a graph-based activation (%s) feature map.\n',mapnames{fmapi});
            i = i + 1;
            [maps, tmp]= graphsalapply(A, frame, sigma_frac, num_iters,  algtype, tol);
            maptype = [ fmapi typei lev ]
            allmaps{i}.map = maps;
            allmaps{i}.maptype = maptype;
        end
    end
end

%%%% STEP 4 : average across maps within each feature channel
norm_maps = {};
for i=1:length(allmaps)
    mymessage(param,'normalizing a feature map (%d)... ', i);
    if ( param.normalizationType == 1 )
        mymessage(param,' using fast raise to power scheme\n ', i);
        algtype = 4;
        [norm_maps{i}.map,tmp] = graphsalapply( allmaps{i}.map , grframe, param.sigma_frac_norm, param.num_norm_iters, algtype , param.tol );
    elseif ( param.normalizationType == 2 )
        mymessage(param,' using graph-based scheme\n');
        algtype = 1;
        [norm_maps{i}.map,tmp] = graphsalapply( allmaps{i}.map , grframe, param.sigma_frac_norm, param.num_norm_iters, algtype , param.tol );
    else
        mymessage(param,' using global - mean local maxima scheme.\n');
        norm_maps{i}.map = maxNormalizeStdGBVS( mat2gray(imresize(allmaps{i}.map,param.salmapsize, 'bicubic')) );
    end
    norm_maps{i}.maptype = allmaps{i}.maptype;
end


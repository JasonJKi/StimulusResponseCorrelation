function [SubSampledImage, maxLevel] = subSampleRGB(image, maxLevel)

numChannels = size(image,3);

SubSampledImage = cell(0);
for i = 1:maxLevel
    
    for iChannel = 1:numChannels
        if i < 2
           SubSampledImage{i}(:,:,iChannel) = mySubsample(image(:,:,iChannel));
        else
           SubSampledImage{i}(:,:,iChannel) = mySubsample(SubSampledImage{i-1}(:,:,iChannel));
        end
    end 
    
    if ( (size(SubSampledImage{i},1) < 3) | (size(SubSampledImage{i},2) < 3 ) )
        maxLevel = i;
        break;
    end

end
end


function [eegOut, mask] = removeSpatialArtifact( eeg, scaleStd, show)
%REMOVEEEGARTIFACT Summary of this function goes here
% remove artifact 
% [eeg mask] = rejectEegArtifact(eeg,nRemove,sRemove,fs)
%
% step 1: artifact rejection by channel
if nargin < 3; show = 0; end

[nSamples, nDimensions] = size(eeg);

eegOut = eeg;
% step 2: artifact rejection by channel
rejectionThreshold = nanstd(eeg, [], 2)* scaleStd;
threshMatrix = repmat(rejectionThreshold,[1 nDimensions]);
indexSpaceArtifact = double(abs(eegOut) > threshMatrix);
eegOut(indexSpaceArtifact>0)=nan;
mask = indexSpaceArtifact;

if show
    figure
    subplot(2,1,1)
    imagesc(eeg')
    subplot(2,1,2)
    imagesc(eegOut')
end
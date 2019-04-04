function [eegOut, mask] = removeTimeSeriesArtifact( eeg, stdScale ,numIter, fs , show)
%removeTimeSeriesArtifact Summary of this function goes here
% remove artifact 
% [eeg mask] = removeTimeSeriesArtifact(eeg,nRemove,sRemove,fs)
%
% =artifact rejection by time sample
if nargin < 5; show = 0; end

[nSamples, nDimensions] = size(eeg);
eegOut = eeg;
indexTimeArtifactMasked = zeros(size(eeg));
se = ones(round(fs * .05),1);

for k=1:numIter
    stdChannel = nanstd(eegOut) * stdScale;
    threshMatrix = repmat(stdChannel,[nSamples 1]);
    artefactIndex = double(abs(eegOut)>threshMatrix);
    indexTimeArtifactMasked = indexTimeArtifactMasked + filtfilt(se,1,artefactIndex);
    eegOut(artefactIndex>0) = nan;
end
mask = indexTimeArtifactMasked;
if show
    figure
    subplot(2,1,1)
    imagesc(eeg')
    subplot(2,1,2)
    imagesc(eegOut')
end
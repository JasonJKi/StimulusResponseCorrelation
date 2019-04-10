function [eeg, maskc, maskt] = removeEegArtifact( eeg,nRemove,sRemove,fs )
%REMOVEEEGARTIFACT Summary of this function goes here
% remove artifact 
% [eeg mask] = rejectEegArtifact(eeg,nRemove,sRemove,fs)

[nSamples nDimensions] = size(eeg)
% step 1: artifact rejection by time sample
subplot(2,1,1)
imagesc(eeg')
eegOut = eeg;
indexTimeArtefactMasked = zeros(size(eeg));
se = ones(round(fs * .05),1);
for k=1:1
    stdChannel = nanstd(eegOut) * 1.5;
    threshMatrix = repmat(stdChannel,[nSamples 1]);
    artefactIndex = double(abs(eegOut)>threshMatrix);
    indexTimeArtefactMasked = indexTimeArtefactMasked + filtfilt(se,1,artefactIndex);
    eegOut(artefactIndex>0) = nan;
end
subplot(2,1,2)
imagesc(eegOut')

figure(2)
subplot(2,1,1)
imagesc(eeg')
eegOut = eeg;
% step 2: artifact rejection by channel
stdSpace = nanstd(eeg, [], 2)*2;
threshMatrix = repmat(stdSpace,[1 nDimensions]);
indexSpaceArtefact = double(abs(eegOut) > threshMatrix);
eegOut(indexSpaceArtefact>0)=nan;
subplot(2,1,2)
imagesc(eegOut')
end

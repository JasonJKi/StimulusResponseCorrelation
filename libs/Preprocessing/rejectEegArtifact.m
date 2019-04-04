function [eeg, mask]=rejectEegArtifact(eeg,nRemove,sRemove,fs)
% remove artifact 
% [eeg mask] = rejectEegArtifact(eeg,nRemove,sRemove,fs)
%
% step 1: artifact rejection by channel
mask = zeros(size(eeg));
se = ones(2,1);
for k=1:nRemove;
    thresh = sRemove*std(eeg);
    mask = mask + filtfilt(se,1,double(abs(eeg)>repmat(thresh,[size(eeg, 1) 1])));
    eeg(mask>0)=0;
end
maskc =mask'>0;
% step 2: artifact rejection by time sample
mask = zeros(size(eeg));
se = ones(round(fs* .03),1);
for k=1:2
    thresh = sRemove*std(eeg');
    mask = mask + filtfilt(se,1,double(abs(eeg)>repmat(thresh',[1 size(eeg, 2)])));
    eeg(mask>0)=0;
end
maskt = mask'>0;
mask = maskc+maskt;
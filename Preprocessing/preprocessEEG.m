function EEG=preprocessEEG(EEG,fsRef,EEGChannels,EOGChannels,refElectrode,filterCoeff)
% Y=preprocessEEG(EEG,fsRef,EEGChannels,EOGChannels,refElectrode,filterCoeff,fsDesired)
if nargin<5;refElectrode=0;end
if nargin<6||isempty(filterCoeff);filterCoeff=4;end

% EEG specifications
nEEGChannels=length(EEGChannels);
nEOGChannels=length(EOGChannels);
allChannels=[EEGChannels EOGChannels];
nChannels=length(allChannels);
nSamples=size(EEG,1);
nSubjects=size(EEG,3);
EEG=EEG(:,allChannels,:);
nDims=ndims(EEG);

% subtract mean from.
offSet=repmat(mean(EEG(:,:,:)),nSamples,1,1);
EEG=EEG-offSet;

% %subtract mean
% meanOffSet=repmat(mean(EEG,1),nSamples,1,1);
% EEG=EEG-meanOffSet;

if refElectrode
% % subtract reference
reference=repmat(EEG(:,refElectrode,:),1,size(EEG,2),1);
EEG=EEG-reference;
end

% create lowpass and 60Hz bandstop filter
[hpnum,hpdenom]=butter(filterCoeff,1/fsRef*2,'high'); % drift removal
[notchnum,notchdenom]=butter(filterCoeff,[59 61]/fsRef*2,'stop'); % 60Hz line noise
a = poly([roots(hpdenom);roots(notchdenom)]);
b = conv(hpnum,notchnum);

% filter transient
pad=zeros(5*fsRef,size(EEG,2),nSubjects); % create 5 second zero padding
EEGPad=cat(1,pad,EEG); % zero pad EEG
EEG=filter(b,a ,EEGPad,[],1); % fitler EEG
EEG=EEG(5*fsRef+1:end,:,:); % remove zero padding

EOG=EEG(:,EOGChannels,:); % assign EOG
EEG=EEG(:,EEGChannels,:); % assign EEG

% eye movement artifact removal
for iSubj=1:nSubjects;
    if ~isempty(EOGChannels);
        EEG(:,:,iSubj)=EEG(:,:,iSubj)-EOG(:,:,iSubj)*(EOG(:,:,iSubj)\EEG(:,:,iSubj)); %eog regression
    end
    
    % [eeg mask] = rejectEegArtifact(eeg,nRemove,sRemove,fs)
    [EEG(:,:,iSubj) mask(:,:,iSubj)] = rejectEegArtifact(EEG(:,:,iSubj),2,3,fsRef);
end

end


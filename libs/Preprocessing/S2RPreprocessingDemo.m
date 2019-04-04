%% preprocess EEG
load('./Data/ddaResponseRaw.mat') 
nComp=3 %number of components to show
fsRef=512;fsDesired=24;t=floor(size(EEG,1)/fsRef);m=fsRef*t;
% EEG=EEG(1:m,:,:);
EEGChannels=1:32;EOGChannels=[];refElectrode=[];filterCoeff=3;
EEG=preprocessEEG(EEG,fsRef,EEGChannels,EOGChannels,refElectrode,filterCoeff,fsDesired);
fs=fsDesired;
save('./Data/ddaResponseProcessed.mat','EEG','fs','t')

% extractStimulusFeatures('./Data/dda.mp4','./Data/ddaFeaturesRaw.m')
load './Data/ddaFeaturesRaw.mat' 
load('./Data/ddaResponseProcessed.mat','EEG','fs','t')

%% preprocess stimulus
options.zscore=1; % z-score feature
options.highpass=0; % high-pass feature
options.skip=0; % omit first K samples
options.fsDesired=fs;  % desired sampling rate for output (i.e., input into s2e)
options.numelEEG=size(EEG,1);  % how many samples in each EEG channel
options.K=fs;  % length of temporal aperture
options.repeat=1; % number of times to repeat S to handle multiple subjects
fs=24;
featureNames={
    'muFlow'
    'muSqTemporalContrast'
    'soundEnvelope'
    }

for f=1:length(featureNames);
    if strcmp(featureNames{f},'soundEnvelope')
        fs=features.fsAudio;
    else
        fs=features.fsVideo;
    end
    x=features.(featureNames{f});
    X(:,:,f)=preprocessStimulus(x,fs,options );
end
fs=options.fsDesired;
save('./Data/ddaFeaturesProcessed.mat','X','fs','featureNames')

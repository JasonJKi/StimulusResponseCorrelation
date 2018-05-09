%{
 This script demonstrates feature extraction of time locked eeg and 
 audio-visual stimulus using the canonical correlation analyisis from 
 Dmochowski et al. 2017 (Neuro Image). 
%}
 
% load all matlab dependencies 
addpath(genpath('./CCA')); %MATLAB implementation of canonical correlation 
                           %analysis with regularization 
addpath(genpath('./Topoplot')); %dependencies for drawing the forward model

% load response data
load('./Data/ddaResponseProcessed.mat','EEG') 
nSubjects=size(EEG,3); nChannels=size(EEG,2); 

% load stimulus data
% stimulus info: scene from Dog Day Afternoon (Sidney Lumet, 1975), t = 325.8750s, fs =24
load('./Data/ddaFeaturesProcessed.mat','X','fs');
featureNames = {'optical flow', 'luminance', 'sound envelope'}; % stimuls features
featureIndx=1; % index of stimulus feature (1 - optical flow, 2 - luminance, 3 - sound envelope)

% create training and test set
responseTrain=permute(EEG(:,:,1:nSubjects),[2 1 3]);
responseTrain=responseTrain(:,:)'; responseTest=EEG(:,:,1);
stimTest=X(:,:,featureIndx); 
stimTrain=repmat(X(:,:,featureIndx),nSubjects-1,1); 

regParam=[10 10]; % regularization parameters. regParam =[kX kY]; 
[U, V, H, W, r, p, Rxx, Ryy]=S2R(stimTrain',responseTrain',regParam,stimTest,responseTest);
S2RMap(double(H),double(W),3,r,p,fs,double(Ryy),double(Rxx),'BioSemi32.loc',1); %data type converted to double for topoplot functions

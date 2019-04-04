%{
 This script demonstrates feature extraction of time locked eeg and 
 audio-visual stimulus using the canonical correlation analyisis from 
 Dmochowski et al. 2017 (Neuro Image). 
%}
setup install
 
% load EEG data of movie.
load('data/ddaResponseProcessed.mat','EEG') 
nSubjects=size(EEG,3); nChannels=size(EEG,2); 

% load stimulus data
% stimulus info: scene from Dog Day Afternoon (Sidney Lumet, 1975), t = 325.8750s, fs =24
load('data/ddaFeaturesProcessed.mat','X','fs');
featureNames = {'optical flow', 'luminance', 'sound envelope'}; % stimuls features
featureIndx=1; % index of stimulus feature (1 - optical flow, 2 - luminance, 3 - sound envelope)
% create training and test set
responseTrain=permute(EEG,[2 1 3]);
responseTrain=responseTrain(:,:)'; responseTest=EEG(:,:,1);
stimTest=X(:,:,featureIndx); 
stimTrain=repmat(X(:,1:nSubjects,featureIndx),nSubjects,1); 

xTrain = stimTrain;
yTrain = responseTrain;
regParam=[10 10]; % regularization parameters. regParam =[kX kY]; 
[U, V, H, W, r, p, Rxx, Ryy]=S2R(xTrain,responseTrain,regParam,stimTest,responseTest);
figure(1)
S2RMap(double(H),double(W),3,r,p,fs,double(Ryy),double(Rxx),'BioSemi32.loc',0); %data type converted to double for topoplot functions
[A, B, Rxx, Ryy, Ryx,  Rxy, stats] = canonCorrRegularized(xTrain,yTrain,10,10);
figure(2)
S2RMap(double(A),double(B),3,r,p,fs,double(Ryy),double(Rxx),'BioSemi32.loc',0); %data type converted to double for topoplot functions

ccaEstimator = CCA(xTrain, yTrain);
ccaEstimator.setHyperParams(10,10)
ccaEstimator.svdRegularize('y')
ccaEstimator.compute();

S2RMap(double(A),double(B),3,r,p,fs,double(Ryy),double(Rxx),'BioSemi32.loc',0); %data type converted to double for topoplot functions

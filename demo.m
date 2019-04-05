setup install
%{
 This script demonstrates feature extraction of time locked eeg and 
 audio-visual stimulus using the canonical correlation analyisis from 
 Dmochowski et al. 2017 (Neuro Image). 
%}

% load EEG data of movie
load('data/ddaEEGProcessed.mat','EEG') 
nSubjects=size(EEG,3); nChannels=size(EEG,2); 

% load stimulus data
load('data/ddaVideoFeaturesProcessed.mat','X','fs'); % stimulus info: scene from Dog Day Afternoon (Sidney Lumet, 1975), t = 325.8750s, fs =24
featureNames = {'optical flow', 'luminance', 'sound envelope'}; % stimuls features
featureIndx=1; % index of stimulus feature (1 - optical flow, 2 - luminance, 3 - sound envelope)

% create training and test set
y = EEG;
yTrain = permute(y, [2 1 3]);
yTrain = yTrain(:, :)'; 
yTest = y(:,:,1);

x = X(:,:,featureIndx); 
xTrain = repmat(x(:,1:nSubjects,featureIndx),nSubjects,1); 
xTest = x;

% Create a estimator to perform stimulus response correlation.
kx = 10; ky = 10;
ccaEstimator = CCA(xTrain, yTrain);
ccaEstimator.setHyperParams(kx,ky);
ccaEstimator.compute();

[rhos, p] = ccaEstimator.fit(xTest, yTest);

% Compute EEG forward model.
w = ccaEstimator.B; % Spatial Weight
h = ccaEstimator.A;
ryy = ccaEstimator.covMatrix.ryy;
A = forwardModel(w, ryy);

% Draw the forward model and temporal filter.
locationInfo = readLocationFile(LocationInfo(), 'BioSemi32.loc');
scalpPlot = ScalpPlot(locationInfo);

fig = figure(1);clf;

subplot(2,3,1)
scalpPlot.draw(A(:,1)); 

subplot(2,3,2)
scalpPlot.draw(A(:,2));

subplot(2,3,3)
scalpPlot.draw(A(:,3));

subplot(2,3,4)
plot((0:fs-1)/fs,h(1:1*fs,1));

subplot(2,3,5)
plot((0:fs-1)/fs,h(1:1*fs,2));

subplot(2,3,6)
plot((0:fs-1)/fs,h(1:1*fs,3));

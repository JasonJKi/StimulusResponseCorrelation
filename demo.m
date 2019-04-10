setup install

% load in video stimulus data
videoFilepath = 'res/data/video_1.avi';
video = VideoReader(videoFilepath);

vidFeatureExtractor = setVideoReader(Extractor(),video);
vidFeatureExtractor.add(TemporalContrast())
vidFeatureExtractor.add(OpticalFlow());
vidFeatureExtractor.compute();

temporalContrast = vidFeatureExtractor.get(1);
opticFlow = vidFeatureExtractor.get(2);

responseFilepath = 'res/data/eeg_1.mat';
eeg = load(responseFilepath, 'duration', 'data', 'eventMarker', 'fs');

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

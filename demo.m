clear all
setup install
%% Create a video object for the video stimulus.
extractor = VideoFeatureExtractor();
extractor.resizeFrame(1/4); % Set a resize ratio to downsample the video.

extractor.add(TemporalContrast());
extractor.add(OpticalFlow(Farneback));
% extractor.add(OpticalFlow(HS));
% extractor.add(OpticalFlow(LK));
% extractor.add(OpticalFlow(LKDoG));

%% This dataset object assist in organizing features for multiple samples.
dataset = Dataset(extractor);
videoFileList = {'res/data/video_1.avi', 'res/data/video_2.avi'};
for i = 1:numel(videoFileList)
    
    % Extract video features for each of the video.
    % Use MATLAB's VideoReader to read in multimedia in real time.
    extractor.compute(VideoReader(videoFileList{i})); 
    % Alternatively, you can use extractor.compute(videoArray) if you have a pre computed matlab array.
    
    % Organize the dataset for each video feature computed using the dataset
    % object.
    dataset.add(extractor);
end

%% Create index to perform leave one out cross validation 
crossValDataSplitRatio = cellfun('length',dataset.timeseries.opticFlowFarneback);
randomizeIndex = false;
crossValIndex = timeseriesCrossValidation(nSamples,crossValDataSplitRatio, randomizeIndex);
opticFlowMeanTRF = videoTRF(opticFlow, opticFlow.video);

% Create a estimator to perform stimulus response correlation.
kx = 10; ky = 10;
ccaEstimator = CCA(xTrain, yTrain);
ccaEstimator.setHyperParams(kx, ky);
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

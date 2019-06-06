clear all
setup install

%% Create a video object for the video stimulus.
extractor = VideoFeatureExtractor();
extractor.resizeFrame(1/4); % Set a resize ratio to downsample the video.
extractor.add(DirectionalMotion([0 45 90 135]));

extractor.add(TemporalContrast());
extractor.add(OpticalFlow(Farneback));
extractor.add(VisualSalience(param))
% extractor.add(OpticalFlow(HS));
% extractor.add(OpticalFlow(LK));
% extractor.add(OpticalFlow(LKDoG));

%% The TSDataset object organizes multiple independent timeseries data.
dataset = TSDataset(extractor);
dataset.outputDir = 'data/';

% video files in the resource folder. Go to folder to preview the videos.
videoFileList = {'res/data/video_1.avi', 'res/data/video_2.avi'};
eegFileList = {'res/data/eeg_1.mat', 'res/data/eeg_2.mat'};
outFilenames = {'subj_001_race_001_cond_1_trial_1', 'subj_001_race_002_cond_2_trial_1'};

locationInfo = readLocationFile(LocationInfo(), '96_EEG.loc');

for i = 1:numel(videoFileList)
    
    eeg = load(eegFileList{i});  
    
    dataset.setName(outFilenames{i})
    
    dataset.add(eeg.data, 'eeg', eeg.fs, locationInfo.channelLabels);
    
    % Extract video features for each of the video.
    % opt 1. Use MATLAB's VideoReader to read in multimedia in real time.
    extractor.compute(VideoReader(videoFileList{i})); 
    
    % opt 2. Alternatively, you can use 
    % extractor.compute(videoArray) if you have a pre computed matlab array.
    
    % Add individual timeseries features for each video.
    dataset.addFromVFExtractor(extractor);
    
    
    % Output processed data.
    %     dataset.save()
    
    % iterate to next timeseries sample
    dataset.next(i);
    
end

for ind = 1:4
    
    figure(1)
    subplot(2,2,ind);imagesc(squeeze(dataset.timeseries.directionalMotion.data(5000,:,:,ind)))
    figure(2)
    subplot(2,2,ind);imagesc(squeeze(dataset.timeseries.opticalFlowFarneback.data(5000,:,:,ind)))

end

%% Create index to perform leave one out cross validation
numSamples = dataset.numSamples;
% randomizeIndex = false;

% crossValIndex = timeseriesCrossValidation(nSamples, crossValDataSplitRatio, randomizeIndex);
fs = extractor.frameRate;
xTrain = videoTRF(dataset.timeseries(1).temporalContrast(:,:,:) , fs);
xTest = videoTRF(dataset.timeseries(2).temporalContrast(:,:,:) , fs);

eeg1 = load('res/data/eeg_1.mat');
eeg2 = load('res/data/eeg_2.mat');

yTrain = resample(eeg1.data, fs, eeg1.fs);
yTest = resample(eeg2.data, fs, eeg1.fs);

% Create a estimator to perform stimulus response correlation.
kx = 10; ky = 10;
ccaEstimator = CCA(Params(kx, ky));
ccaEstimator.fit([xTrain; xTest] , [yTrain; yTest(1:length(xTest),:)]);

% Compute EEG forward model.
w = ccaEstimator.B; % Spatial Weight
h = ccaEstimator.A;
ryy = ccaEstimator.covMatrix.ryy;
A = forwardModel(w, ryy);

% Draw the forward model and temporal filter.
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

rootDir = '../'
filepath = [rootDir 'data/11_28_17_01.xdf'];
data = load_xdf(filepath)

EEG = data{5};
EventMarkers = data{2};

trigger = str2num(cell2mat(EventMarkers.time_series'));
triggerTimestamp = EventMarkers.time_stamps;
eventCodes = unique(trigger);
flashEventCode = max(eventCodes);
nFlashEventCode = length(eventCodes);

disp('Epoching Flash Event From the photodioderiggers. on and off event')
[flashIndices, startTime, endTime, nFlash, startIndex, endIndex] = ...
    parsePhotodiodeFlashEvents(trigger,flashEventCode,triggerTimestamp);
subplot(2,1,2);hold on
p1 = plot(trigger,'b','DisplayName',''); % plot all events
p2 = plot(flashIndices,trigger(flashIndices),'g.');
p3 = plot([startIndex endIndex],trigger([startIndex endIndex]),'k*');
trigger(startIndex:endIndex)
%% cut up the EEG based on first and last triggers
flashEventTimestamp = triggerTimestamp(flashIndices);
startTime = flashEventTimestamp(1);
endTime = flashEventTimestamp(end);
durationEeg = endTime - startTime;
eegEpochIndex = epochTimestamp(EEG.time_stamps,startTime,endTime);

eegEpoched = EEG.time_series(:,eegEpochIndex)';
eegEpochedResampled = [];
newFs = 5000/50;
for i = 1:96
    eegEpochedResampled(:,i) = decimate(eegEpoched(:,i),50);
end
eeg = eegEpochedResampled;
duration = durationEeg;
eventMarker = downsample(trigger(startIndex:endIndex),50);
eventMarker = eventMarker(1:end-1);
fs = newFs;
save('../data/demo_eeg.mat','eeg','duration','eventMarker','fs')
vidFilePath = [rootDir 'data/2017-11-28 17-08-34.avi'];
resizeScale = .5; % Resize video according to the scale. 
[video, videoGray, RawVideoInfo] = videoToMat(vidFilePath,[],resizeScale);
fsVideo = double(int16(RawVideoInfo.FrameRate));
disp('Video successfully converted to mat')

localizedVideoView = localizeVideoView(video);
localizedVideoViewGrey = squeeze(mean(localizedVideoView,3));
meanVideoFlashEvent = videoMean2(localizedVideoViewGrey);

% Parse the flash events from the video and find the start and
% end index of the flash on screen.
[VideoFlashEvent] = parseVideoFlashEvents(meanVideoFlashEvent,0,0);

% Epoch Video
videoEpochIndex = VideoFlashEvent.startIndex: VideoFlashEvent.endIndex;
nVideoEpochIndex = length(videoEpochIndex);
durationVideo = nVideoEpochIndex*(1/fsVideo);


videoEpoched = video(videoEpochIndex,:,:,:);

v = VideoWriter('../data/demo_video.mp4');
set(v,'FrameRate',fs);
open(v);

for i = 1:nVideoEpochIndex
    M = squeeze(videoEpoched(i,:,:,:));
    writeVideo(v,M);
end
close(v);
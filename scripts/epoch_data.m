rootDir = '../'
fileNumStr = numstr(1);
filepath = [rootDir 'res/data/raw/11_28_17_02.xdf'];
% Filepath = [rootDir 'res/data/raw/11_28_17_01.xdf'];
streams = load_xdf(filepath);

vidFilePath = [rootDir 'res/data/raw/2017-11-28 17-08-34.avi'];
%vidFilePath = [rootDir 'res/data/raw/2017-11-28 17-14-50.avi'];

% Sort and assign streams.
nStreams = length(streams);
disp('Following streams found:')
for i = 1:nStreams
    streamName = streams{i}.info.name;
    stream = streams{i}.time_series';
    timestamp = streams{i}.time_stamps';
    disp(['    ' streamName])
    switch streamName
        case 'OBS Studio'
            Obs.timeseries = single(stream);
            Obs.timestamp = timestamp;
        case 'BrainAmpSeries'
            Eeg.timeseries = single(stream);
            Eeg.timestamp = timestamp;
        case 'BrainAmpSeries-Markers'
            EventMarkers.timeseries = str2num(cell2mat(stream));
            EventMarkers.timestamp = timestamp;
        case 'Keyboard'
            Keyboard.data = stream;
            Keyboard.timestamp = timestamp;
        case 'EyeLink'
            Eyelink.data = stream;
            Eyelink.timestamp = timestamp;
        otherwise
            continue
    end
end

trigger = EventMarkers.timeseries;
triggerTimestamp = EventMarkers.timestamp;
eventCodes = unique(trigger);
flashEventCode = max(eventCodes);
nFlashEventCode = length(eventCodes);

%%%%%%
disp('Epoching Flash Event From the photodioderiggers. on and off event')
[flashIndices, startTime, endTime, nFlash, startIndex, endIndex] = ...
    parsePhotodiodeFlashEvents(trigger,flashEventCode,triggerTimestamp);
subplot(2,1,2);hold on
p1 = plot(trigger,'b','DisplayName',''); % plot all events
p2 = plot(flashIndices,trigger(flashIndices),'g.');
p3 = plot([startIndex endIndex],trigger([startIndex endIndex]),'k*');
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
data = eegEpochedResampled;
duration = durationEeg;
eventMarker = downsample(trigger(startIndex:endIndex),50);
eventMarker = eventMarker(1:end-1);
fs = newFs;
save(['../res/data/eeg_'  fileNumStr], 'data', 'duration', 'eventMarker', 'fs')

resizeScale = .5; % Resize video according to the scale. 
[video, videoGray, RawVideoInfo] = videoToMat(vidFilePath, [], resizeScale);
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

v = VideoWriter(['../res/data/video_' fileNumStr]);
set(v,'FrameRate',fsVideo);
open(v);

for i = 1:nVideoEpochIndex
    M = squeeze(videoEpoched(i,:,:,:));
    writeVideo(v,M);
end
close(v);
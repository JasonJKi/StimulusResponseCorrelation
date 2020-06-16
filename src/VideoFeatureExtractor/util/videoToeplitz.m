function videoTplitz = videoToeplitz(video,K)
% video = magSquared(video);
videoMean = videoMean2(video); % compute mean
videoMeanNorm = zscore(videoMean); % normalize
videoTplitz = tplitz(videoMeanNorm,K); % tplitz for temporal response filter
end
function videoTRF = videoTRF(video,K)
videoMean = videoMean2(video); % compute mean
videoMeanNorm = zscore(videoMean); % normalize
videoTRF = tplitz(videoMeanNorm,K); % tplitz for temporal response filter
end
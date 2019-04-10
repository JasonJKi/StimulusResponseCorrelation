function [ eegFiltered ] = filterEeg(eeg, fs, coeffLength)
%_EEG_FILTER Summary of this function goes here
%   Perform 60hz bandstop and high pass to remove drifting

[nSamples, nChannels] = size(eeg);
if nargin < 3 
    coeffLength = 4;
end

% Create highpass drift filter.
[b,a]=butter(coeffLength,1/fs*2,'high'); % drift removal

if fs > 60
    % Create 60Hz bandstop filter to remove electrical noise.
    [notchnum, notchdenom] = butter(2,[59 61]/fs*2,'stop'); % 60Hz line noise
    a = poly([roots(a);roots(notchdenom)]);
    b = conv(b,notchnum);
end

% Apply filering and remove delay noise from the filter by 0 padding the signal.
zeroPadding = zeros(5*fs,nChannels); % create 5 second zero padding
eegPadded = cat(1,zeroPadding,eeg); % zero pad EEG
eegFiltered = filter(b,a,eegPadded); % fitler EEG
eegFiltered = eegFiltered(5*fs+1:end,:);
end


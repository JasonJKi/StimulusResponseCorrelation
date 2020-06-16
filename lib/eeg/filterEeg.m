function [ eegFiltered ] = filterEeg(eeg, fs, coeff_length)
%_EEG_FILTER Summary of this function goes here
%   Perform 60hz bandstop and high pass to remove drifting

[num_samples, num_channels] = size(eeg);
if nargin < 3 
    coeff_length = 3;
end

% Create highpass drift filter.
[b,a]=butter(coeff_length,1/fs*2,'high'); % drift removal

if fs > 60
    % Create 60Hz bandstop filter to remove electrical noise.
    [notchnum, notchdenom] = butter(4,[59 61]/(fs*2),'stop'); % 60Hz line noise
    a = poly([roots(a);roots(notchdenom)]);
    b = conv(b,notchnum);
%     freqz(b,a)

end

% Apply filering and remove delay noise from the filter by 0 padding the signal.
zeropad = zeros(5*fs,num_channels); % create 5 second zero padding
eegFiltered = filter(b, a, cat(1,zeropad, eeg)); % fitler EEG
eegFiltered = eegFiltered(5*fs+1:end,:);
end


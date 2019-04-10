function phaseRandomizedEeg = randomizePhase(eeg)
%PhaseRandomizedEeg = RANDOMIZEPHASE(eeg) Randomly shift the phase eeg.

[nSamples, nChannels] = size(eeg);

t = nSamples;
if mod(t,2)
    fftInd = 2;
else
    fftInd = 1;
end
% Fourier transform of the eeg
eegFFT = fft(eeg(1:t,:));
                
% Create the random phases for all the time series
phaseInterval1 = repmat(exp(2 * pi * 1i * rand([floor(t/2) 1])),1,nChannels);
phaseInterval2 = conj(flipud(phaseInterval1));

% Randomize all the time series simultaneously
fft_recblk_surr(2:floor(t/2)+1,:) = eegFFT(2:floor(t/2)+1,:).*phaseInterval1;
fft_recblk_surr(floor(t/2)+fftInd:t,:) = eegFFT(floor(t/2)+fftInd:t,:).*phaseInterval2;

% Inverse transform
phaseRandomizedEeg = real(ifft(fft_recblk_surr));
end


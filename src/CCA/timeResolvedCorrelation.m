function rhos = timeResolvedCorrelation(stim,eeg,A,B,winlen,winshift)
%RHOS=COMPUTETIMERESOLVEDRHOS(STIM,EEG,A,B,WINLEN,WINSHIFT)
%   compute sliding window stimulus-response correlations after CCA

%
% stim: T x 1
% eeg: electrodes x T
% A: temporal filters on stim (one in each column)
% B: spatial filters on eeg (one in each column)
% winlen: length of correlation window in SAMPLES
% winshift: number of samples between successive windows

K=size(A,1)-1;
%%
[n, k] = size(stim);
zeroPad = zeros(winlen/4,k);
stim = [zeroPad; stim; zeroPad];
U=stim*A;
[n, k] = size(eeg);
zeroPad = zeros(winlen/4,k);
eeg = [zeroPad; eeg; zeroPad];
V=eeg*B;
%%
T=size(U,1);
%nWins=round((T-winlen)/winshift);
nWins=floor((T-1)/winshift+1)- winlen/2;
% wins=cell(nWins,1);

for n=1:nWins
    
    win=(n-1)*winshift+1:(n-1)*winshift+winlen;
    win = win(win<=T);
   
%     winsToAdd = winlen - nthWinLen; 
%     zerosToAppend = zeros(1,winsToAdd);
%     win = [win zerosToAppend];
    wins{n} = win;  
end

rhos = compute_cc_fixed(U,V,wins);

end
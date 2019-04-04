function rhos = computeTimeResolvedRhos(stim,eeg,A,B,winlen,winshift)
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
stim=zscore(stim);
stim_tpl=tplitz(stim,K);
%%
U=stim_tpl*A;
V=eeg.'*B;
%%
T=size(U,1);
%nWins=round((T-winlen)/winshift);
nWins=floor((T-1)/winshift+1);
wins=cell(nWins,1);

for n=1:nWins
    wins{n}=(n-1)*winshift+1:(n-1)*winshift+1+winlen;
    wins{n}=wins{n}(wins{n}<=T);  
end

rhos = compute_cc_fixed(U,V,wins);

end


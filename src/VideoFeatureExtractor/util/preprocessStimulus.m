function S = preprocessStimulus( s,fs,options )
%S=PREPROCESSSTIMULUS(S,OPTIONS)
%   Take in a stimulus vector s and return a z-score, filtered, and
%   toeplitzed matrix ready for stimeeg
%
% (c) Jacek P. Dmochowski, 2016
if nargin<2, error('JD: need at least two arguments'); end

s=s(:); % 

if nargin<3
    options.zscore=1; % z-score feature
    options.highpass=1; % high-pass feature
    options.skip=0; % omit first K samples
    options.fsDesired=fs;  % desired sampling rate for output (i.e., input into s2e)
    options.numelEEG=numel(s);  % how many samples in each EEG channel
    options.K=fs;  % length of temporal aperture
    options.repeat=1; % number of times to repeat S to handle multiple subjects
end

if options.highpass % high-pass stimulus
    [hpnum,hpdenom]=butter(2,0.5/fs*2,'high');
    spad=cat(1,zeros(5*fs,1),s);
    spadfilter=filter(hpnum,hpdenom,spad);
    s=spadfilter(5*fs+1:end);
end

if options.fsDesired~=fs
    s=resample(s,options.fsDesired,fs);
end

if options.zscore
    s=(s-nanmean(s))/nanstd(s);  
end

% modify length of stimulus to match EEG
if options.numelEEG>numel(s) % feature missing samples
    nMissing=options.numelEEG-numel(s);
    s=cat(1,s,zeros(nMissing,1));
end
if options.numelEEG<numel(s)  % feature has too many samples
    s=s(1:options.numelEEG);
end

% create convolution matrix in preparation for linear filtering
S=tplitz(s,options.K);

% remove initial segment of data
if options.skip>0
    S=S(options.skip+1:end,:);
end

if options.repeat>1
    S=repmat(S,options.repeat,1);
end

end


function dataOut = myPreprocess( dataIn , opts)
% preprocess input eeg data
%  allow for various pre-processing options
%  includes option for robust pca

if nargin<2
    opts.Q1=4;
    opts.Q2=4;
    opts.zero=1;
    opts.xtent=12;
    opts.showSvd=0;
    opts.nChan2Keep=128;
    opts.rpca=1;
    opts.fs=512;
    opts.fsref=256;
    opts.locFilename='BioSemi64.loc'; % wild guess
    opts.chanlocs=[];
end

if ~isfield(opts,'Q1')
    opts.Q1=4;
end

if ~isfield(opts,'Q2')
    opts.Q2=4;
end

if ~isfield(opts,'zero')
    opts.zero=1;
end

if ~isfield(opts,'xtent')
    opts.xtent=12;
end

if ~isfield(opts,'show')
    opts.show=1;
end

if ~isfield(opts,'nChan2Keep')
    opts.nChan2Keep=64;
end

if ~isfield(opts,'fs')
    opts.fs=512;
end

if ~isfield(opts,'fsref')
    opts.nChan2Keep=256;
end

if ~isfield(opts,'virtualeog')
    opts.virtualeog=[];
end


Q1=opts.Q1; Q2=opts.Q2; zero=opts.zero; xtent=opts.xtent;
nChan2Keep=opts.nChan2Keep;


dataIn=forceSpaceTime(dataIn);

nChannels=size(dataIn,1);
nSamples=size(dataIn,2);
fs=opts.fs;
fsref=opts.fsref;
channels=1:nChan2Keep;
prependLen=round(5*fs);

%% common mean subtraction
dataIn=dataIn-repmat(mean(dataIn,1),nChan2Keep,1);

%%
fl=opts.fl;
fh=opts.fh;
%[b,a]=butter(4,[fl/(fs/2) fh/(fs/2)] ,'bandpass');
[b,a]=butter(4,fl/(fs/2),'high');
dataIn=cat(2,zeros(nChan2Keep,prependLen),dataIn);
dataOut=filter(b,a,dataIn,[],2);
dataOut=dataOut(:,prependLen+1:end);


%% run robust pca if desired
if opts.rpca
    dataOut=forceSpaceTime(dataOut)'; % change to time-space
    [A_hat E_hat iter] = inexact_alm_rpca(dataOut,(1 / sqrt(length(dataOut))*1.1));
    dataOut=forceSpaceTime(A_hat); % back to space-time
end

[dataOut,gind] = nanBadChannels(dataOut,Q1,Q2,zero,opts.locFilename);
dataOut = nanBadSamples(dataOut,Q1,Q2,zero,xtent);
nanIndex = isnan(dataOut);
dataOut(nanIndex)=0; 

if ~isempty(opts.virtualeog)
    Xref=opts.virtualeog.'*dataOut;
    dataOut=regressOut(dataOut,Xref);
end
dataOut(nanIndex)= nan; 

% dataOut(nanIndex) = nan;

if opts.showSvd
    [U,S,V]=svd(dataOut',0);
    figure;
    for c=1:20
        subplot(4,5,c)
        if isempty(opts.locFilename)
            topoplot(V(:,c),opts.chanlocs); colormap('jet');
        else
            topoplot(V(:,c),opts.locfile); colormap('jet');
        end
    end
    drawnow
end



end


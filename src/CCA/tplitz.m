function X = tplitz(x,k)
%X = TPLITZ(x,K) toeplit matrix with specified kernel size
nSamples = size(x,1);
X = zeros(nSamples,k);
for t=1:k
    delayTime = t-1;
    delayPadding = zeros(delayTime,1);
    xDelay = [delayPadding; x(1:nSamples-delayTime)];
    X(:,t) = xDelay;
end

X=cat(2,X,ones(nSamples,1));
end
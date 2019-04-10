function [rhoAll, muRho, stdRho] = bootstrapCorrelationDistribution(X,W,Y,H)
% Compute Weight Significance 
%       [componentSignificance, acceptedComponents ,rhoSurrogate] = bootstrapWeights(W,numIter,acceptedSignifcance)
%
% Compute a distribution of correlation of a regression model via
% bootstrapping

% INPUT
%   X - Some test set input (n x m x i) 
%   Y - Some test set output (n x m x i)
%   W - Learned weights (parameters) (m x k)
%   optional 
%   H - Learned weights (parameters) (m x k)
%   optional 
%   numIter = number of surrogate data test
%
% OUTPUT
%   componentSiginance - significance of the model
%   acceptedComponents - index of accepted components 

[n, k] = size(W);
numIter = size(X,3);
rhoAll = zeros(numIter,k);

for i = 1:numIter    
    X_ = X(:,:,i);
    Y_ = Y(:,:,i);
     % project random data to the discovered parameter
    XhatRandomized = X_*W;
    YhatRandomized = Y_*H;
    % compute correlation with the surrogate data
    rhoAll(i,:) = computeCorrelation(YhatRandomized,XhatRandomized);
end

muRho = mean(rhoAll);
stdRho = std(rhoAll);
% p2 = sum(rhoSurrogate >= rhoTest,2)/numIter;





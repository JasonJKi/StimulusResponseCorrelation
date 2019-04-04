function [acceptedComponents, componentSignificance, rhoSurrogate, p2] = computeWeightSignificance(X,Y,W,H,XSurrogate,YSurrogate,numIter)
% Compute Weight Significance 
%       [componentSignificance, acceptedComponents ,rhoSurrogate] = computeWeightSignificance(X,Y,W,numIter,acceptedSignifcance)
%
% Computing the significance of the learned parameters of a regression 
% model by estimating the cumulative distribution of correlations of surrogate
% input data(XPhaseRandomized) and the true estimated output(Yhat).
%
% INPUT
%   X - Some test set input (n x m) 
%   Y - Some test set output (n x m)
%   W - Learned weights (parameters) (m x k)
%   optional 
%   numIter = number of surrogate data test
%   acceptedSignificance = significance (p value) of accepted correlation;
%
% OUTPUT
%   componentSiginance - significance of the model
%   acceptedComponents - index of accepted components 
acceptedSignifcance = .05;

if nargin < 4
    surrogateDataStatus = false;
    numIter = 200;

end

if isempty(XSurrogate)
    surrogateDataStatus = false;
else
    surrogateDataStatus = true;
    numIter = size(XSurrogate,3);
end
% find significance on a test data
Xhat = X*W;
Yhat = Y*H;
rhoTest = computeCorrelation(Xhat,Yhat);

[n, k] = size(W);
rhoSurrogate = zeros(k,numIter);
% find significant components above chance against surrogate data
for i = 1:numIter
    
    if surrogateDataStatus
        XPhaseRandomized = XSurrogate(:,:,i);
        YPhaseRandomized = YSurrogate(:,:,i);
    else
        % randomize phase of the input
        XPhaseRandomized = randomizePhase(X);
    end
    
     % project random data to the discovered parameter
    XhatRandomized = XPhaseRandomized*W;
    YhatRandomized = YPhaseRandomized*H;
    
    % compute correlation with the surrogate data
    rhoSurrogate(:,i) = computeCorrelation(YhatRandomized,XhatRandomized);
end

muRho = mean(rhoSurrogate,2);
stdRho = std(rhoSurrogate,0,2);
%  = sum(rhoSurrogate > rhoTest, 2);

for j = 1:k
    % get cdf of the test rho value for each component. 
    p(j) = 1 - normcdf(rhoTest(j),muRho(j),stdRho(j));
     
%     pd = makedist('Normal',muRho(k),stdRho(j));
%     p2(j) = cdf(pd,rhoTest(j))
end

componentSignificance = p;
acceptedComponents = p < acceptedSignifcance;
p2 = sum(rhoSurrogate >= rhoTest,2)/numIter;


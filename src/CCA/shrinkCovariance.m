function Rout = shrinkCovariance(R, gamma)
%covRegularized = regularizeCovariance(covIn, k, gamma)
%   PCA regularization of covariance matrix
if ~ismatrix(R), error('R must have two dimensions'); end
if size(R,1) ~= size(R,2), error('R must be a square matrix'); end
if nargin < 2, gamma = .5; end

D = size(R);
% use shrinkage method to regularize pooled covariance
Rout = (1-gamma)*R + gamma * mean(eig(R))*eye(D);


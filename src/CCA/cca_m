function [A, B, r, stats, Rxx, Ryy, Ryx, Rxy, U, V] = cca(X, Y, kx, ky)
% Canoncal Correlation Analysis 
%[A, B, r, p, Rxx, Ryy, U, V] = cca(X,Y,kx,ky)  Canoncal Correlation Analysis 
% for maxmizing correlation for two views.
%
% cca performs canonical correlation analysis to find weights for view
% X and Y which optimizes correlation between the two
%
%   Inputs:
%       X - view 1
%       Y - view 2
%       kx - regularization parameter X
%       ky - regularization parameter Y
%
%   Output:
%       U - projection of X on A
%       V - projection of Y on B
%       A - canonically correlated weight for X
%       B - canonically correlated weight for Y
%       r - correlation bettwen U and V for each CCA component
%       p - signifance
%       Rxx - pooled covariance matrix of X
%       Ryy - pooled covariance matrix of Y

if nargin < 3
    ky = [];
    kx = [];
end

if nargin < 4
    ky = [];
    if isempty(kx)
        kx = [];
    end
end

if ~ismatrix(X), error('X must have two dimensions'); end
if ~ismatrix(Y), error('Y must have two dimensions'); end

% Regularized canonical correlation
[A, B, Rxx, Ryy, Ryx, Rxy, stats] = canonCorrRegularized(X, Y, kx , ky);

% Project x on A and Y on B.
U=X*A;
V=Y*B;

% Compute correlation over all components.
[r, p] =  computeCorrelation(U, V);

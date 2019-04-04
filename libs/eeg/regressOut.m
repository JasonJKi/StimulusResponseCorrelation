function [Xout Ehat]= regressOut(X,Y)
% XOUT=REGRESSOUT(X,Y)
% linearly regress out the components in matrix Y from the matrix X
%
% assumes channels in row dimension, time in column dimension

% put into space-time format
if size(X,1)>size(X,2), X=X.'; warning('transposing X'); end
if size(Y,1)>size(Y,2), Y=Y.'; warning('transposing Y'); end

% check number of time samples
if size(X,2)~=size(Y,2), error('number of samples in X must equal that in Y'); end;

A=X*pinv(Y);
Ehat = A*Y;
Xout = X - Ehat;
function [rxy,rxx,ryy,ryx] = nanRXY(X, Y)
% nanRXY - Compute cross covariance while ignoring data points with Nan
% assignment.
%[rxy,rxx,ryy,ryx] = nanRXY(X, Y)

numDims=size(X,2);
% Compute covariance with nan values
nanRXY=nancov([X Y],'pairwise');

rxx=nanRXY(1:numDims,1:numDims);
ryy=nanRXY(numDims+1:end,numDims+1:end);
rxy=nanRXY(1:numDims,numDims+1:end);
ryx=nanRXY(numDims+1:end,1:numDims);

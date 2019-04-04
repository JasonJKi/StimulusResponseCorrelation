function [U, V, H, W, r, p, Rxx, Ryy]=S2R(XTrain,YTrain,regParam,XTest,YTest)
% S2R - Stimulus to Response
% [U V H W r p]=S2E(X,Y,regParam,XTest,YTest)
% S2R performs canonical correlation analysis to find temporal filter(H)  
% and spatial weights(W) which optimizes correlation between the stimulus
% feature and brain response.
%
%   Inputs:
%      X(stimulus) - Stimulus training set (time x number of lags)
%      Y(brain response) - Neural responses training set (time x channels)
%
%   Optional:
%      regParam - regularization parameter for CCA [kx ky]
%      XTest - test stimulus 
%      YTest - test brain response 
%
%   Output:
%       U - reconstructed stimulus
%       V - reconstructed EEG 
%       H - temporal filter for stimulus
%       W - spatial filter of EEG
%       r - correlation bettwen U and V for each CCA component
%       p - signifance
%       Rxx - pooled covariance matrix of X
%       Ryy - pooled covariance matrix of Y

n=size(YTrain,2); % number of samples
m=size(YTrain,1); % number of channels

%%   regularized canonical correlation
[Rxy,Rxx,Ryy,Ryx] = nanRXY(XTrain,YTrain); % compute cross covariance

if ~exist('regParam', 'var')
    Ky=round(m*.2);Kx=rank(Rxx); %set ky as 20% of the number of channel  
elseif isempty(regParam)
     Ky=round(m*.2);Kx=rank(Rxx);
else
    Kx = regParam(1);
    Ky = regParam(2);
end

% compute A
Rxxnsq=regSqrtInv(Rxx,Kx); % regularized Rxx^(-1/2)
M=Rxxnsq*Rxy*regInv(Ryy,Ky)*Ryx*Rxxnsq; % textbook
M=(M+M')/2; % fix nummerical precision asymmetric
[C,Dc]=eig(M);  % textbook
[~,indx]=sort(diag(Dc),'descend'); 
C=C(:,indx(1:min(Kx,Ky))); % dump zero eigenvalue dimensions 
A=Rxxnsq*C; % invert coordinate transformation

% compute B
Ryynsq=regSqrtInv(Ryy,Ky); % regularized Ryy^(-1/2)
D=Ryynsq*Ryx*Rxxnsq*C;
B=Ryynsq*D;

if sum(~isreal(A(:))) | sum(~isreal(B(:)))
    warning('Imaginary components. Something is wrong!'); 
end

% remove small imaginary component
H=real(A); % stimulus temporal filter 
W=real(B); % brain response spatial filter

%% project X on H and Y on W.
U=XTest*H;
V=YTest*W;

%% test significance for entire data set.
nVars=min(size(U,2),size(V,2));
r=zeros(nVars,1);
p=zeros(nVars,1);
for n=1:nVars
    [rhos,pVals]=corrcoef(U(:,n),V(:,n));
    r(n)=rhos(1,2);
    p(n)=pVals(1,2);
end


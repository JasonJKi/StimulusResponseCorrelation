function [A, B, Rxx, Ryy, Ryx,  Rxy] = canonCorrShrinkageRegularized(X,Y,kX,kY,shrinkage)
% CANOICALLY CORRELATED COMPONENTS 
% [A, B, Rxx, Ryy, Ryx,  Rxy] = canoically_correlated_components(X,Y,rankX,rankY)
[nx,mx] = size(X);
[ny,my] = size(Y);

if nx < mx, X=X'; disp('transposing X'); end
if ny < my, Y=Y'; disp('transposing Y'); end

[nx,mx] = size(X);
[ny,my] = size(Y);

X = X - repmat(nanmean(X,1), nx, 1);
Y = Y - repmat(nanmean(Y,1), ny, 1);

%%   regularized canonical correlation
[Rxy,Rxx,Ryy,Ryx] = nanRXY(X,Y); % compute cross covariance
rankY = rank(Ryy);
rankX = rank(Rxx);

if nargin < 3
    kX = rankX;
    kY = rankY;
end

if nargin < 4
    rankY = rank(Ryy);
    if isempty(rankX)
        rankX =rank(Rxx);
    end
    d = min(rankX,rankY);
end

if isempty(kX); kX = rankX;end
if isempty(kY); kY = rankY; end

d = min(kX,kY);

if shrinkage
    gammaX = kX;
    gammaY = kY;
    RxxReg = (1-gammaX)*Rxx + gammaX * mean(eig(Rxx))*eye(mx);
    Rxx = RxxReg;
    RyyReg = (1-gammaY)*Ryy + gammaY * mean(eig(Ryy))*eye(my);
    Ryy = RyyReg;
    RxxRegInvs = inv(RxxReg);
    RyyRegInvs = inv(RyyReg);
    RxxRegSqrtInvs = sqrtm(RxxRegInvs);
    RyyRegSqrtInvs = sqrtm(RyyRegInvs);
else
    RxxRegSqrtInvs = regSqrtInv(Rxx,kX); % regularized Rxx^(-1/2)
    RyyRegInvs = regInv(Ryy, kY);  % regularized Ryy^-1
    RyyRegSqrtInvs = regSqrtInv(Ryy, kY); % regularized Ryy^(-1/2)
end

% compute A for X
M = RxxRegSqrtInvs * Rxy * RyyRegInvs * Ryx * RxxRegSqrtInvs; % textbook
M = (M+M') / 2; % fix nummerical precision asymmetric

[C,Dc] = eig(M);  % textbook
[~,indx ] =sort(diag(Dc), 'descend');
C = C(:, indx(1:d)); % dump zero eigenvalue dimensions
A = RxxRegSqrtInvs * C; % invert coordinate transformation

% compute B for Y
D = RyyRegSqrtInvs * Ryx * RxxRegSqrtInvs * C;
B = RyyRegSqrtInvs * D;

function [A, B, rXX, rYY, rYX,  rXY, r] = canonCorrRegularizedPooled(rXX, rYY, rYX,  rXY, kX, kY)
% CANOICALLY CORRELATED COMPONENTS 
% [A, B, rXX, rYY, rYX,  rXY] = canoically_correlated_components(X,Y,rankX,rankY)

rankY = rank(rYY);
rankX = rank(rXX);

if nargin < 3
    kX = rankX;
    kY = rankY;
end

if nargin < 4
    rankY = rank(rYY);
    if isempty(rankX)
        rankX =rank(rXX);
    end
    d = min(rankX,rankY);
end

if isempty(kX); kX = rankX;end
if isempty(kY); kY = rankY; end
d = min(kX,kY);

% compute A for X
rXXRegSqrtInvs = regSqrtInv(rXX,kX); % regularized rXX^(-1/2)
rYYRegInv = regInv(rYY, rankY);  % regularized rYY^-1
M = rXXRegSqrtInvs * rXY * rYYRegInv * rYX * rXXRegSqrtInvs; % textbook
M = (M+M') / 2; % fix nummerical precision asymmetric
[C,Dc] = eig(M);  % textbook
[~,indx ] =sort(diag(Dc), 'descend');
C = C(:, indx(1:d)); % dump zero eigenvalue dimensions
A = rXXRegSqrtInvs * C; % invert coordinate transformation

% compute B for Y
rYYRegSqrtInvs = regSqrtInv(rYY, kY); % regularized rYY^(-1/2)
D = rYYRegSqrtInvs * rYX * rXXRegSqrtInvs * C;
B = rYYRegSqrtInvs * D;

r = min(max(diag(D(:,1:d))', 0), 1); % remove roundoff errs

if sum(~isreal(A(:))) | sum(~isreal(B(:)))
    warning('Imaginary components. Something is wrong!');
    A=real(A); % stimulus temporal filter
    B=real(B); % brain response spatial filter
end

end

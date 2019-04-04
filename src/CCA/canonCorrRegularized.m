function [A, B, Rxx, Ryy, Ryx,  Rxy, stats] = canonCorrRegularized(X,Y,kX,kY)
% CANOICALLY CORRELATED COMPONENTS 
% [A, B, Rxx, Ryy, Ryx,  Rxy] = canoically_correlated_components(X,Y,rankX,rankY)
[nx,mx] = size(X);
[ny,my] = size(Y);

if nx < mx, X=X'; disp('transposing X'); end
if ny < my, Y=Y'; disp('transposing Y'); end

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

% compute A for X
RxxRegSqrtInvs = regSqrtInv(Rxx,kX); % regularized Rxx^(-1/2)
RyyRegInv = regInv(Ryy, kY);  % regularized Ryy^-1
M = RxxRegSqrtInvs * Rxy * RyyRegInv * Ryx * RxxRegSqrtInvs; % textbook
M = (M+M') / 2; % fix nummerical precision asymmetric
[C,Dc] = eig(M);  % textbook
[~,indx ] =sort(diag(Dc), 'descend');
C = C(:, indx(1:d)); % dump zero eigenvalue dimensions
A = RxxRegSqrtInvs * C; % invert coordinate transformation

% compute B for Y
RyyRegSqrtInvs = regSqrtInv(Ryy, kY); % regularized Ryy^(-1/2)
D = RyyRegSqrtInvs * Ryx * RxxRegSqrtInvs * C;
B = RyyRegSqrtInvs * D;

r = min(max(diag(D(:,1:d))', 0), 1); % remove roundoff errs
stats.r = r;
if sum(~isreal(A(:))) | sum(~isreal(B(:)))
    warning('Imaginary components. Something is wrong!');
    A=real(A); % stimulus temporal filter
    B=real(B); % brain response spatial filter
end


% Compute test statistics for H0k: rho_(k+1) == ... = rho_d == 0
if nargout > 6
    % Wilks' lambda statistic
    k = 0:(d-1);
    d1k = (kX-k);
    d2k = (kY-k);
    nondegen = find(r < 1);
    logLambda = -Inf( 1, d);
    logLambda(nondegen) = cumsum(log(1 - r(nondegen).^2), 'reverse');
    stats.Wilks = exp(logLambda);
    
    % The exponent for Rao's approximation to an F dist'n.  When one (or both) of d1k
    % and d2k is 1 or 2, the dist'n is exactly F.
    s = ones(1,d); % default value for cases where the exponent formula fails
    okCases = find(d1k.*d2k > 2); % cases where (d1k,d2k) not one of (1,2), (2,1), or (2,2)
    snumer = d1k.*d1k.*d2k.*d2k - 4;
    sdenom = d1k.*d1k + d2k.*d2k - 5;
    s(okCases) = sqrt(snumer(okCases) ./ sdenom(okCases));
    
    % The degrees of freedom for H0k
    stats.df1 = d1k .* d2k;
    stats.df2 = (nx - .5*(kX+kY+3)).*s - .5*d1k.*d2k + 1;
    
    % Rao's F statistic
    powLambda = stats.Wilks.^(1./s);
    ratio = Inf( 1, d);
    ratio(nondegen) = (1 - powLambda(nondegen)) ./ powLambda(nondegen);
    stats.F = ratio .* stats.df2 ./ stats.df1;
    stats.pF = fpval(stats.F, stats.df1, stats.df2);

    % Lawley's modification to Bartlett's chi-squared statistic
    stats.chisq = -(nx - k - .5*(kX+kY+3) + cumsum([0 1./r(1:(d-1))].^2)) .* logLambda;
    stats.pChisq = chi2pval(stats.chisq, stats.df1);

    % Legacy fields - these are deprecated
    stats.dfe = stats.df1;
    stats.p = stats.pChisq;
end

function p = fpval(x,df1,df2)
%FPVAL F distribution p-value function.
%   P = FPVAL(X,V1,V2) returns the upper tail of the F cumulative distribution
%   function with V1 and V2 degrees of freedom at the values in X.  If X is
%   the observed value of an F test statistic, then P is its p-value.
%
%   The size of P is the common size of the input arguments.  A scalar input  
%   functions as a constant matrix of the same size as the other inputs.    
%
%   See also FCDF, FINV.

%   References:
%      [1]  M. Abramowitz and I. A. Stegun, "Handbook of Mathematical
%      Functions", Government Printing Office, 1964, 26.6.

%   Copyright 2010 The MathWorks, Inc. 


if nargin < 3, 
    error(message('stats:fpval:TooFewInputs')); 
end

xunder = 1./max(0,x);
xunder(isnan(x)) = NaN;
p = fcdf(xunder,df2,df1);

function p = chi2pval(x,v)
%FPVAL Chi-square distribution p-value function.
%   P = CHI2PVAL(X,V) returns the upper tail of the chi-square cumulative
%   distribution function with V degrees of freedom at the values in X.  If X
%   is the observed value of a chi-square test statistic, then P is its
%   p-value.
%
%   The size of P is the common size of the input arguments.  A scalar input  
%   functions as a constant matrix of the same size as the other inputs.    
%
%   See also CHI2CDF, CHI2INV.

%   References:
%      [1]  M. Abramowitz and I. A. Stegun, "Handbook of Mathematical
%      Functions", Government Printing Office, 1964, 26.4.

%   Copyright 2009 The MathWorks, Inc. 


if nargin < 2
    error(message('stats:chi2pval:TooFewInputs'));
end

[errorcode,x,v] = distchck(2,x,v);

if errorcode > 0
    error(message('stats:chi2pval:InputSizeMismatch'));
end

% Return NaN for out of range parameters.
v(v <= 0) = NaN;
x(x < 0) = 0;

p = gammainc(x/2,v/2,'upper');
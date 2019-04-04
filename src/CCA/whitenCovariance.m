function Rout = whitenCovariance(R, K)
% regularization of pooled covariance
[V, L] = eig(R);
[d, indx] = sort(diag(L),'descend');
V = V(:, indx);
d = d(1:K);
Rout = V(:,1:K)*diag(1./d)*V(:,1:K)';

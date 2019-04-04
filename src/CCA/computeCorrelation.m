function [r, p] =  computeCorrelation(X,Y)

X = squeeze(X);
Y = squeeze(Y);

% compute correlation
nVars=min(size(X,2),size(Y,2));
r=zeros(nVars,1);
p=zeros(nVars,1);
for n=1:nVars
    [rhos,pVals]=corrcoef(X(:,n),Y(:,n),'rows','complete');
    index = 2;
    if length(rhos) < 2
        index = 1;
    end
    r(n)=rhos(1,index);
    p(n)=pVals(1,index);
end
end
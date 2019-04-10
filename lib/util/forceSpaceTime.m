function X = forceSpaceTime(X)
%X=FORCESPACETIME(X)
%   force channels in rows, samples in columns
if ndims(X)>2, error('JD: too many dimensions in input'); end;
if size(X,1)>size(X,2), X=X.'; end 
end


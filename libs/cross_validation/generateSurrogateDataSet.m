function surrogateX = generateSurrogateDataSet(X, numSurrogate)

if nargin < 2
    numSurrogate = 100;
end

[n m] = size(X);
surrogateX = zeros(n,m,numSurrogate);
for i = 1:numSurrogate
        surrogateX(:,:,i) = randomizePhase(X);
end
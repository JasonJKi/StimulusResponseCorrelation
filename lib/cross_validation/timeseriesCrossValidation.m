function [crossValidationIndex] = timeseriesCrossValidation(nSamples, ratioSplit, randomizeIndex)
%timeseriesCrossValidation Summary of this function goes here
% Arrange data set for cross validation.
% Randomize order for indexing samples. two fold cross folidation
% Create randomized order for the data set.
% INPUT
%      
if nargin < 3
    randomizeIndex = true;
end
nFolds = length(ratioSplit);
ratioSum = sum(ratioSplit);
sampleSplit = floor(nSamples/ratioSum);
randNumber = randperm(nFolds,nFolds);
startIndex = 1;
crossValidationIndex = ones(nSamples,1);
for i = 1:nFolds
    lengthRatio = ratioSplit(randNumber(i));
    endIndex = startIndex+lengthRatio*sampleSplit;
    sampleIndices = startIndex:endIndex-1;
    if length(sampleIndices) == 1
        sampleIndices = [];
    else
        startIndex = endIndex;
    end
    if randomizeIndex
        index = randNumber(i);
    else
        index = i;
    end
    crossValidationIndex(sampleIndices) = index;
end
end

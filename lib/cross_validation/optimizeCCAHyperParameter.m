function [kx, ky, maxRhoTest, componentsAccepted, componentSignificance] = optimizeCCAHyperParameter(trainX, trainY, testX, testY, surrogateY, nkx, nky)
%optimizeCCAHyperParameter TODO: Summary of this function goes here
%  [kx, ky, maxRhoTest, componentsAccepted, componentSignificance] = optimizeCCAHyperParameter(trainX, trainY, testX, testY, surrogateY, nkx, nky)


[Rxy, Rxx, Ryy, Ryx] = nanRXY(trainX,trainY); % compute cross covariance

if nargin < 7
    nky = rank(Ryy)
end

if nargin < 6
    nkx = rank(Rxx)
end

if nargin < 5
    surrogateY = generateSurrogateDataSet(testY, 100);
end

maxRhoTest = 0;
kx = nkx; ky = nky;  
componentsAccepted = [];
componentSignificance = [];
maxMuRhoTest = 0;
maxRhoTestKx = 0;
for ix = 9:nkx
    for iy = 20:25
        fprintf('computing kx = %f, ky = %f\n', ix, iy) ;
        [A, B] = cca(trainX, trainY, ix, iy);
        
        U = testX * A;
        V = testY * B;

        % find significant components
        [acceptedComponents, p] = computeWeightSignificance(testY,U,B,surrogateY);

        % Compute correlation over all significant components.
        [rhoTest, p] =  computeCorrelation(U, V);
        muRhoTest = sum(rhoTest(acceptedComponents));

        if muRhoTest > maxMuRhoTest
            componentsAccepted = acceptedComponents;
            componentSignificance = p;
            kx = ix;
            ky = iy;
            maxRhoTest = rhoTest;
            maxMuRhoTest = muRhoTest;
            
            nComponents = sum(componentsAccepted);
            pause(.001)
            fprintf('max kx = %f, ky = %f, nComp = %f rho = %f \n', ...
                kx, ky, nComponents, round(maxMuRhoTest,3)) ;

        end
    end
    if maxRhoTestKx < maxMuRhoTest
        maxRhoTestKx = maxMuRhoTest;
    else
        return
    end
end


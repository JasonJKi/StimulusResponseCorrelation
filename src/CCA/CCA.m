classdef CCA < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        params = CCAParams();
        covMatrix = CCACovMatrix();
        
        % input data
        x
        y
        
        % canonical component weights
        A
        B
        
        % canonical components
        U
        V
    end
    
    methods
        
        function this = CCA(x,y)
            % Set
            setHyperParams(this, size(x,2), size(y,2))
            
            % Normalize train data and assign zero mean (while ignoring nan values).
            [this.x, this.y] = normalize(this, x, y);           
            [rxy, rxx, ryy, ryx] = this.computeNanCov(this.x, this.y);
            this.covMatrix.set(rxy, rxx, ryy, ryx)
        end
        
        function [x, y] = normalize(this, x, y)
            x = this.nanMeanNormalization(x);
            y = this.nanMeanNormalization(y);
        end
        
        function setHyperParams(this, kx, ky)
            this.params.kx = kx;
            this.params.ky = ky;
            setMinDim(this, kx, ky)         
        end

        function [kx, ky, d] = getHyperParams(this)
            kx = this.params.kx;
            ky = this.params.ky;
            d = this.params.d;
        end
        
        function setMinDim(this,kx,ky)
            this.params.d = min(kx, ky);
        end
        
        function [A, B] = computeMaximizedCorrComponents(this)
            [kx, ky, d] = getHyperParams(this);

            [rxy, rxx, ryy, ryx] = this.covMatrix.get();
            
            [rxxRegSqrtInvs, ryyRegInvs, ryyRegSqrtInvs] = this.regularizedInverseCov(rxx, ryy, kx, ky);
            
            M =  rxxRegSqrtInvs * rxy * ryyRegInvs * ryx * rxxRegSqrtInvs; 
            M = (M+M') / 2;
            
            [C,Dc] = eig(M);  
            [~,indx ] =sort(diag(Dc), 'descend');
            C = C(:, indx(1:d)); 
            A = rxxRegSqrtInvs * C;
            
            D = ryyRegSqrtInvs * ryx * rxxRegSqrtInvs * C;
            B = ryyRegSqrtInvs * D;
        end
        
        function [rho p] = fit(this, x, y, A, B)
            if nargin < 1
                x = this.x;
                y = this.y;
                A = this.A;
                B = this.B;
            end
            
            [U, V] = this.computeComponents(x, y, A, B);
            
            setComponents(this, U, V);
            
            [rho, p] = computeCorrelation( U, V);
        end
        
        function [U, V] = getComponents(this)
            U = this.U;
            V = this.V;
        end
        
        function setComponents(this, U, V)
            this.U = U;
            this.V = V;
        end
        
        
        function this = svdRegularize(this, str)
            [kx, ky] = getHyperParams(this);
            switch str
                case 'x'
                    rxx = this.covMatrix.rxx;
                    kx = this.numComponentsExplainingEigenValVariance(rxx);
                case 'y'
                    ryy = this.covMatrix.ryy;
                    ky = this.numComponentsExplainingEigenValVariance(ryy);
            end
            setHyperParams(this, kx, ky)
        end            
        
        function setWeights(A, B)
            this.A = A;
            this.B = B;
        end
        
        function [A, B] = getWeights(this)
            A = this.A;
            B = this.B;
        end
        
        function output = compute(this)
            [this.A, this.B] = computeMaximizedCorrComponents(this);
            output = fit(this, this.x, this.y, this.A, this.B);
        end
        
    end
    
    methods (Static)
        
        function [rxy, rxx, ryy, ryx] = computeNanCov(x, y)
            [rxy, rxx, ryy, ryx] = nanRXY(x, y);
        end
        
        function [U, V] = computeComponents(x, y, A, B)
            U = x*A;
            V = y*B;
        end
        
        
        function [rxxRegSqrtInvs, ryyRegInvs, ryyRegSqrtInvs] = regularizedInverseCov(rxx, ryy, kx, ky)
            rxxRegSqrtInvs = regSqrtInv(rxx, kx); % regularized Rxx^(-1/2)
            ryyRegInvs = regInv(ryy, ky);  % regularized Ryy^-1
            ryyRegSqrtInvs = regSqrtInv(ryy, ky); % regularized Ryy^(-1/2)
        end
        
        function numComponent = numComponentsExplainingEigenValVariance(rxx, eigValThresh)
            if nargin < 2
                eigValThresh = 0.99;
            end
            [~, l] = eig(rxx);
            numComponent = find(cumsum(diag(l)) > eigValThresh,1);
        end
       
        
        function x = nanMeanNormalization(x)
            n = size(x,1); % n - number of samples
            x = x - repmat(nanmean(x,1), n, 1);
        end
        
    end
end
function S2RMap(H,W,nComp,r,p,fs,Ryy,Rxx,locFile,forward)
% plot stim to response spatial and temporal maps
% S2RMap(H,W,nComp,r,p,fs,Ryy,Rxx,locFile)
% H - time weight
% W - spatial weight
% nComp - number of components plotted
% r - correlation value
% p - correlation significance
% fs - sampling rate
% Ryy - pooled covariance of brain response
% Rxx - pooled covariance of stimulus response
% locFile - specify locFile to be used for topoplot
% forward - 0 or 1, to display forward model

colors={'k','r','g','b','r','y'};
if forward;
    A=Ryy*W(:,1:nComp)*inv(W(:,1:nComp)'*Ryy*W(:,1:nComp));
    A=Ryy*W(:,1:nComp)*(W(:,1:nComp)'/Ryy*W(:,1:nComp));
    B=Rxx*H(:,1:nComp)*inv(H(:,1:nComp)'*Rxx*H(:,1:nComp));
else
    A=W;
    B=H;
end

for c=1:nComp
    % forward models
    subplot(2,nComp,c);
    topoplot(A(:,c),locFile,'electrodes','off','numcontour',0,'plotrad',.5);
    
    if ~(isempty(r)||isempty(p));
        title(sprintf('r = %0.2f, p = %0.3f ', r(c), p(c)));
    end
    % impulse responses
    subplot(2,nComp,c+nComp); hold on;
    hp=plot((0:fs-1)/fs,H(1:1*fs,c));
    % set(hp,'color',colors{c});
end

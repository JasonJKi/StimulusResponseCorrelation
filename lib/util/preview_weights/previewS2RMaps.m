function previewS2RMaps(W, H, r, indexComponent, locFile, significance)

%PREVIEWS2RMAPS Summary of this function goes here
%   Detailed explanation goes here
fs = size(H,1);
nComp = length(indexComponent);
if nargin < 6
    significance = ones(nComp,1);
end

for c = 1:nComp
    comp = indexComponent(c);
    subplot(2,nComp, c)
    topoplot(W(:,comp),locFile);
    asterisk = significanceAsterisk(significance(c));
    title(['C' num2str(comp) asterisk])
    subplot(2,nComp,c+nComp); hold on;
    title(['r = ' num2str(round(r(comp),3))])
    plot((0:fs-1)/fs,H(1:1*fs,comp));    
end
end


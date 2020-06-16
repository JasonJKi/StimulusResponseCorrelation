function [U, S, V] = drawSVDTopoplot(eeg, locFilename)
eeg(isnan(eeg)) = 0;
[U,S,V]=svd(eeg);
for c=1:9
    subplot(3,3,c);    
    topoplot(V(:,c), locFilename); 
    colormap('jet');
end
end
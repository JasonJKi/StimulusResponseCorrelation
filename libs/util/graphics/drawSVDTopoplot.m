function [U, S, V] = drawSVDTopoplot(eeg, locFilename)

[U,S,V]=svd(eeg);
for c=1:9
    subplot(3,3,c)    
    topoplot(V(:,c),locFilename); colormap('jet');
end
drawnow


end
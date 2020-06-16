function video = magSquared(video)

for i = 1:size(video,1)
    frame = squeeze(video(i,:,:,:,:));
    frame = abs(frame).^2;
    video(i,:,:,:) = frame; 
    imagesc(frame)
    pause(.01)
%     disp(i)
end
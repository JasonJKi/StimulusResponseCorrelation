function [timeOut,valuesOut]=cutTrigger(time,values)

% time and values have to be in correspondence

figure
plot(time,values);
[x,y]=ginput(2);

% find the samples
[~,minind]=min(abs(time-x(1)));
startSample=minind;
[~,minind]=min(abs(time-x(2)));
endSample=minind;

timeOut=time(startSample:endSample);
valuesOut=values(startSample:endSample);

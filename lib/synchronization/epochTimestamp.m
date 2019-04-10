function epochIndex = epochTimestamp(timestamp,tStart,tEnd)
[startTime, startTimeIndex] = min(abs(timestamp-tStart));
[endTime, endTimeIndex] = min(abs(timestamp-tEnd));
epochIndex = (startTimeIndex:endTimeIndex);


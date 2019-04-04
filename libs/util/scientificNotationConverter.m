function scientificNotation = scientificNotationConverter(number)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
decPlace = 3;
negativeSign = '';
dataType = 'f';
if number < .001
    dataType = 'd';
    decPlace = 2;
end
decPlace = num2str(decPlace);
format = ['%.' decPlace dataType];

scientificNotation = num2str(number, format);
numberFormat = '\times10^';
eIndex = strfind(scientificNotation,'e');
if eIndex
    powerStr = scientificNotation(eIndex+1:end);
    powerStrNumber = regexp(powerStr,'\d*','Match');
    powerStrNumber = powerStrNumber{1};
    
    if strcmp(powerStrNumber(1),'0')
        powerStrNumber(1) = '';
    end
    
    if strcmp(powerStr(1),'-')
        powerStrNumber = ['-' powerStrNumber];
    end
    
    numberStr = scientificNotation(1:eIndex-1);
    scientificNotation = [numberStr numberFormat '{' negativeSign powerStrNumber '}'];
end


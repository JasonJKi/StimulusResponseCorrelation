function asterisk = significanceAsterisk(p)
%significanceAsterisk Summary of this function goes here
%   Detailed explanation goes here

if p > .05
    asterisk = '';
elseif p > .01
    asterisk = '*';
elseif p > .001
    asterisk = '**';
else
    asterisk = '***';
end
    

end


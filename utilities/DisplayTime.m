function str = DisplayTime(ttoc)
% output: returns a human readable string for a time duration 
% input: a numerical value of seconds 




if ttoc < 60
    str = [sprintf('%.2f', ttoc) ' seconds'];
elseif ttoc < 3600
    str = [sprintf('%.2f', ttoc/60) ' minutes'];
elseif ttoc < 86400
    str = [sprintf('%.2f', ttoc/3600) ' hours'];
else
    str = [sprintf('%.2f', ttoc/86400) ' days'];
end

end
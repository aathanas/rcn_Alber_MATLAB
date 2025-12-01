function hostname = getHostname()
    if ispc
        hostname = getenv('COMPUTERNAME');
    else
        hostname = getenv('HOSTNAME');
    end
    if isempty(hostname)
        [~, hostname] = system('hostname');
        hostname = strtrim(hostname);
    end
end
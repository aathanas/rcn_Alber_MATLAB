function assertStructType(s, expected_type, caller)
%% Validate that a struct carries the expected .type field.
%  Throws an error if .type is missing or does not match expected_type.
%
%  Usage: assertStructType(config, 'config', 'MyFunction')

if ~isfield(s, 'type') || ~strcmp(s.type, expected_type)
    actual = '(missing)';
    if isfield(s, 'type'), actual = s.type; end
    error('[%s] Expected struct of type ''%s'', got ''%s''.', ...
        caller, expected_type, actual);
end

end

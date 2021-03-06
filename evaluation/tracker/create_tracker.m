function [tracker] = create_tracker(identifier)

result_directory = fullfile(get_global_variable('directory'), 'results', identifier);

mkpath(result_directory);

if exist(['tracker_' , identifier]) ~= 2 %#ok<EXIST>
    print_debug('WARNING: No configuration for tracker %s found', identifier);
    tracker = struct('identifier', identifier, 'command', [], ...
        'directory', result_directory, 'linkpath', [], 'label', identifier);
    return;
    %error('Configuration for tracker %s does not exist.', identifier);
end;

tracker_label = [];

tracker_configuration = str2func(['tracker_' , identifier]);
tracker_configuration();

if isempty(tracker_label)
    tracker_label = identifier;
end;
    
tracker_label = strtrim(tracker_label);

tracker = struct('identifier', identifier, 'command', tracker_command, ...
        'directory', result_directory, 'linkpath', {tracker_linkpath}, ...
        'label', tracker_label);

tracker.run = @run_tracker;

function [sequences, experiments] = vot_environment()

script_directory = fileparts(mfilename('fullpath'));
include_dirs = cellfun(@(x) fullfile(script_directory,x), {'', 'utilities', ...
    'analysis', 'tracker', 'sequence', 'measures', 'experiment'}, 'UniformOutput', false); 
addpath(include_dirs{:});

initialize_defaults;

set_global_variable('indent', 0);

print_text('Initializing VOT environment ...');

global_configuration = get_global_variable('select_configuration', 'configuration');

try
	environment_configuration = str2func(global_configuration);
    environment_configuration();
catch e
    if exist(global_configuration) ~= 2 %#ok<EXIST>
        print_debug('Global configuration file does not exist. Using defaults.', ...
            global_configuration);
    else
        error(e);
    end; 
end;

mkpath(get_global_variable('directory'));

experiment_stack = get_global_variable('stack', 'vot2013');

if exist(['stack_', experiment_stack]) ~= 2 %#ok<EXIST>
    error('Experiment stack %s not available.', experiment_stack);
end;

stack_configuration = str2func(['stack_', experiment_stack]);

experiments = stack_configuration();

sequences_directory = fullfile(get_global_variable('directory'), 'sequences');

print_text('Loading sequences ...');

sequences = load_sequences(sequences_directory, ...
    get_global_variable('sequences', 'list.txt'));

if isempty(sequences)
	error('No sequences available. Stopping.');
end;

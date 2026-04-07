%% Run all reproduction scripts sequentially.
%  Each script does cd .., so we reset to reproduce/ before each call.

scripts = {'Rep_Figures_1to4', 'Rep_Figure_6', 'Rep_Figure_7', 'Rep_Figure_8', ...
           'Rep_Table_1', 'Rep_Table_2', 'Rep_Table_3', 'Rep_Table_4'};

base = fileparts(mfilename('fullpath'));

for k = 1:numel(scripts)
    cd(base);
    fprintf('\n========== Running %s ==========\n\n', scripts{k});
    run(scripts{k});
end

cd(base);
fprintf('\n========== All reproduction scripts complete ==========\n');

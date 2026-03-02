function FolderCleanup(baseFolder)
% Delete only empty immediate subfolders (one level down) in the specified base folder.
% A subfolder is considered empty if it has no files or sub-subfolders.
% Usage: deleteEmptyImmediateSubfolders('/path/to/your/folder');

if ~isfolder(baseFolder)
    error('Specified base folder does not exist.');
end

% Get immediate subfolders (excluding '.' and '..')
subDirs = dir(fullfile(baseFolder, '*'));
subDirs = subDirs([subDirs.isdir] & ~ismember({subDirs.name}, {'.', '..'}));

% Check each immediate subfolder
for i = 1:length(subDirs)
    subPath = fullfile(baseFolder, subDirs(i).name);

    % Get contents of this subfolder (excluding '.' and '..')
    contents = dir(fullfile(subPath, '*'));
    contents = contents(~ismember({contents.name}, {'.', '..'}));

    % If no contents (no files or sub-subfolders), delete it
    if isempty(contents)
        try
            rmdir(subPath);
            disp(['Deleted empty subfolder: ' subPath]);
        catch ME
            disp(['Failed to delete ' subPath ': ' ME.message]);
        end
    else
        %disp(['Skipping non-empty subfolder: ' subPath]);
    end
end
end
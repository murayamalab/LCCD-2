function Sub_Save_F_SlowComponentRemoved(FolderName, dF_F)

%FolderName = fullfile('Result');
mkdir(FolderName);

FileName = fullfile(FolderName, 'After_SlowComponentCorrection.mat');
save(FileName, 'dF_F', '-v7.3');

end

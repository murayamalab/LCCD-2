function Sub_Save_CorrectedSomaSignal(out_path, Soma, Soma_Correct, correction_constant, dilate_pixel)

FolderName = fullfile(out_path, sprintf('Constant%4.2f_Pixel-in%d-out%d', correction_constant, dilate_pixel.in(1), dilate_pixel.out(end)));
mkdir(FolderName);

Filename = fullfile(FolderName, 'Before_NeuropilCorrection.mat');
F    = Soma.F;
dF_F = Soma.dF_F;
save(Filename,'F', 'dF_F', '-v7.3');

Filename = fullfile(FolderName, 'After_NeuropilCorrection.mat');
F    = Soma_Correct.F;
dF_F = Soma_Correct.dF_F;
save(Filename,'F', 'dF_F', '-v7.3');

end

function MainFun_Correct_NeuropilSignal(path_6B, out_path, options)
    
    close all
    warning('off','MATLAB:MKDIR:DirectoryExists'); % Turn off the waring showing "the directory already exists"
    warning('off','MATLAB:legend:IgnoringExtraEntries'); % Turn off the waring showing "the extra legneds are ignored"
    tic;

    %% Date, file number
    TotalNumFiles = 1:length(dir(fullfile(path_6B, 'ROI_Signal_File*')));%[1:16]; 
    correction_constant = options.correction_constant; %0.7;
    dilate_pixel = options.dilate_pixel;
    SampRate = options.Samprate; %7.65;

    %% Make Save Folder
    %out_path = fullfile(out_path, proc_path);
    mkdir(out_path);
    
    %% Load Pixel Number
    fprintf(1,'\tLoad Pixel Number\n');
    Pixel = Sub_Load_PixelNumberl(path_6B, dilate_pixel);
    % MemoryInfo = memory;
    % fprintf(1,'\t\tMemory uesed by MATLAB %f GB\n',MemoryInfo.MemUsedMATLAB/power(1024,3));
    fprintf(1,'\t\tElapsed time %4.2f min\n\n', toc/60);

    %% Load Soma(ROI) Signal
    fprintf(1,'\tLoad Soma(ROI) Signal\n');
    Soma.F = Sub_Load_SomaSignal(path_6B, TotalNumFiles);
    % MemoryInfo = memory;
    % fprintf(1,'\t\tMemory uesed by MATLAB %f GB\n',MemoryInfo.MemUsedMATLAB/power(1024,3));

    %% Calculate df/f (Soma, After neuropil correction)
    fprintf(1,'\tCalculate df/f (Soma, After neuropil correction)\n');
    Soma.dF_F = Sub_Calculate_dFF(Soma.F);
    fprintf(1,'\t\tElapsed time %4.2f min\n\n', toc/60);

    %% Load Neuropil Signal
    fprintf(1,'\tLoad Neuropil Signal\n');
    Neuropil_EachPixel = Sub_Load_NeuropilSignal(path_6B, dilate_pixel, TotalNumFiles);
    % MemoryInfo = memory;
    % fprintf(1,'\t\tMemory uesed by MATLAB %f GB\n',MemoryInfo.MemUsedMATLAB/power(1024,3));

    %% Calculate Average Neuropil Signal
    fprintf(1,'\tCalculate Average Neuropil Signal\n');
    Neuropil_Average = Sub_Calculate_AverageNeuropilSignal(Pixel, Neuropil_EachPixel);
    fprintf(1,'\t\tElapsed time %4.2f min\n\n', toc/60);

    %% Correction Neuropil Signal
    fprintf(1,'\tCorrection Neuropil Signal\n');
    Soma_Correct.F = Sub_Correction_NeuropilSignal(Soma, Neuropil_Average, correction_constant);
    fprintf(1,'\t\tElapsed time %4.2f min\n\n', toc/60);

    %% Calculate df/f (Soma, After neuropil correction)
    fprintf(1,'\tCalculate df/f (Soma, After neuropil correction)\n');
    % Soma_Correct.dF_F = Sub_Calculate_dFF(Soma_Correct.F);
    Soma_Correct.dF_F = Sub_Calculate_dFF_AddSomaBaseline(Soma_Correct.F, Neuropil_Average, correction_constant);
    fprintf(1,'\t\tElapsed time %4.2f min\n\n', toc/60);

    
    %% Graph F signals before and after correction
    %{
    fprintf(1,'\tGraph F signals before and after correction\n');
    Sub_Graph_SignalF_BeforeAfterCorrection(Soma, Soma_Correct, Neuropil_Average, SampRate, correction_constant, dilate_pixel);
    fprintf(1,'\t\tElapsed time %4.2f min\n\n', toc/60);
    %}
    
    %% Graph F correlation before and after correction
    fprintf(1,'\tGraph F correlation before and after correction\n');
    Sub_Graph_CorrelationF_BeforeAfterCorrection(Soma, Soma_Correct, Neuropil_Average, correction_constant, dilate_pixel, out_path);
    fprintf(1,'\t\tElapsed time %4.2f min\n\n', toc/60);
    
    
    %% Save Corrected Soma Signal
    fprintf(1,'\tSave Corrected Soma Signal\n');
    Sub_Save_CorrectedSomaSignal(out_path, Soma, Soma_Correct, correction_constant, dilate_pixel);
    fprintf(1,'\t\tElapsed time %4.2f min\n\n', toc/60);

end
function MainFun_Evaluate_Correlation_NeuropilSignal(path_6B, out_path, options)
    close all

    warning('off','MATLAB:MKDIR:DirectoryExists'); % Turn off the waring showing "the directory already exists"
    warning('off','MATLAB:legend:IgnoringExtraEntries'); % Turn off the waring showing "the extra legneds are ignored"
    tic;

    %% Date, file number
    TotalNumFiles = 1:length(dir(fullfile(path_6B, 'ROI_Signal_File*')));%[1:16]; 

    %% dilate_pixel
    dilate_pixel = options.dilate_pixel;
    
    Random = 'Yes'; % If 'Yes', select new 'nReadCell' number of cells. If 'No', use the 'nReadCell' number of cells which
    nReadCell = 1000;
    SampRate = options.Samprate; %7.65;

    %% Make Save Folder
    mkdir(out_path);

    %% Load marged ROI
    fprintf(1,'\tLoad marged ROI\n');
    path_3 = dir(fullfile(options.procs.path{3},'marged*'));
    path_3 = sort({path_3.name});
    
    load(fullfile(options.procs.path{3}, path_3{end}, ...
        sprintf('para%02d.mat', length(path_3))), 'n_roi3');
    % load('../4_after_marge_a0.3_constraint60_ROI20-60/marge_soma_ROI.mat', 'soma_ROI');
    soma_ROI =  full(n_roi3);
    nROI = max(soma_ROI(:));
    fprintf(1,'\t\tNumber of ROIs, %d\n\n',nROI);
    
    %% Select Extract Cells
    fprintf(1,'\tLoad marged ROI\n');
    ExtractCells = Sub_Select_ExtracCells(out_path, Random, nReadCell, nROI);
    fprintf(1,'\t\tElapsed time %4.2f min\n\n', toc/60);

    %% Load Soma(ROI) Signal
    fprintf(1,'\tLoad Soma(ROI) Signal\n');
    Soma = Sub_Load_SomaSignal(path_6B, TotalNumFiles, ExtractCells);
    % MemoryInfo = memory;
    % fprintf(1,'\t\tMemory uesed by MATLAB %f GB\n',MemoryInfo.MemUsedMATLAB/power(1024,3));
    fprintf(1,'\t\tElapsed time %4.2f min\n\n', toc/60);

    %% Load Neuropil Signal
    fprintf(1,'\tLoad Neuropil Signal\n');
    Neuropil = Sub_Load_NeuropilSignal(path_6B, dilate_pixel, TotalNumFiles, ExtractCells);
    % MemoryInfo = memory;
    % fprintf(1,'\t\tMemory uesed by MATLAB %f GB\n',MemoryInfo.MemUsedMATLAB/power(1024,3));
    fprintf(1,'\t\tElapsed time %4.2f min\n\n', toc/60);

    %% Calculate Correlation between Soma Signal and Neuropil Signal
    fprintf(1,'\tCalculate Correlation between Soma Signal and Neuropil Signal\n');
    Correlation.SomaNeuropil = Sub_Calculate_Correlation_SomaNeuropil(Soma, Neuropil);
    % MemoryInfo = memory;
    % fprintf(1,'\t\tMemory uesed by MATLAB %f GB\n',MemoryInfo.MemUsedMATLAB/power(1024,3));
    fprintf(1,'\t\tElapsed time %4.2f min\n\n', toc/60);

    %% Calculate Correlation between Neuropil Signals
    fprintf(1,'\tCalculate Correlation between Neuropil Signals\n');
    Correlation.Neuropils = Sub_Calculate_Correlation_Neuropils(Neuropil);
    % MemoryInfo = memory;
    % fprintf(1,'\t\tMemory uesed by MATLAB %f GB\n',MemoryInfo.MemUsedMATLAB/power(1024,3));
    fprintf(1,'\t\tElapsed time %4.2f min\n\n', toc/60);

    %% Calculate RMS between Neuropil Signals
    fprintf(1,'\tCalculate RMS between Neuropil Signals\n');
    RMS.Neuropils = Sub_Calculate_RMS_Neuropils(Neuropil);
    % MemoryInfo = memory;
    % fprintf(1,'\t\tMemory uesed by MATLAB %f GB\n',MemoryInfo.MemUsedMATLAB/power(1024,3));
    fprintf(1,'\t\tElapsed time %4.2f min\n\n', toc/60);

    %% Graph Soma Signal and Neuropil Signal
    %{
    fprintf(1,'\tGraph Soma Signal and Neuropil Signal\n');
    Sub_Graph_SomaSignalNeuropilSignal(Soma, Neuropil, ExtractCells, SampRate, dilate_pixel, out_path);
    fprintf(1,'\t\tElapsed time %4.2f min\n', toc/60);
    %}
end
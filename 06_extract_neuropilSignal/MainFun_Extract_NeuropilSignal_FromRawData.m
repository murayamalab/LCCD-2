function MainFun_Extract_NeuropilSignal_FromRawData(in_path, out_path, h5_path, options)
    close all
    warning('off','MATLAB:MKDIR:DirectoryExists'); % Turn off the waring showing "the directory already exists"
    warning('off','MATLAB:legend:IgnoringExtraEntries'); % Turn off the waring showing "the extra legneds are ignored"
    
    %out_path = fullfile(out_path, proc_path);
    
    tic;

    %% Make Save Folder
    mkdir(out_path);

    %% Load marged ROI
    fprintf(1,'\tLoad marged ROI\n');
    dlis = dir(fullfile(in_path, 'marged*'));
    dlis_n = {dlis.name};
    [~, idx] = sort([dlis.datenum]);
    dlis_end = dlis_n{idx(end)}; 
    load(fullfile(in_path, dlis_end, [strrep(dlis_end, 'marged_ROI', 'para'), '.mat']), 'n_roi3');

    soma_ROI =  full(n_roi3);
    nROI = max(soma_ROI(:));
    fprintf(1,'\t\tNumber of ROIs, %d\n\n',nROI);

    %% Save Neuropil Map for Each ROI If Necessary
    fprintf(1,'\tSave Neuropil Map for Each ROI If Necessary\n');
    Sub_DefineSave_SurroundROIMap_EachROI(soma_ROI, options, out_path);
    
    % MemoryInfo = memory;
    % fprintf(1,'\t\tMemory uesed by MATLAB %f GB\n',MemoryInfo.MemUsedMATLAB/power(1024,3));
    fprintf(1,'\t\tElapsed time %4.2f min\n\n', toc/60);
    c=tmpfuns('get_pos_area', n_roi3);
    save(fullfile(out_path, 'centerpos.mat'), 'c');

    TotalNumFiles = 1:length(dir(fullfile(in_path, 'marged*')))+1;
    for FileNum = TotalNumFiles
        
        %% Load image data
        fprintf(1,'\t\tLoad image data (File No. %d)\n',FileNum);
        LoadFileName = fullfile(h5_path, sprintf('IMG_V%02d.h5',FileNum));
        Image = h5read(LoadFileName, '/mov'); %
        % MemoryInfo = memory;
        % fprintf(1,'\t\tMemory uesed by MATLAB %f GB\n',MemoryInfo.MemUsedMATLAB/power(1024,3));
        fprintf(1,'\t\tElapsed time %4.2f min\n\n', toc/60);
        
        %% Extract & Save ROI Signal
        fprintf(1,'\t\tExtract & Save ROI Signal (File No. %d)\n',FileNum);
        if options.useGPU
            Sub_ExtractSave_ROI_rev2b(soma_ROI, Image, FileNum, c, out_path); % for GPU-PC
        else
            Sub_ExtractSave_ROI_rev1b(soma_ROI, Image, FileNum, c, out_path); % for CPU-PC
        end
        % MemoryInfo = memory;
        % fprintf(1,'\t\tMemory uesed by MATLAB %f GB\n',MemoryInfo.MemUsedMATLAB/power(1024,3));
        fprintf(1,'\t\tElapsed time %4.2f min\n\n', toc/60);
        
        %% Extract and Save Signal Around ROI
        fprintf(1,'\t\tExtract and Save Signal Around ROI (File No. %d)\n',FileNum);
        in  = options.dilate_pixel_for6.in;
        out = options.dilate_pixel_for6.out;
        
        for DNum = 1:length(in)            
            %% Extract Around ROI Signal
            fprintf(1,'\t\t\tExtract Around ROI Signal (File No. %d, %d-%d)\n',FileNum,in(DNum),out(DNum));
            LoadFileName = fullfile(out_path, sprintf('SurroundROI_Map_DilatePixel-in%d-out%d.mat',in(DNum),out(DNum)));
            SaveFileName = fullfile(out_path, sprintf('SurroundROI_Signal_File%02d_DilatePixel-in%d-out%d.mat',FileNum,in(DNum),out(DNum)));
            
            Sub_ExtractSave_SurroundROI(Image, LoadFileName, SaveFileName);
        
        end
        
    end

end    

    
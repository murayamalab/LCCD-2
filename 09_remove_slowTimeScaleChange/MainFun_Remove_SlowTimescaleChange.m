function MainFun_Remove_SlowTimescaleChange(path_8B, out_path, options)
    %clear all
    close all
    warning('off','MATLAB:MKDIR:DirectoryExists'); % Turn off the waring showing "the directory already exists"
    warning('off','MATLAB:legend:IgnoringExtraEntries'); % Turn off the waring showing "the extra legneds are ignored"
    tic;

    global SampRate

    %% Date, file number
    %ReadFileNum = [16];
    SampRate    = options.Samprate; %7.65;     % fps

    %% Make Result Folder
    mkdir(out_path);

    %% Parameters for removing slow component
    remove_slow     = options.remove_slow;

    %%  Parameters for evaluated signals
    correction_constant = options.correction_constant; 
    dilate_pixel = options.dilate_pixel;
    dilate_pixel.in  = min(dilate_pixel.in); % 0 means ROI map detected by LCCD
    dilate_pixel.out = max(dilate_pixel.out); % 'out' should be larger than 'in'

    %% Load Calcium Signal
    fprintf(1,'\tLoad Calcium Signal\n');
    [dF_F, F] = Sub_Load_CalciumSignal(path_8B, correction_constant, dilate_pixel);
    fprintf(1,'\t\tElapsed time %4.2f min\n\n', toc/60);

    %% Calculate Time
    fprintf(1,'\tCalculate Time\n');
    Time = (1:size(dF_F,2))/SampRate;
    fprintf(1,'\t\tElapsed time %4.2f min\n\n', toc/60);

    %% Calculate Slow Timescale Change
    fprintf(1,'\tCalculate Slow Timescale Change\n');
    % OffsetF   = median(F, 2) * ones([1, size(F,2)],'double');
    % BaselineF = Sub_Calculate_SlowTimescaleChange(F+OffsetF, remove_slow);
    BaselineF = Sub_Calculate_SlowTimescaleChange(F, remove_slow);
    fprintf(1,'\t\tElapsed time %4.2f min\n\n', toc/60);

    %% Calculate df/f
    fprintf(1,'\tCalculate df/f\n');
    dF_F_RemoveSlow = (F -  BaselineF)./ BaselineF;
    % dF_F_RemoveSlow = (F+OffsetF -  BaselineF)./ BaselineF;
    fprintf(1,'\t\tElapsed time %4.2f min\n\n', toc/60);

    %% Graph F and Baseline F
    %fprintf(1,'\tGraph F and Baseline F\n');
    %Sub_Graph_F_BaselieF(F, BaselineF, Time);
    %fprintf(1,'\t\tElapsed time %4.2f min\n\n', toc/60);

    %% Graph df/f and Slow Timescale Removed df/f
    %fprintf(1,'\tGraph df/f and Slow Timescale Removed df/f\n');
    %Sub_Graph_dFF_SlowTimescaleRemoved_dFF(dF_F, dF_F_RemoveSlow, Time);
    %fprintf(1,'\t\tElapsed time %4.2f min\n\n', toc/60);

    %% Save F with Slow Component Removed
    fprintf(1,'\tSave F with Slow Component Removed\n');
    Sub_Save_F_SlowComponentRemoved(out_path, dF_F_RemoveSlow);
    fprintf(1,'\t\tElapsed time %4.2f min\n', toc/60);

end
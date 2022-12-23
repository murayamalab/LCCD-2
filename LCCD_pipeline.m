%% Settings
%LCCD_settings;

% make directory for output
mkdir(out_path);

%% pipeline
logfname = fullfile(out_path, 'log.txt');
tStart=tic;

addpath(genpath('.'));

% 01_NoRMCorre
if options.procs.exec(1)
    demo_normCorre_tifFiles(raw_path, options.procs.path{1}, options.opt_noRMCorre);
end
%h5_path = '/home/ysaito/Synology/Collab/with_Kao/Two-photon/02_analysis/u059_m01/20200826_saline/01_ROI_detection/test_YS_ver2/01_NoRMCorre';
% 02_simp_roi_detect
if options.procs.exec(2)
    MainFun_detect_SJIS_2_5(options.procs.path{1}, options.procs.path{2}, options);
end

% 03_roi_marge
if options.procs.exec(3)
    MainFun_roi_marge_NoRMCorre_SJIS(...
        options.procs.path{2}, options.procs.path{3}, options);
end

% 06_extract_neuropilSignal
if options.procs.exec(6)
    
    MainFun_Extract_NeuropilSignal_FromRawData(...
        options.procs.path{3}, ...
        options.procs.path{6}, ...
        options.procs.path{1}, options);
end

if options.procs.exec(7)
    MainFun_Evaluate_Correlation_NeuropilSignal(...
        options.procs.path{6}, options.procs.path{7},options);
end

% 08_correct_neuropilSignal
if options.procs.exec(8)
    MainFun_Correct_NeuropilSignal(...
        options.procs.path{6}, options.procs.path{8}, options);
end

% 09_remove_slowTimeScaleChange
if options.procs.exec(9)
    MainFun_Remove_SlowTimescaleChange(...
    options.procs.path{8}, options.procs.path{9}, options);
end

% 10_calculate_SNratio
if options.procs.exec(10)
    %MainFun_Calculate_SNratio_rev1(path_6B, path_9B, out_path);
    MainFun_QualityMetrics(options.procs.path{3}, ...
        options.procs.path{6}, ...
        options.procs.path{9}, ...
        options.procs.path{10}, ...
        options)
end

% 11_region_ mapping
if options.procs.exec(11)
    MainFun_RegionMapping(...
        atlas_path, ...
        options.procs.path{10}, ...
        options.procs.path{11});
end
tEnd = toc(tStart);
fprintf(1,'\t\tElapsed time %4.2f min\n\n', tEnd/60);
diary off;

code_path = '/home/ysaito/Synology/Collab/with_Kao/Two-photon/00_code/LCCD';
data_Dir = '/home/ysaito/Synology/Collab/with_Kao/Two-photon/01_data/';
raw_path = uigetdir(data_Dir);
out_Dir = replace(raw_path, '01_data', '02_analysis');
out_path = fullfile(erase(cell2mat(regexp(out_Dir, '^.*[/|\\]', 'match')), 'data/'),'01_ROI_detection', '1_ver_2_5');
atlas_path = raw_path;
%raw_path = '/home/ysaito/Synology/Collab/with_Kao/Two-photon/01_data/u059_m01/20200804_saline/data/1';
%out_path = '/home/ysaito/Synology/Collab/with_Kao/Two-photon/02_analysis/u059_m01/20200826_saline/01_ROI_detection/test_YS_ver2_5_all_3';
%h5_path = '/home/ysaito/Synology/Collab/with_Kao/Two-photon/02_analysis/u059_m01/20200826_saline/01_ROI_detection/test_YS_ver2';

procs = {
    '01_NoRMCorre',         1;...
    '02_simp_roi_detect',   1;...
    '03_roi_marge',         1;...
    '',                     0;...
    '',                     0;...
    '06_extract_neuropilSignal',1;...
    '07_evaluate_correlation_neuropilSignal',0;...
    '08_correct_neuropilSignal',1;...
    '09_remove_slowTimeScaleChange',1; ...
    '10_calculate_metrics',1;
    '11_region_mapping',0;};
paths = cellfun(@(x) fullfile(out_path, x), procs(:,1), 'uni', 0);
options.procs = cell2table(cat(2, procs, paths), ...
    'variablenames',{'proc','exec','path'});

options.useGPU = true; %false;

%% parameters 
%% for 01_NoRMCorre
options.opt_noRMCorre.d1 = 2048;
options.opt_noRMCorre.d2 = 2048;
options.opt_noRMCorre.grid_size = [128,128];
options.opt_noRMCorre.overlap_pre = [32,32];
options.opt_noRMCorre.mot_uf = 4;
options.opt_noRMCorre.bin_width = 250;
options.opt_noRMCorre.max_shift = 30;
options.opt_noRMCorre.max_dev = [8,8];
options.opt_noRMCorre.output_type = 'hdf5';
options.opt_noRMCorre.mem_batch_size = 250;
options.opt_noRMCorre.us_fac = 50;
options.opt_noRMCorre.upd_template = 0;
%% for 02_simp_roi_detect
% メキシカン帽フィルタ
options.sfl_size = 7; % 空間フィルタの+-を合わせた大きさ
options.gauss_sigma = 1.25; % 空間フィルタ内部の+部分       
% 移動平均フィルタ
options.filter_size_1 = 100; % (Frame) 遅い成分の削除フィルタ
options.filter_size_2 = 4;   % (Frame) 早い成分の削除フィルタ
% Background substruction rolling ball filter size
options.rollingball = 10; %pixels

% pixel数
options.pixels_range = [30, 120];
% 偏心度
options.eccen_th = 0.99; 
options.err_th = 1.8;

%% for 03_roi_marge
options.a = 0.4; %ROIをマージさせる際の重なっている割合（例：0.3=30%）
%options.pixels_range = [30, 80];

% for 06_extract
options.dilate_pixel_for6.in  = 2:8; %0:10; % 0 means ROI map detected by LCCD
options.dilate_pixel_for6.out = 3:9; %1:11; % 'out' should be larger than 'in'

%% for 07-10
options.dilate_pixel = options.dilate_pixel_for6;

% correction_constant for 8-9
options.correction_constant = 0.7;
options.Samprate = 7.65;

% for 09
% Parameters for removing slow component
options.remove_slow.window     = 15; % (sec)
options.remove_slow.percentile = 8; % (%)

% for 10
% SNR Split frequency
options.SplitFreq = 1.0;   % 0.5;(Hz)
% 
options.Threshold.SN  = 3;  % More than
options.Threshold.dff_ceiling = 10; % Less than
options.Threshold.dff_floor  = -1; % More than
options.Threshold.corr = 0.8; % Threshold for nearby-ROIs correlation
options.Threshold.nearby = 1.5; % 近傍判定（ROI直径に対する比）
%
% IsoretionForest Threshold
options.art_threshold = 0.65;
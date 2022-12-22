function MainFun_QualityMetrics(path_03, path_06, path_09, out_path, options)
%%MAINFUN_QUALITYMETRICS Summary of this function goes here
    % Calculate SNR, Artifact power, ROI features
    global SampRate
    global SplitFreq
    %%
    close all
    warning('off','MATLAB:MKDIR:DirectoryExists'); % Turn off the waring showing "the directory already exists"
    warning('off','MATLAB:legend:IgnoringExtraEntries'); % Turn off the waring showing "the extra legneds are ignored"
    tic;

    %% Parameters
    SampRate  = options.Samprate;
    SplitFreq = options.SplitFreq; % Split frequency used for SNR calculation
    Threshold = options.Threshold; % Threshold for nearby-correlation
    
    %% Load data
    dF_F = load(fullfile(path_09, 'After_SlowComponentCorrection.mat')).dF_F;
    load(fullfile(path_06, 'centerpos.mat'), 'c');
    Time = (1:size(dF_F,2))/SampRate;
    %% Plot Correlated Waves
    d=pdist2(c(:,2:3),c(:,2:3));
    dPerDia=bsxfun(@rdivide,d, c(:,1)*2);
    rdF=corr(dF_F');
    rdF(logical(eye(size(c,1))))=0;
    %Sub_plot_corrWaves(dF_F, dPerDia, out_path);

    %% Split Ca response into signal and noise
    fprintf(1,'\tSplit Ca response into signal and noise\n');
    SNR = Sub_Split_CaResponse_SignalNoise(dF_F, out_path);
   
    %% Calculate Signal Noise Ratio
    fprintf(1,'\tCalculate Signal Noise Ratio\n');
    SNR = Sub_Calculate_SignalNoiseRatio(SNR);

%{
    %% Historgram SNR
    fprintf(1,'\tHistorgram SNR\n');
    Sub_Histogram_SNR(SNR, out_path);
    fprintf(1,'\t\tElapsed time %4.2f min\n\n', toc/60);

    %% Graph Split Ca response and SN ratio
    fprintf(1,'\tGraph Split Ca response and SN ratio\n');
    Sub_Graph_Split_CaResponse_SignalNoise_Ratio(dF_F, SNR, Time, out_path);
    fprintf(1,'\t\tElapsed time %4.2f min\n\n', toc/60);
%}
    %% Check overdivided ROIs 
    [nearby_CellUse, ~] = Sub_Check_nearbyCellToUse(rdF, dPerDia, SNR, Threshold);

    %% Decide Cells to Use
    CellUse = Sub_Decide_CellsToUse(dF_F, SNR, Threshold, nearby_CellUse, out_path);
    
    %% Artifact detection
    fprintf(1,'\tArtifact detection\n');
    dF_F_use = dF_F(CellUse,:);
    Ratio = vertcat(SNR.Ratio);
    SNR_use = Ratio(CellUse);
    art_sig_ratio_use = Sub_ArtifactFreqPower(dF_F_use, SampRate);
    art_sig_ratio = zeros(size(CellUse,1),1);
    art_sig_ratio(CellUse==1)=art_sig_ratio_use;
    art_sig_ratio(CellUse==0)=NaN;
    predicted_outlier_index = Sub_detectOutlier(art_sig_ratio_use, SNR_use, options.art_threshold);
    

    CellUse2 = zeros(size(CellUse,1),1);
    CellIdx = find(CellUse==1);
    CellIdx2 = CellIdx(predicted_outlier_index==0);
    CellUse2(CellIdx2)=1;
    
    %% Plot SNR and artifact/signal freqency power and Signals
    Sub_PlotOutliearDetection(SNR_use, art_sig_ratio_use, predicted_outlier_index, out_path)
    Sub_PlotSignal(Time, dF_F_use, predicted_outlier_index, out_path)
    %% Save ROI Mask images and Metrics
    disp('Create ROI mask images');
    folder_list = dir(fullfile(path_03, 'marged*'));
    file_list = string({dir(append(path_03, '/*/*.mat')).name});
    roi_all = full(load(fullfile(path_03, folder_list(end).name ,file_list(end))).n_roi3);

    nonCell_ID = find(CellUse2==0);
    Cell_ID = find(CellUse2==1);
    
    nonCell_roi = roi_all.*ismember(roi_all, nonCell_ID);
    nonCell_roi_color = label2rgb(nonCell_roi,'hsv','k','shuffle');
    fname_1 = fullfile(out_path, 'ROI_nonCell_color.tiff');
    imwrite(nonCell_roi_color, fname_1);
       
    Cell_roi = roi_all.*ismember(roi_all, Cell_ID);
    Cell_roi_color = label2rgb(Cell_roi,'hsv','k','shuffle');
    fname_2 = fullfile(out_path, 'ROI_Cell_color.tiff');
    imwrite(Cell_roi_color, fname_2);
    
    % ROI metrics, SNR, Artifact Power Ratio, Area, Centroid, CellUse
    ROI_metrics = struct();
    ROI_metrics.SNR = single(Ratio);
    ROI_metrics.Artifact = single(art_sig_ratio');
    ROI_metrics.Area = single(c(:,1));
    ROI_metrics.Centroid = single(c(:,2:3));
    ROI_metrics.CellUse = logical(CellUse2);
    save(fullfile(out_path,'/ROI_metrics.mat'), 'ROI_metrics', '-v7.3');
    
    fprintf(1,'\t\tPercentage of cells to use %f (%%)\n',sum(CellUse2)/length(CellUse2)*100);
    fprintf(1,'\t\tThe number of cells to use %d neurons\n',sum(CellUse2));
end


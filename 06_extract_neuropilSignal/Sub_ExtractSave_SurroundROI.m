function Sub_ExtractSave_SurroundROI_forGPU(Image, LoadFileName, SaveFileName)

if exist(SaveFileName, 'file') == 2% if Load file exists
% if isfile(SaveFileName) % if Load file exists  % Function isfile does not work in Matlab 2015b
    fprintf(1,'\t\t\t%s exits, Not save file\n',SaveFileName);    
else % if Load file does not exist
    fprintf(1,'\t\t\t%s does not exit, Save file\n',SaveFileName);
    
    % Load Surround ROI Coordinate
    load(LoadFileName, 'Index');
    
    % Numbers
    [nPixelY, nPixelX, nFrame]  = size(Image);
    nPixelXY = nPixelX * nPixelY;
    nROI     = length(Index);
    
    % Reshape Image date for extracting fluorescence
    ReshapeData = reshape(Image,[nPixelXY, nFrame]);

    ROI = zeros([nPixelX nPixelY], 'uint16');
    for RNum = 1:nROI
        ROI(Index{RNum}) = RNum;
    end
    
    % Extract fluorescence
    F=cellfun(@(x) mean(ReshapeData(x,:)), Index, 'UniformOutput', false);
    F=reshape(cell2mat(F), nFrame, [])';
    
    % F_Baseline = mean(F,2);
    F_Baseline = median(F,2);
    dF_F_tmp = bsxfun(@minus, F, F_Baseline);
    dF_F_tmp = bsxfun(@rdivide, dF_F_tmp, F_Baseline);
    dF_F     = bsxfun(@minus, dF_F_tmp, min(dF_F_tmp, [], 2));
    
    save(SaveFileName,'F', 'dF_F');
    
    % MemoryInfo = memory;
    % fprintf(1,'\t\t\tMemory uesed by MATLAB %f GB\n',MemoryInfo.MemUsedMATLAB/power(1024,3));
    fprintf(1,'\t\t\tElapsed time %4.2f min\n\n', toc/60);
end



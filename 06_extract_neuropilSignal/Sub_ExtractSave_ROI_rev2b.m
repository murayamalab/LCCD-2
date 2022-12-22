function Sub_ExtractSave_ROI_rev2b(ROI, Image, FileNum, c, out_path)

SaveFileName = fullfile(out_path, sprintf('ROI_Signal_File%d.mat',FileNum));

if exist(SaveFileName, 'file') == 2% if Load file exists
% if isfile(SaveFileName) % if Load file exists  % Function isfile does not work in Matlab 2015b
    fprintf(1,'\t\t\t%s exits, Not save file\n',SaveFileName);
else % if Load file does not exist
    % Numbers
    nPixelX  = size(Image,2);
    nPixelY  = size(Image,1);
    nFrame   = size(Image,3);
    nPixelXY = nPixelX * nPixelY;
    nROI      = max(max((ROI)));

g=gpuDevice(1);    
divN=16;
divC=size(ROI,2)/divN;
cIx=[1, divC+1:divC:size(ROI,2)+1];
ovlap=50;
F_gpu = zeros([nROI nFrame], 'single','gpuArray');
for ix=1:divN
    fprintf(1,'\t\t\t Section No. %d/%d, Elapsed time %4.2f min\n', ix, divN, toc/60);

    % 
    gr_ix=find(c(:,2)>cIx(ix)&c(:,2)<=cIx(ix+1))';
    %[~,idxGr{ix}]=sort(grps{ix});

    % Reshape
    t_ix=(-ovlap:(divC+ovlap))+(ix-1)*divC;
    t_ix((t_ix<1) | (t_ix>nPixelX))=[];
    ReshapeData = reshape(Image(:,t_ix,:),[], nFrame);
    ReshapeROI  = reshape(ROI(:,t_ix),  [], 1);
    
    %ReshapeData = gpuArray(ReshapeData); % -> out of gpuMemory
    ReshapeROI = gpuArray(ReshapeROI);
    
    % Extract Ca response
    b = arrayfun(@eq, ReshapeROI, gr_ix);
    try
    F_gpu(gr_ix,:) = arrayfun(@rdivide, b'*ReshapeData, c(gr_ix,1));
    catch ME
        keyboard();
    end
end

    
    % F_Baseline = mean(F,2);
    F_Baseline = gather(median(F_gpu,2));
    F = gather(F_gpu);
    dF_F_tmp = (F - F_Baseline*ones(1,nFrame))./(F_Baseline*ones(1,nFrame));
    dF_F     = dF_F_tmp - min(dF_F_tmp,[],2)*ones(1,nFrame);

    save(SaveFileName,'F', 'dF_F');
    
    reset(g);
    clear F;
    
    fprintf(1,'\t\t\t%s does not exist, Save file\n',SaveFileName);    
    
end



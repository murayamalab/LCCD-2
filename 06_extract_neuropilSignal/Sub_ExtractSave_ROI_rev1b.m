function Sub_ExtractSave_ROI_rev1b(ROI, Image, FileNum, c, out_path)

%SaveFileName = fullfile('Result', sprintf('ROI_Signal_File%d.mat',FileNum));
SaveFileName = fullfile(out_path, sprintf('ROI_Signal_File%d.mat',FileNum));

if exist(SaveFileName, 'file') == 2% if Load file exists
% if isfile(SaveFileName) % if Load file exists  % Function isfile does not work in Matlab 2015b
    fprintf(1,'\t\t\t%s exits, Not save file\n',SaveFileName);
else % if Load file does not exist
    fprintf(1,'\t\t\t%s does not exit, Save file\n',SaveFileName);
    
    % Numbers
    nPixelX  = size(Image,2);
    nPixelY  = size(Image,1);
    nFrame   = size(Image,3);
    nPixelXY = nPixelX * nPixelY;
    nROI      = max(max((ROI)));
    
%idxG=[];
divN=4;
divC=size(ROI,2)/divN;
cIx=[1, divC+1:divC:size(ROI,2)+1];
grps=cell(divN,1);
for ix=1:divN
grps{ix}=find(c(:,2)>cIx(ix)&c(:,2)<=cIx(ix+1))';
%idxG=horzcat(idxG, grps{ix});
%lenG(ix)=length(tmp);
end
%[~,idxGr]=sort(idxG);
    
F = zeros([nROI nFrame], 'double');
ovlap=50;
for ix=1:divN
    % Reshape
    tmpIx=(-ovlap:(divC+ovlap))+(ix-1)*divC;
    tmpIx((tmpIx<1) | (tmpIx>nPixelX))=[];
    ReshapeData = reshape(Image(:,tmpIx,:),[], nFrame);
    ReshapeROI  = reshape(ROI(:,tmpIx),  [], 1);
    
    % Extract Ca response
    for RNum = grps{ix}
        
        if mod(RNum, 1000) == 0
            fprintf(1,'\t\t\t ROI No. %d, Elapsed time %4.2f min\n', RNum, toc/60);
        end
        
        index = (ReshapeROI == RNum);
        %ROI_Pixel = sum(index);
        F(RNum,:) = sum(ReshapeData(index, :))/c(RNum,1);%ROI_Pixel;
    end
end

    
    % F_Baseline = mean(F,2);
    F_Baseline = median(F,2);
    dF_F_tmp = (F - F_Baseline*ones(1,nFrame))./(F_Baseline*ones(1,nFrame));
    dF_F     = dF_F_tmp - min(dF_F_tmp,[],2)*ones(1,nFrame);
    
    save(SaveFileName,'F', 'dF_F');
    
end



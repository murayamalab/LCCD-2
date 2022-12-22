function Soma = Sub_Load_SomaSignal(in_path, TotalNumFiles)

for FNum = TotalNumFiles
    
    fprintf(1,'\t\tFile Num %d\n',FNum);
    %LoadFileName = fullfile('../6_Extract_NeuropilSignal_FromRawData/Result', sprintf('ROI_Signal_File%d.mat',FNum));
    LoadFileName = fullfile(in_path, sprintf('ROI_Signal_File%d.mat',FNum));
    load(LoadFileName,'F');
    
    if FNum == TotalNumFiles(1) % Initialize
        Soma    = zeros([size(F,1) size(F,2)*length(TotalNumFiles)], 'double');
        %Soma    = zeros([size(F,1) 8000], 'double');
    end
    
    Index = size(F,2)*(FNum-1)+1:size(F,2)*FNum;
    Soma(:,Index) = F;
    
end

fprintf(1,'\t\tElapsed time %4.2f min\n\n', toc/60);

end


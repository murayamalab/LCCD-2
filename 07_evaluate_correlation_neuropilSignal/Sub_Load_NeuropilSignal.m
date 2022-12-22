function Neuropil = Sub_Load_NeuropilSignal(in_path, dilate_pixel, TotalNumFiles, varargin)

in  = dilate_pixel.in;
out = dilate_pixel.out;
if nargin == 4
    ExtractCells = varargin{1};

    % LoadFileName = fullfile(SaveFolderName, sprintf('ROI_Signal_File%d.mat',FileNum));

    for DNum = 1:length(in)
        for FNum = TotalNumFiles
            
            fprintf(1,'\t\tFile Num %d\tDilatePixel-in%d-out%d\n',FNum, in(DNum), out(DNum));
            LoadFileName = fullfile(in_path,...
                sprintf('SurroundROI_Signal_File%02d_DilatePixel-in%d-out%d.mat',FNum,in(DNum),out(DNum)));
            load(LoadFileName,'F', 'dF_F');
            
            if FNum == TotalNumFiles(1) % Initialize
                Neuropil{DNum}.F    = zeros([length(ExtractCells) size(F,2)*length(TotalNumFiles)], 'double');
                Neuropil{DNum}.dF_F = zeros([length(ExtractCells) size(F,2)*length(TotalNumFiles)], 'double');
            end
            Index = size(F,2)*(FNum-1)+1:size(F,2)*FNum;
            Neuropil{DNum}.F(:,Index) = F(ExtractCells,:);
            Neuropil{DNum}.dF_F(:,Index) = dF_F(ExtractCells,:);
        end
    end

else % for 08_correct_neuropilSignal
    for DNum = 1:length(in)
        for FNum = TotalNumFiles
            
            fprintf(1,'\t\tFile Num %d\tDilatePixel-in%d-out%d\n',FNum, in(DNum), out(DNum));
            %LoadFileName = fullfile('../6_Extract_NeuropilSignal_FromRawData/Result',...
            LoadFileName = fullfile(in_path,...
                sprintf('SurroundROI_Signal_File%02d_DilatePixel-in%d-out%d.mat',FNum,in(DNum),out(DNum)));
            load(LoadFileName,'F');
                    
            if DNum == 1 && FNum == TotalNumFiles(1) % Initialize
                Neuropil_EachPixel = zeros([length(in) size(F,1) size(F,2)*length(TotalNumFiles)], 'double');
                %Neuropil_EachPixel = zeros([length(in) size(F,1) 8000], 'double');
            end
            
            Index = size(F,2)*(FNum-1)+1:size(F,2)*FNum;
            Neuropil_EachPixel(DNum,:,Index) = F;
                
        end
        
    end
    Neuropil = Neuropil_EachPixel;

end

fprintf(1,'\t\tElapsed time %4.2f min\n\n', toc/60);

end


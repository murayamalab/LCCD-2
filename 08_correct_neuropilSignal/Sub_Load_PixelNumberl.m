function Pixel = Sub_Load_PixelNumberl(in_path, dilate_pixel)

in  = dilate_pixel.in;
out = dilate_pixel.out;

for DNum = 1:length(in)
    
    fprintf(1,'\t\tDilatePixel-in%d-out%d\n',in(DNum), out(DNum));
    %LoadFileName = fullfile('../6_Extract_NeuropilSignal_FromRawData/Result',...
    LoadFileName = fullfile(in_path,...
        sprintf('SurroundROI_Map_DilatePixel-in%d-out%d.mat',in(DNum),out(DNum)));
    load(LoadFileName,'Index');
    
    if DNum == 1
        Pixel = zeros([length(in) length(Index)], 'uint32');
    end
    Pixel(DNum, :) = uint32(cellfun(@numel, Index));
    
end

end


function Sub_Graph_SomaSignalNeuropilSignal(Soma, Neuropil, ExtractCells, SampRate, dilate_pixel, out_path)

close all

% Time
Time = (1:size(Soma.F,2))/SampRate;

% Signal
SomaF = Soma.F;
NeuropilF = zeros([length(Neuropil) size(Neuropil{1}.F)], 'double');
for DNum = 1:5:length(Neuropil)
    NeuropilF(DNum,:,:) = Neuropil{DNum}.F;
end

% Number
nCell = length(ExtractCells);

% Color
Color_Max = [1 0 1];
Color_Min = [1 0.8 1];
Color = zeros([length(Neuropil) 3], 'double');
for DNum = 1:length(Neuropil)
    Color(DNum,:) = (Color_Max - Color_Min) .* (1-(DNum-1)/length(Neuropil)) + Color_Min;
end

% dilate (Distance from the ROI boundaries)
in  = dilate_pixel.in;
out = dilate_pixel.out;

for CNum = 1:nCell
    
    warning('off','MATLAB:MKDIR:DirectoryExists'); %ディレクトリが既に存在する、という警告の非表示
    fprintf(1,'\t\t\tROI %d\n',ExtractCells(CNum));
    clf('reset');
    
    %% Fluorescence
    hold on
    y = SomaF(CNum,:);
    plot(Time,y, 'Color', [0 0 0], 'Linewidth', 1);
    legendNum  = 1;
    LEGH = legend('Soma','Location','best');
    for DNum = 1:5:length(Neuropil)
        y = squeeze(NeuropilF(DNum,CNum,:));
        % plot(Time,y, 'Color', Color(DNum,:), 'Linewidth', 1);
        plot(Time,y, 'Linewidth', 1);
        
        legendNum  = legendNum + 1;
        legendName = sprintf('DilatePixel-in%d-out%d',in(DNum), out(DNum));
        LEGH.String{legendNum} = legendName;
    end
    hold off
    xlim([Time(1) Time(end)]);
    set(gca,'FontSize',12);
    set(gca,'FontName','Times New Roman');
    xlabel('Time (sec)');
    ylabel('Fluorescence');
    title(sprintf('CellNo %d',ExtractCells(CNum)));
    grid on
    
    % png
    FolderName = fullfile(out_path,'Fluorescence');
    mkdir(FolderName);
    FileName = fullfile(FolderName, sprintf('CellNo%d',ExtractCells(CNum)));
    saveas(gcf, strcat(FileName,'.png'), 'png');
    saveas(gcf, strcat(FileName,'.fig'), 'fig');
    
end % parfor

end



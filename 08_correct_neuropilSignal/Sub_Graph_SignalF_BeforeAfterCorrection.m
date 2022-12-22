function Sub_Graph_SignalF_BeforeAfterCorrection(Soma, Soma_Correct, Neuropil_Average, SampRate, correction_constant, dilate_pixel)

close all
% Time
x = (1:size(Soma.F,2))/SampRate;

% Signal
SomaBefore = Soma.F;
SomaAfter  = Soma_Correct.F;
Neuropil   = Neuropil_Average;

% Cell Number
nCell = size(Soma.F, 1);

% Make folder
FolderName = fullfile('Result', sprintf('Constant%4.2f_Pixel-in%d-out%d', correction_constant, dilate_pixel.in(1), dilate_pixel.out(end)));
mkdir(FolderName);
% parpool('local',12);
parfor CNum = 1:nCell

    if mod(CNum, 50) == 1
    warning('off','MATLAB:MKDIR:DirectoryExists');  % Turn off the waring showing "the directory already exists"
    fprintf(1,'\t\t\tROI %d\n',CNum);
    clf('reset');
    
    %% Fluorescence
    y1 = SomaBefore(CNum,:);
    y2 = SomaAfter(CNum,:);
    y3 = Neuropil(CNum,:);
    
    h = figure('visible','off');
    hold on
    plot(x,y1, 'Color', [0 0 1], 'Linewidth', 1);
    plot(x,y2, 'Color', [1 0 0], 'Linewidth', 1);
    plot(x,y3, 'Color', [0 1 0], 'Linewidth', 1);    
    hold off
    legend('Soma(Before)', 'Soma(After)', 'Neuropil', 'Location','best');

    xlim([x(1) x(end)]);
    set(gca,'FontSize',12);
    set(gca,'FontName','Times New Roman');
    xlabel('Time (sec)');
    ylabel('Fluorescence');
    title(sprintf('CellNo %d',CNum));    
    grid on
    
    % png
    FileName = fullfile(FolderName, sprintf('CellNo_%d',CNum));
    % saveas(gcf, strcat(FileName,'.png'), 'png');
    saveas(gcf, strcat(FileName,'.fig'), 'fig');
    % savefig(h, strcat(FileName,'.fig'));
    % print(h,'-depsc',strcat(FileName,'.eps'));
    print(h,'-dpng', strcat(FileName,'.png'));    
    end
    
end % parfor

end



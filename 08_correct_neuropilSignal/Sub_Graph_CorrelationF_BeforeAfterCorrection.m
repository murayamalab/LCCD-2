function Sub_Graph_CorrelationF_BeforeAfterCorrection(Soma, Soma_Correct, Neuropil_Average, correction_constant, dilate_pixel, out_path)

close all

%% Substitute
Signal(1).Name = 'Soma(Before)';
Signal(1).Data = Soma.F';

Signal(2).Name = 'Soma(After)';
Signal(2).Data = Soma_Correct.F';

Signal(3).Name = 'Neuropil';
Signal(3).Data = Neuropil_Average';


%% Histogram
Edges = -1:0.01:1;
for SNum = 1:length(Signal)
    rho  = corr(Signal(SNum).Data);
    flag = logical(triu(ones(size(rho,2)), 1));
    
    Signal(SNum).Hist.x = (Edges(1:end-1)+Edges(2:end))/2;
    Signal(SNum).Hist.y =  histcounts(rho(flag), Edges);
end

%% Plot
hold on
for SNum = 1:length(Signal)
    plot(Signal(SNum).Hist.x, Signal(SNum).Hist.y, 'LineWidth', 2);
end
hold off
legend(Signal(1).Name, Signal(2).Name, Signal(3).Name, 'Location','best');

xlim([-0.2 1]);
set(gca,'FontSize',12);
set(gca,'FontName','Times New Roman');
xlabel('Correlation');
ylabel('Frequency');
title(sprintf('Constant%4.2f Pixel-in%d-out%d', correction_constant, dilate_pixel.in(1), dilate_pixel.out(end)));
grid on

% Make folder
%FolderName = fullfile('Result', sprintf('Constant%4.2f_Pixel-in%d-out%d', correction_constant, dilate_pixel.in(1), dilate_pixel.out(end)));
FolderName = fullfile(out_path, sprintf('Constant%4.2f_Pixel-in%d-out%d', correction_constant, dilate_pixel.in(1), dilate_pixel.out(end)));
mkdir(FolderName);
FileName = fullfile(FolderName, 'Correaltion');
saveas(gcf, strcat(FileName,'.png'), 'png');
saveas(gcf, strcat(FileName,'.fig'), 'fig');

end

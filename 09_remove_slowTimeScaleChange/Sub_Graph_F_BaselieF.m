function Sub_Graph_F_BaselieF(F, BaselineF, Time)

close all

FolderName = fullfile('Result', 'F_BaselineF');
mkdir(FolderName);

for i = 1:size(F,1)
    
    if mod(i,100)==1
        
        fprintf(1,'\t\t%d\n',i);
        clf('reset')
        
        %% Substitute
        x  = Time;
        y1 = F(i,:);
        % y2 = BaselineF(i,:) - median(F(i,:));
        y2 = BaselineF(i,:);
         
        %% Plot
        hold on
        plot(x, y1);
        plot(x, y2, 'LineWidth', 2);
        hold off
        xlim([x(1) x(end)]);
        set(gca,'FontSize',12);
        set(gca,'FontName','Times New Roman');
        xlabel('Time (s)');
        ylabel('df/f');
        set(gca,'TickDir','out');
        grid on
        title(sprintf('ROI %d',i));
        
        %% Save
        FileName   = fullfile(FolderName, sprintf('F_Baseline_%d',i));
        saveas(gcf, FileName,'png');
        saveas(gcf, FileName,'fig');
    end
end

end


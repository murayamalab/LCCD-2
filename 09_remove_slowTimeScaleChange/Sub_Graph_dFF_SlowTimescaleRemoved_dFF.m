function Sub_Graph_dFF_SlowTimescaleRemoved_dFF(dF_F, dF_F_RemoveSlow, Time)

close all

FolderName = fullfile('Result', 'dff_RemovedSlowdff');
mkdir(FolderName);

for i = 1:size(dF_F,1)
    
    if mod(i,100)==1
        
        fprintf(1,'\t\t%d\n',i);
        clf('reset')
        
        %% Substitute
        x  = Time;
        y1 = dF_F(i,:);
        y2 = dF_F_RemoveSlow(i,:);
        
        %% Plot
        subplot(2,1,1)
        plot(x, y1);
        xlim([x(1) x(end)]);
        set(gca,'FontSize',12);
        set(gca,'FontName','Times New Roman');
        ylabel('df/f');
        set(gca,'TickDir','out');
        grid on
        title('dF/F');
        
        subplot(2,1,2)
        plot(x, y2);
        hold off
        xlim([x(1) x(end)]);
        set(gca,'FontSize',12);
        set(gca,'FontName','Times New Roman');
        ylabel('df/f');
        xlabel('Time (s)');
        set(gca,'TickDir','out');
        grid on
        title('dF/F (Remove Slow Component)');
        
        %% Save
        FileName   = fullfile(FolderName, sprintf('dF_F_%d',i));
        saveas(gcf, FileName,'png');
        saveas(gcf, FileName, 'fig');
    end
end

end


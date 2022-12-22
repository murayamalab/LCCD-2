function Sub2_Save_SurroundROIMap(SaveFilename, Map, Index)

% fig file
close all
%imagesc(Map)
%saveas(gcf,strcat(SaveFilename,'.fig'),'fig');
%close

% mat file
save(strcat(SaveFilename,'.mat'),'Map', 'Index','-v7.3');

end

function ExtractCells = Sub_Select_ExtracCells(out_path, Random, nReadCell, nROI)

FileName = 'ExtractCells.mat';
fprintf(1,'\t\tThe number of read cells %d\n', nReadCell);
if strcmp(Random, 'Yes')
    ExtractCells = randperm(nROI,nReadCell);    
    SaveFileName = fullfile(out_path, FileName);    
    save(SaveFileName,'ExtractCells','-v7.3');
    
elseif strcmp(Random, 'No')
    
    LoadFileName = fullfile(out_path, FileName);
    load(LoadFileName,'ExtractCells');
    
else
    fprintf(1,'\t\t---------Error!!---------\n');
end


end


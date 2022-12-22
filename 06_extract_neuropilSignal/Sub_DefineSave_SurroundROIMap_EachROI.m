function Sub_DefineSave_SurroundROIMap_EachROI(soma_ROI, options, out_path)

in  = options.dilate_pixel_for6.in;
out = options.dilate_pixel_for6.out;
nROI = max(soma_ROI(:));

% if options.useGPU
%    g = gpuDevice(1);
% end

for DNum = 1:length(in)
    
    FileName = sprintf('SurroundROI_Map_DilatePixel-in%d-out%d',in(DNum),out(DNum));
    LoadFileName = fullfile(out_path, FileName);
    
    if exist(strcat(LoadFileName,'.mat'), 'file') == 2% if Load file exists
        fprintf(1,'\t\t%s exits, Not save file\n',FileName);
    else % if Load file does not exist
        fprintf(1,'\t\t%s does not exit, Save file\n',FileName);
        
        SEin  = strel('disk',in(DNum),0);  % Structure for pixel expansion
        SEout = strel('disk',out(DNum),0); % Structure for pixel expansion
        
        Map = zeros(size(soma_ROI), 'uint8');
        if options.useGPU
            soma_ROI = gpuArray(soma_ROI);
        end
        % for RNum = 1:nROI
        parfor RNum = 1:nROI
            % if mod(RNum,1000) == 0
            %     fprintf(1,'\t\t\tROI No. %d, Dilate Pixel %d-%d\n',RNum, in(DNum),out(DNum));
            % end
            
            BW = logical(soma_ROI == RNum);
            Jin  = imdilate(BW,SEin);
            Jout = imdilate(BW,SEout);
            Map_Single = xor(Jout, Jin);%uint8(Jout) - uint8(Jin); % Define the neuropil region of the ROI as 1
            Map_Single(soma_ROI>0) = 0; % If the neruopil region is included in the other ROIs, the region becomes not neruopil region.
            
            Map = Map + uint8(Map_Single);
            
            Index{RNum} = uint32(find(Map_Single==1));
        end
        
        if options.useGPU
            Map = gather(Map);
            Index = cellfun(@gather, Index, 'uni', 0);
        end
        SaveFilename = LoadFileName;
        Sub2_Save_SurroundROIMap(SaveFilename, Map, Index);
        
        fprintf(1,'\t\t\tElapsed time %4.2f min\n\n', toc/60);

    end
    
end

%clear Map Index;
if options.useGPU
    delete(gcp('nocreate'));
end

end

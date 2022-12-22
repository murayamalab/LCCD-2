function demo_normCorre_tifFiles(in_path, out_path, options)
%clear
%gcp;
addpath(genpath('./NoRMCorre-master'));
pnam = in_path; 
mkdir(out_path);
file_list = dir(fullfile(in_path, '*.tiff'));
file_list = {file_list.name};
for ix=1:length(file_list)
    %% set parameters 
%     options = NoRMCorreSetParms(...
% 	                       'd1',im_siz(1),'d2',im_siz(2),...
%                            'grid_size',[128,128],'overlap_pre',[32,32],'mot_uf',4,...
% 	                       'bin_width',50,'max_shift',30,'max_dev',[8,8],...
% 	                       'output_type','hdf5', ...
% 	                       'h5_filename', fullfile(out_path, sprintf('IMG_V%d.h5',ix)), ...
% 	                       'mem_batch_size', 250,...
% 	                       'us_fac',50);
    options.h5_filename = fullfile(out_path, sprintf('IMG_V02%d.h5',ix));
    options = NoRMCorreSetParms(options);
    %fnam = fullfile(pnam, file_list(ix));
    y = loadtiff(fullfile(pnam, file_list{ix}));

	Y = single(y);
    
    %% perform motion correction
    if ndims(y)==3
        if exist('template1', 'var')
           tic; [~,shifts1,~] = normcorre_batch(Y,options,template1); toc
           shifts1a = vertcat(shifts1a, shifts1);
        else
          % template1 = Y(:,:,1);
           tic; [~,shifts1,template1] = normcorre_batch(Y,options); toc     
           shifts1a = shifts1;
        end
    end
    
end
save(fullfile(out_path,'info.mat'), 'shifts1a', 'template1');
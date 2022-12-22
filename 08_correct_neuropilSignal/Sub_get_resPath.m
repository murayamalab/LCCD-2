function m_path = Sub_get_resPath(varargin)
    out_path = varargin{1}; 
    if nargin>1
        procnum = varargin{2};
    end
    
    p_path = out_path(1:regexp(out_path,'\\[1-9].?\w?_\w*')-1);
    %p_path = out_path(1:regexp(out_path,'[\\|/][1-9].?\w?_\w*')-1);
    if isempty(p_path)
        p_path = out_path;
    end
    plist = dir(p_path);
    plist = {plist.name};

    switch nargin
        case 1
            m_path = p_path;
        case 2
            m_path = fullfile(p_path, plist{~cellfun(@isempty, ...
                        regexp(plist, sprintf('^%d.?_*', procnum)))});
    end
    
end
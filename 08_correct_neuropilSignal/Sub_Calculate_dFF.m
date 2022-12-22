function dF_F = Sub_Calculate_dFF(F)

F_Baseline = median(F,2);
dF_F_tmp = (F - F_Baseline*ones(1,size(F,2)))./(F_Baseline*ones(1,size(F,2)));
dF_F     = dF_F_tmp - min(dF_F_tmp,[],2)*ones(1,size(F,2));

end


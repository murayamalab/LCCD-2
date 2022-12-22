function dF_F = Sub_Calculate_dFF_AddSomaBaseline(Soma_CorrectF, Neuropil, r)

F_Baseline = median(Soma_CorrectF,2) + r .* median(Neuropil,2);
%F_Signal   = Soma_CorrectF + r .* median(Neuropil,2);
F_Signal   = bsxfun(@plus, Soma_CorrectF, r .* median(Neuropil,2));

dF_F_tmp = (F_Signal - F_Baseline*ones(1,size(F_Signal,2)))./(F_Baseline*ones(1,size(F_Signal,2)));
dF_F     = dF_F_tmp - min(dF_F_tmp,[],2)*ones(1,size(F_Signal,2));

end


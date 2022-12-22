function Correlation = Sub_Calculate_Correlation_SomaNeuropil(Soma, Neuropil)

Correlation = zeros([length(Neuropil) size(Soma.F,1)] , 'double');

A = Soma.F;
for  DNum = 1:length(Neuropil)
        
    B = Neuropil{DNum}.F;
       
    AB = mean((A - mean(A,2)*ones(1,size(A,2))) .* (B - mean(B,2)*ones(1,size(B,2))), 2);
    AA = mean((A - mean(A,2)*ones(1,size(A,2))) .* (A - mean(A,2)*ones(1,size(A,2))), 2);
    BB = mean((B - mean(B,2)*ones(1,size(B,2))) .* (B - mean(B,2)*ones(1,size(B,2))), 2);
    Correlation(DNum, :) = AB ./ sqrt(AA .* BB);
    
end

close all


end


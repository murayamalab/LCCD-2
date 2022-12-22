function Correlation = Sub_Calculate_Correlation_Neuropils(Neuropil)

Correlation = zeros([length(Neuropil)-1 size(Neuropil{1}.F,1)] , 'double');

for  DNum = 1:length(Neuropil)-1
    
    A = Neuropil{DNum}.F;
    B = Neuropil{DNum+1}.F;
    
    AB = mean((A - mean(A,2)*ones(1,size(A,2))) .* (B - mean(B,2)*ones(1,size(B,2))), 2);
    AA = mean((A - mean(A,2)*ones(1,size(A,2))) .* (A - mean(A,2)*ones(1,size(A,2))), 2);
    BB = mean((B - mean(B,2)*ones(1,size(B,2))) .* (B - mean(B,2)*ones(1,size(B,2))), 2);
    Correlation(DNum, :) = AB ./ sqrt(AA .* BB);
    
end


end


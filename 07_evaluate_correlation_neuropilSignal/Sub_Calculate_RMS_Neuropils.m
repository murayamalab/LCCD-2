function RMS = Sub_Calculate_RMS_Neuropils(Neuropil)

RMS = zeros([length(Neuropil)-1 size(Neuropil{1}.F,1)] , 'double');

for  DNum = 1:length(Neuropil)-1
    
    A = Neuropil{DNum}.F;
    B = Neuropil{DNum+1}.F;    
    RMS(DNum, :) = rms(A-B,2);
    
end


end


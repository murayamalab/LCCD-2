function BaselineF = Sub_Calculate_SlowTimescaleChange(F, remove_slow)

global SampRate

BaselineF  = zeros(size(F), 'double');
WindowSP = int32(remove_slow.window * SampRate);
for SP = 1:size(F,2)
    
    % ExtractSP = SP-WindowSP+1:SP+WindowSP;
    ExtractSP = SP-WindowSP:SP+WindowSP-1;
    if ExtractSP(1) < 1
        ExtractSP = 1:WindowSP*2;
    elseif size(F,2) < ExtractSP(end)
        ExtractSP = SP-WindowSP*2+1:size(F,2);
    end
    ExtractF  = F(:,ExtractSP);
    
    SortF = sort(ExtractF,2);
    PercentileSP    = ceil(size(ExtractF,2) * remove_slow.percentile /100);
    BaselineF(:,SP) = SortF(:,PercentileSP);
    
end

end


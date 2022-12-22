function Neuropil_Average = Sub_Calculate_AverageNeuropilSignal(Pixel, Neuropil_EachPixel)

Pixel_Repeat = repmat(Pixel,[1 1 size(Neuropil_EachPixel,3)]);

Sum_NeuropilPixel = Neuropil_EachPixel .* double(Pixel_Repeat);
Sum_NeuropilPixel = squeeze(sum(Sum_NeuropilPixel,1));

Sum_Pixel = sum(Pixel)' * ones(1, size(Sum_NeuropilPixel,2));
 
Neuropil_Average = Sum_NeuropilPixel ./ Sum_Pixel;

end


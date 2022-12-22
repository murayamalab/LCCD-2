function F = Sub_Correction_NeuropilSignal(Soma, Neuropil_Average, correction_constant)

F = Soma.F - correction_constant .* Neuropil_Average;

end


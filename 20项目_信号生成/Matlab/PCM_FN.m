function [Output_Signal] = PCM_FN(PulserWidth_Time,CenterFrequency,Fs,PCM_CodeNumber)
%PCM_FN 此处显示有关此函数的摘要
%八位巴克码 1110 0101
Phi =[1 1 1 0 0 1 0 1]*pi;
t = linspace(0,PulserWidth_Time*PCM_CodeNumber,Fs);
Output_Signal = 0;
phase = 0;
for ii=1:PCM_CodeNumber 
    u = rectpuls( (t-(ii-1)*PulserWidth_Time-0.5*PulserWidth_Time),PulserWidth_Time ); 
    Output_Signal = Output_Signal + u.*cos(2*pi*CenterFrequency*t+Phi(ii) + phase);
end

end


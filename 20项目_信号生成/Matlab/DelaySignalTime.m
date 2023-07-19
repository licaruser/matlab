function [Signal] = DelaySignalTime(Signal_Delay,DelayTime,Fs)
%DELAYSIGNALTIME 此处显示有关此函数的摘要
% Signal_Delay 延时信号
% DelayTime 延时时长
% Fs 采样率

DelayPoint = DelayTime * Fs;
DelayMatrix = zeros(1,DelayPoint);
Signal = [DelayMatrix,Signal_Delay];
column = length(Signal_Delay);
Signal = Signal(1:column);


end


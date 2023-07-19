clc;clear all; close all;

%目标参数
Jammer_Distance = 200e3;   %200km
Jammer_Velocity = 800;     %800m/s


%信号生成
%% 1、线性调频信号
SimulationTime = 0.06;          %仿真时间 0.1秒
LFM_PRT = 10e-3;               %PRT  10毫秒
LFM_PulseWidth = 2e-3;         %脉宽  2毫秒
LFM_Band = 2.5e6;              %带宽  2.5MHz
Fs = 20e6;                     %采样率 20MHz
LFM_CarrierFrequency = 5e6;    %载频  3.3GHz

LFMSignal = LFM_FN(LFM_PulseWidth,LFM_Band,Fs);
LFM_FillZero = zeros(1,round((LFM_PRT-LFM_PulseWidth)*Fs));
LFMSignal = [LFMSignal,LFM_FillZero];
LFMSignal = repmat(LFMSignal,[1,round(SimulationTime/LFM_PRT)]);



figure
plot(real(LFMSignal))

%% 2、简单脉冲信号
% SimplePulse_Time = 0.1;
SimplePulse_PRT = 10e-3;
SimplePulse_Width = 1e-3;
SimplePulse_CenterFrequency = 0.5e6;
Fs = 20e6;
Simple_Signal = SIMPLE_FN(SimplePulse_Width,SimplePulse_CenterFrequency,Fs);
SimplePulse_FillZero = zeros(1,round((SimplePulse_PRT-SimplePulse_Width)*Fs));
Simple_Signal = [Simple_Signal,SimplePulse_FillZero];
Simple_Signal = repmat(Simple_Signal,[1,round(SimulationTime/SimplePulse_PRT)]);

%% 3、PCM编码信号
PCM_PulsePRT = 10e-3;
PCM_CodeElementNumber = 8;
PCM_PulseWidth = 5e-6;
PCM_CenterFrequency = 0.5e6;
Fs = 20e6;
PCM_Signal = PCM_FN(PCM_PulseWidth,PCM_CenterFrequency,Fs,PCM_CodeElementNumber);
SimplePulse_FillZero = zeros(1,round((PCM_PulsePRT-PCM_PulseWidth*PCM_CodeElementNumber)*Fs));
PCM_Signal = [PCM_Signal,SimplePulse_FillZero];
PCM_Signal = repmat(PCM_Signal,[1,round(SimulationTime/PCM_PulsePRT)]);


figure
plot(abs(PCM_Signal));
%% 脉冲延时
Simple_Signal_DelayTime = 2.2e-3; %简单脉冲信号延迟时间
Simple_Signal = DelaySignalTime(Simple_Signal,Simple_Signal_DelayTime,Fs);

%% 天线合成信号
Total_Signal = LFMSignal + Simple_Signal;
clear LFMSignal Simple_Signal
figure
plot(real(Total_Signal))
%参数估计



%信号分选



%信号生成



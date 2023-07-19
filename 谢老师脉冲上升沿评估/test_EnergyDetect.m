clear all;
clc;
close all;

%% 参数
Fs = 1000;                              %采样率
F0 = 0;                                 %起始频率
Baud = 50;                              %带宽
Taup = 10;                              %脉宽
n = Fs*Taup;                            %信号点数
t = linspace(0, Taup, n);
Dob_N = 128;
% ErrorWindowSize = 250;
ErrorWindowSize = 400;
%% 不同信噪比下，直接用DOB滤波器检测脉冲边沿，估计均方根误差
FftLength = 512;
MontNumber = 5000;
% SnrSeries = -15:1:10;
SnrSeries = 10;
SnrNumber = length(SnrSeries);
PulseUpEdgeRslt_1 = zeros(SnrNumber, MontNumber);
PulseDownEdgeRslt_1 = zeros(SnrNumber, MontNumber);
PulseUpEdgeRslt_2 = zeros(SnrNumber, MontNumber);
PulseDownEdgeRslt_2 = zeros(SnrNumber, MontNumber);
MseUp = zeros(SnrNumber, 6);MseUp(:, 1) = SnrSeries';
MseDown = zeros(SnrNumber, 6);MseDown(:, 1) = SnrSeries';
MseWidth = zeros(SnrNumber, 6);MseWidth(:, 1) = SnrSeries';
detect_cnt=0;
% wb_Match_filter = waitbar(0,'正在处理，请稍候...');
for ii = 1:length(SnrSeries)
    SNR = SnrSeries(ii);
    for k = 1:MontNumber        
        % 1、仿真数据生成

        % 复数数据
        w = [wgn(1, n, 0, 'complex'), wgn(1, n, 0, 'complex'), wgn(1, n, 0, 'complex')];        %噪声功率0dBW
        A = 10^(SNR/20);
%         sig = A*exp(1j*(pi*F0*t+pi*Baud/Taup*t.^2));    %信号功率
        sig = A*exp(1j*pi*20*t);
        s = [zeros(1,n)+1j*zeros(1,n), sig, zeros(1,n)+1j*zeros(1,n)];
        x = s + w;
%         x = w;
        % spectrogram(x,256,250,256,1E3,'yaxis');       %显示时频曲线


        [PulseUpEdgeRslt_2(ii, k) PulseDownEdgeRslt_2(ii, k) UpFlag DownFlag] = EnergyDetect(abs(x));
        if(UpFlag)
           detect_cnt = detect_cnt +1;
        end
        % 3、获得检测及估计的正确率。判断脉冲前后沿以及脉宽是否检测正确（误差在1%以内认为是检测正确）
        % 4、获得估计的均方根误差。
       
        %%%4.2、能量检测方法
        if abs(PulseUpEdgeRslt_2(ii,k)-10000)<ErrorWindowSize
            MseUp(ii, 5) = MseUp(ii, 5) + 1;
            MseUp(ii, 6) = MseUp(ii, 6) + (PulseUpEdgeRslt_2(ii, k)-10000)^2;
        end
        if abs(PulseDownEdgeRslt_2(ii,k)-20000)<ErrorWindowSize
            MseDown(ii, 5) = MseDown(ii, 5) + 1;
            MseDown(ii, 6) = MseDown(ii, 6) + (PulseDownEdgeRslt_2(ii, k)-20000)^2;
        end
        if abs(PulseDownEdgeRslt_2(ii,k)-PulseUpEdgeRslt_2(ii,k))<ErrorWindowSize
            MseWidth(ii, 5) = MseWidth(ii, 5) + 1;
            MseWidth(ii, 6) = MseWidth(ii, 6) + (abs(PulseUpEdgeRslt_2(ii, k)-PulseDownEdgeRslt_2(ii, k))-10000)^2;
        end
%         waitbar(((ii-1)*MontNumber+k)/(MontNumber*SnrNumber), wb_Match_filter);
        end  
    
    if MseUp(ii,5) ~= 0
        MseUp(ii, 6) = sqrt(MseUp(ii,6)/sum(MseUp(ii,5)));
    else
        MseUp(ii, 6) = 0;
    end
    if MseDown(ii,5) ~= 0
        MseDown(ii, 6) = sqrt(MseDown(ii,6)/sum(MseDown(ii,5)));
    else
        MseDown(ii, 6) = 0;
    end
    if MseWidth(ii,5) ~= 0
        MseWidth(ii, 6) = sqrt(MseWidth(ii,6)/sum(MseWidth(ii,5)));
    else
        MseWidth(ii, 6) = 0;
    end
    MseUp(ii, 5) = MseUp(ii, 5)/MontNumber;
    MseDown(ii, 5) = MseDown(ii, 5)/MontNumber;
    MseWidth(ii, 5) = MseWidth(ii, 5)/MontNumber;
end










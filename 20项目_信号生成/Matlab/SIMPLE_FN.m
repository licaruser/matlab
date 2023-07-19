function [Simple_Sig] = SIMPLE_FN(T,B,Fs)
%SIMPLE_FN 此处显示有关此函数的摘要
% T 脉宽
% B 带宽
% Fs 采样率
PulsePointNum = ceil(T*Fs);  %时间*采样率
t = linspace(0,T,PulsePointNum);

Simple_Sig = cos(2*pi*B*t);

% figure
% plot(t,(Simple_Sig));
% 
% Nfft = 2^nextpow2(2*PulsePointNum); %用于计算FFT的长度
% LFM_FFT =fftshift(abs(fft(Simple_Sig,Nfft)));
% % LFM_FFT =(abs(fft(Simple_Sig,Nfft)));
% LFM_FFT_db = 20*log10(LFM_FFT/max(LFM_FFT));
% figure
% set(gca,'FontSize',20);
% ff = 0:Fs/(Nfft-1):Fs;
% ff = ff - Fs/2;
% plot(ff,LFM_FFT_db);
% title('LFM频谱')
% %xlim([min(-Fs/FsTimesB) max(Fs/FsTimesB)])
% xlabel('频率(Hz)')
% ylabel('幅度(dB)')



end


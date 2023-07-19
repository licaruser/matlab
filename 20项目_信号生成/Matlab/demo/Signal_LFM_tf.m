%常见雷达信号的时频分析
%LFM线性调频信号：
%参数设置
B=20e6;  %带宽20MHz
T=10e-6;  %脉宽10us
K=B/T;   %调频斜率
f0=30e6; %中频30MHz
A=10;    %信号幅值
NFFT=512;%FFT点数
fs=4*(f0);  %奈奎斯特采样率
Ts=1/fs;
N=T/Ts;
phi0=0;

%时域和频域波形分析
t=-T/2:Ts:T/2;
S2=A*cos(2*pi*(f0*t+K*t.^2/2.0)+phi0);
figure(1)
subplot(211)
plot(t*1e6, S2, 'b', 'LineWidth', 1.5);
axis on
grid on
xlabel('t/us');
ylabel('S(t)');
axis([2*(-T/2*1e6) 2*(T/2*1e6) -3*A 3*A])
title('LFM线性调频信号时域');

Y2=fft(S2,NFFT);
Y2=Y2/NFFT;
Y22=fftshift(Y2);
Amp=abs(Y22).^2;
F2=linspace(-0.5,0.5,NFFT)*fs;    %双边频率
subplot(212)
plot(F2, Amp,'b', 'LineWidth', 1.5);   %双边幅度
axis([-0.5*fs 0.5*fs 0 1.5*max(Amp)])
axis on
grid on
xlabel('frequence/Hz');
ylabel('Magnitude');
title('LFM线性调频信号频域');

%信号模糊函数分析
ff = hilbert(S2');
[naf,tau,xi]=ambifunb(ff);
figure(2)
subplot(211)
subplot(211)
surf(2*tau,xi,abs(naf).^2,'edgecolor','none')
xlabel('Delay'); 
ylabel('Doppler');
shading interp
title('Narrow-band ambiguity function');
subplot(212)
contour(tau,xi,abs(naf));
xlabel('Delay'); 
ylabel('Doppler');
shading interp
title('模糊函数俯视图');

%常见雷达信号的时频分析
%单载频矩形脉冲信号：
%参数设置
A=10;    %信号幅值
NFFT=512;%FFT点数
T=50e-6;  %脉宽5us
% A=1/sqrt(T);
B=1/T;   %带宽0.2MHz
f0=20e6; %零频/载频20MHz
fs=4*(f0);  %奈奎斯特采样率
Ts=1/fs;
N=T/Ts;
phi0=0;

%时域和频域波形分析
t = -T/2:Ts:T/2;
S1=A*cos(2*pi*f0*t+phi0);
figure(1)
subplot(211)
plot(t*1e6, S1, 'b', 'LineWidth', 1.5);
axis on
grid on
xlabel('t/us');
ylabel('S(t)');
axis([2*(-T/2*1e6) 2*(T/2*1e6) -3*A 3*A])
title('单载频矩形脉冲信号时域');

Y1=fft(S1,NFFT);
Y1=Y1/NFFT;
Y11=fftshift(Y1);
Amp=abs(Y11).^2;
F1=linspace(-0.5,0.5,NFFT)*fs;    %双边频率
subplot(212)
plot(F1, Amp,'b', 'LineWidth', 1.5);   %双边幅度
axis([-0.5*fs 0.5*fs 0 1.5*max(Amp)])
axis on
grid on
xlabel('frequence/Hz');
ylabel('Magnitude');
title('单载频矩形脉冲信号频域');

%信号模糊函数分析
ff = hilbert(S1');
[naf,tau,xi]=ambifunb(ff);
figure(2)
subplot(211)
surf(2*tau,xi,abs(naf).^2,'edgecolor','none')
xlabel('Delay'); 
ylabel('Doppler');
shading interp
title('Narrow-band ambiguity function');
subplot(212)
contour(tau,xi,abs(naf),16);
xlabel('Delay'); 
ylabel('Doppler');
shading interp
title('模糊函数俯视图');
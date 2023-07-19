%常见雷达信号的时频分析
%PSK相位编码信号：
%参数设置
Npulse=8;    %编码位数
dt=0.5e-6; %脉宽0.5us
T=Npulse*dt;  %码周期
f0=30e6; %中频30MHz
A=10;    %信号幅值
NFFT=512;%FFT点数
fs=4*(f0);  %奈奎斯特采样率
Ts=1/fs;
phi0=0;

%时域和频域波形分析
%八位巴克码 1110 0101
Phi =[1 1 1 0 0 1 0 1]*pi;
S3=0;
t=0:Ts:T;
for i=1:Npulse 
    u = rectpuls( (t-(i-1)*dt-0.5*dt),dt ); 
    S3 = S3 + A*u.*cos(2*pi*f0*t+Phi(i)+phi0);
end

figure(1)
subplot(211)
plot(t*1e6, S3, 'b', 'LineWidth', 1.5);
axis on
grid on
xlabel('t/us');
ylabel('S(t)');
axis([-(T*1e6) 2*(T*1e6) -3*A 3*A])
title('PSK八位巴克码信号时域');

Y3=fft(S3,NFFT);
Y3=Y3/NFFT;
Y33=fftshift(Y3);
Amp=abs(Y33).^2;
F3=linspace(-0.5,0.5,NFFT)*fs;    %双边频率
subplot(212)
plot(F3, Amp,'b', 'LineWidth', 1.5);   %双边幅度
axis([-0.5*fs 0.5*fs 0 1.5*max(Amp)])
axis on
grid on
xlabel('frequence/Hz');
ylabel('Magnitude');
title('PSK八位巴克码信号频域');

%信号模糊函数分析
ff = hilbert(S3');
[naf,tau,xi]=ambifunb(ff);
figure(2)
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
clc;
clear all;
close all;

%% 初始值的设置
Fc1=1E9;%中心频率
Fc2=1.5E9;
Fc3=800E6;
Fc4=1.8E9;
Fc5=1.1E9;
Fc6=1.2E9;
Fc7=1.4E9;
Fc8=1.6E9;
Fc9=200E6;
Fc10=400E6;

T1=0.1E-6;%脉宽
PRI_1=20E-6;%重复周期
Bw_1=0.5E6;%调频带宽0.5mhz
K1=Bw_1/T1;
Fs=3E9;%采样频率
Ts=1/3E9;

T2=2E-6;
PRI_2=30E-6;
Bw_2=20E6;
K2=Bw_2/T2;

T3=20E-6;
PRI_3=40E-6;
Bw_3=40E6;
K3=Bw_3/T3;

T4=30E-6;
PRI_4=50E-6;
Bw_4=100E6;
K4=Bw_4/T4;

T5=10E-6;
PRI_5=60E-6;
Bw_5=30E6;
K5=Bw_5/T5;

T6=40E-6;
PRI_6=70E-6;
Bw_6=50E6;
K6=Bw_6/T6;

T7=50E-6;
PRI_7=80E-6;
Bw_7=60E6;
K7=Bw_7/T7;

T8=60E-6;
PRI_8=90E-6;
Bw_8=70E6;
K8=Bw_8/T8;

T9=70E-6;
PRI_9=100E-6;
Bw_9=80E6;
K9=Bw_9/T9;

T10=80E-6;
PRI_10=110E-6;
Bw_10=90E6;
K10=Bw_10/T10;

start_toa=3E-6;%起始的toa
Tc=333E-6;
N=Fs*Tc;
%% LFM信号生成
F_square=zeros(1,int32(start_toa*Fs));
F_square1=zeros(1,int32((PRI_1*0.995)*Fs));
F_square11=zeros(1,int32((PRI_1*0.495)*Fs));
t_1=0:1/Fs:T1-1/Fs;
F_LFM1=exp((2*1i*pi*Fc1*t_1+1i*pi*K1*t_1.^2));
F1=[F_square F_LFM1];
F1_1=[F1 F_square1];
F1_2=[F_LFM1 F_square1];
for i=1:15
    F1_1=[F1_1 F1_2];
end
F1_3=[F1_1 F_LFM1];
y1=[F1_3 F_square11];

F_square2=zeros(1,int32((PRI_2*14/15)*Fs));
% F_square22=zeros(1,int32((PRI_2*3/5)*Fs));
t_2=0:1/Fs:T2-1/Fs;
F_LFM2=exp((2*1i*pi*Fc2*t_2+1i*pi*K2*t_2.^2));
F2=[F_square F_LFM2];
F2_1=[F2 F_square2];
F2_2=[F_LFM2 F_square2];
for i=1:10
    F2_1=[F2_1 F2_2];
end
% F2_3=[F2_1 F_LFM2];
y2=F2_1;

F_square3=zeros(1,int32((PRI_3*1/2)*Fs));
% F_square33=zeros(1,int32((PRI_3*1/4)*Fs));
t_3=0:1/Fs:T3-1/Fs;
t_33=0:1/Fs:T3*1/2-1/Fs;
F_LFM3=exp((2*1i*pi*Fc3*t_3+1i*pi*K3*t_3.^2));
F_LFM3_1=exp((2*1i*pi*Fc3*t_33+1i*pi*K3*t_33.^2));
F3=[F_square F_LFM3];
F3_1=[F3 F_square3];
F3_2=[F_LFM3 F_square3];
for i=1:7
    F3_1=[F3_1 F3_2];
end
% F3_3=[F3_2 F_square3];
% F3_4=[F3_3 F_LFM3];
y3=[F3_1 F_LFM3_1];

F_square4=zeros(1,int32((PRI_4*2/5)*Fs));
% F_square44=zeros(1,int32((PRI_4*1/5)*Fs));
t_4=0:1/Fs:T4-1/Fs;
F_LFM4=exp((2*1i*pi*Fc4*t_4+1i*pi*K4*t_4.^2));
F4=[F_square F_LFM4];
F4_1=[F4 F_square4];
F4_2=[F_LFM4 F_square4];
for i=1:5
    F4_1=[F4_1 F4_2];
end
% F4_3=[F4_2 F_square4];
y4=[F4_1 F_LFM4];

%%cw
t_5=0:1/Fs:T5-1/Fs;
F_square5=zeros(1,int32((PRI_5*5/6)*Fs));
F_square55=zeros(1,int32((PRI_5*1/3)*Fs));
F_CW1=exp(1i*2*pi*Fc5*t_5);
F5=[F_square F_CW1];
F5_1=[F5 F_square5];
F5_2=[F_CW1 F_square5];
for i=1:4
    F5_1=[F5_1 F5_2];
end
F5_3=[F5_1 F_CW1];
y5=[F5_3 F_square55];

t_6=0:1/Fs:T6-1/Fs;
F_square6=zeros(1,int32((PRI_6*3/7)*Fs));
F_square66=zeros(1,int32((PRI_6*1/7)*Fs));
F_CW2=exp(1i*2*pi*Fc6*t_6);
F6=[F_square F_CW2];
F6_1=[F6 F_square6];
F6_2=[F_CW2 F_square6];
for i=1:3
    F6_1=[F6_1 F6_2];
end
F6_3=[F6_1 F_CW2];
y6=[F6_3 F_square66];
%%BPSK
t_7=0:1/Fs:T7-1/Fs;
t_77=0:1/Fs:T7*1/5-1/Fs;
F_square7=zeros(1,int32((PRI_7*3/8)*Fs));
F_BPSK1=exp(1i*(2*pi*Fc7*(t_7)+pi));
F_BPSK11=exp(1i*(2*pi*Fc7*(t_77)+pi));
F7=[F_square F_BPSK1];
F7_1=[F7 F_square7];
F7_2=[F_BPSK1 F_square7];
for i=1:3
    F7_1=[F7_1 F7_2];
end
y7=[F7_1 F_BPSK11];

t_8=0:1/Fs:T8-1/Fs;
% t_88=0:1/Fs:T8*17/18-1/Fs;
F_square8=zeros(1,int32((PRI_8*1/3)*Fs));
F_BPSK2=exp(1i*(2*pi*Fc8*(t_8)+pi));
% F_BPSK22=exp(1i*(2*pi*Fc8*(t_88)+pi));
F8=[F_square F_BPSK2];
F8_1=[F8 F_square8];
F8_2=[F_BPSK2 F_square8];
for i=1:2
    F8_1=[F8_1 F8_2];
end
y8=[F8_1 F_BPSK2];
%%QPSK
t_9=0:1/Fs:T9-1/Fs;
t_99=0:1/Fs:T9*3/7-1/Fs;
F_square9=zeros(1,int32((PRI_9*3/10)*Fs));
F_QPSK1=exp(1i*(2*pi*Fc9*(t_9)+pi/2));
F_QPSK11=exp(1i*(2*pi*Fc9*(t_99)+pi/2));
F9=[F_square F_QPSK1];
F9_1=[F9 F_square9];
F9_2=[F_QPSK1 F_square9];
for i=1:2
    F9_1=[F9_1 F9_2];
end
y9=[F9_1 F_QPSK11];

t_10=0:1/Fs:T10-1/Fs;
F_square10=zeros(1,int32((PRI_10*3/11)*Fs));
F_QPSK2=exp(1i*(2*pi*Fc10*(t_10)+pi/2));
F10=[F_square F_QPSK2];
F10_1=[F10 F_square10];
F10_2=[F_QPSK2 F_square10];
for i=1:2
    F10_1=[F10_1 F10_2];
end
y10=F10_1;
y=y1+y2+y3+y4+y5+y6+y7+y8+y9+y10;
% y=y1;
% a=0;
sig1=y(1:512);
S=abs(fft(sig1));
for i=1:3900 %截取多少段做fft
    sig=y((1+i*256:512+i*256));
    Y1=abs(fft(sig));
    S=[S;Y1;];
%         a=a+1;
%     str=['(' num2str(a) ')'];  %绘制出的图片下标带有序号
%     figure
%     plot(Y1)
%     title('输入脉冲频谱');
%     xlabel({'采样点数';str});
%     ylabel('幅值');
end
sig2=[y(998913:999000) zeros(1,424)];
 Y2=abs(fft(sig2));
 S=[S;Y2;];
 M=S';
% t_all=0:1/Fs:(N-1)*(1/Fs);
% figure(1)
% plot(t_all,real(y));
% title('输入脉冲');
% xlabel('时间/us');
% ylabel('幅值');

%% 提取参数
thr1=100;
thr2=2;
b=[];
c=[];
d=[];
e=[];
z1=zeros(5,1);
B=[];
p=zeros(5,1);
for i=1:3902
    [pks,locs]=findpeaks(M(1:512,i));  %寻找峰值
    num=length(pks);
    a=zeros(1,512);
    for k=1:num
        data=pks(k,:);
       if data>=thr1
           K=locs(k,1);
           a(1,K)=1;
       end
          
    end
    c=[c;a;]; 
end

for i=1:3901
    time1=c(i,1:512);
    time2=c(i+1,1:512);
    ind1=find(time1);  %找出大于0的值列数
    ind2=find(time2);
    L1=length(ind1);                                                                                                  
    L2=length(ind2);
%     
    if L1==0&&L2~=0
        for k=1:L2
            e1=ind2(1,k);
            B1=e1*5.86;         %带宽mhz
            t1=(i+1)*0.085;    %时间us
            p(1,1)=B1;
            p(2,1)=t1;%d第一行是起始信道，第二行起始时间，第三行信道数，第四行终止信道，第五行终止时间
            p(3,1)=e1;%信道数
            d=[d p];
        end
    end
    if L1~=0&&L2~=0
            for k=1:512
                h=time1(1,k);%第k列的数值
                h1=time2(1,k);

                if  h~=0
                   [row,col]=find(ind2>=k-thr2 & ind2<=k+thr2);
                  
%% 信道变化，记录终止信道和终止时间
               
                    if  col>0
                         v1=ind2(1,col);
                         [row1,col1]=find(d(3,:)>=v1-1 & d(3,:)<=v1+1);
                         d(3,col1)=v1;
                        
                    else
                        [row2,col2]=find(d(3,:)>=k-thr2 & d(3,:)<=k+thr2);
                        if col2>0
%                             v2=d(3,col2);%消失信号最终在哪个信道
                            t2=i*0.085;
                            B2=k*5.86;
                            d(4,col2)=B2;
                            d(5,col2)=t2;
                            B=[B d(:,col2)];
                            col_to_delete=col2;
                            d(:,col_to_delete)=[];
                        end
                        
                    end
                     
                end
%                 [row3,col3]=size(d);
                if h1~=0
                    [row_1,col_1]=find(ind1>=k-thr2 & ind1<=k+thr2);
                    temp=isempty(col_1);
                    if temp>0
                        t1=(i+1)*0.085;
                        B1=k*5.86;
                        z1(1,1)=B1;
                        z1(2,1)=t1;
                        z1(3,1)=k;
                        d=[d z1];
                        
                    end
                end
            end
    end
    if L1~=0&&L2==0
        for k=1:L1
        z2=ind1(1,k);
        [row3,col3]=find(d(3,:)>=z2-thr2 & d(3,:)<=z2+thr2);
        if col3>0
%             v3=z1(1,col3);
            t3=i*0.085;
            B3=z2*5.86;
            d(4,col3)=B3;
            d(5,col3)=t3;
            temp2=col3+1;
            B=[B d(:,col3)];
            
        end
        end
    end
        
end
%% DDC数字下变频
Fpass=2.93E6;%通带截止频率
Fstop=8.79E6;%阻带截止频率
taps=512;
overlap=256;%重跌的长度
w=hanning(taps);%汉宁窗
A1=B(2,1);%信号起始时间
A2=B(5,1);%信号结束时间
N1=A1*Fs/1E6;%起始点数
N2=A2*Fs/1E6;
A3=(A2-A1)*1E-6;
N3=N2-N1+1;
y_1=y(N1:N2);
t_all=0:1/Fs:(N3-1)/Fs;
y_tx=real (y_1);
f=0:Fs/N3:Fs-Fs/N3;
figure(1)
plot(t_all,y_tx);
title('输入波形时域');
xlabel('时间/us');
ylabel('幅值');
figure(2);
plot(f/1E9,abs(fft(y_1)));
xlabel('频率/Ghz');
ylabel('幅值');
NCO = exp(-1i.*2.*pi.*Fc1.*t_all); %复本振
base_sig=NCO.*y_1;
fft_plot2(base_sig,Fs,"fre");
real_sig = real(base_sig);
imag_sig = imag(base_sig);
coeff=firhalfband(28,500E6/(Fs/2));
real_sig_filter = filter(coeff,1,real_sig);
imag_sig_filter = filter(coeff,1,imag_sig);
real_sig_filter_down = downsample(real_sig_filter,2);
imag_sig_filter_down = downsample(imag_sig_filter,2);
complex_sig_down=real_sig_filter_down+1i*imag_sig_filter_down;
fft_plot1(complex_sig_down,Fs/2,"fre1");
figure
plot(real_sig_filter_down)
fs_down = Fs/2;
coeff2=firhalfband(28,250E6/(fs_down/2));
real_sig_filter2 = filter(coeff2,1,real(complex_sig_down));
imag_sig_filter2 = filter(coeff2,1,imag(complex_sig_down));
real_sig_filter_down2 = downsample(real_sig_filter2,2);
imag_sig_filter_down2 = downsample(imag_sig_filter2,2);
complex_sig_down2=real_sig_filter_down2+1i*imag_sig_filter_down2;
fft_plot1(complex_sig_down,fs_down/2,"fre1");
figure
plot(real_sig_filter_down2)
fs_down2 = fs_down/2;
coeff3=firhalfband(46,150E6/(fs_down2/2));
real_sig_filter3 = filter(coeff3,1,real(complex_sig_down2));
imag_sig_filter3 = filter(coeff3,1,imag(complex_sig_down2));
real_sig_filter_down3 = downsample(real_sig_filter3,2);
imag_sig_filter_down3 = downsample(imag_sig_filter3,2);
complex_sig_down3=real_sig_filter_down3+1i*imag_sig_filter_down3;
fft_plot1(complex_sig_down3,fs_down2/2,"fre1");
fs_down3=fs_down2/2;
fs_down3_MHz=fs_down3/1E6;
wp=Fpass/(fs_down3/2);
ws=Fstop/(fs_down3/2);
coeff4=firpm(161,[0,wp,ws,1],[1,1,0,0],[1  80],'scale');
real_sig_filter4 = filter(coeff4,1,real(complex_sig_down3));
imag_sig_filter4 = filter(coeff4,1,imag(complex_sig_down3));
complex_sig4=real_sig_filter4+1i*imag_sig_filter4;
fft_plot2(complex_sig4,fs_down3,"fre2");
% figure
% plot(real_sig_filter4)
tt=1:length(complex_sig4);
yaxis1=(0:fs_down3_MHz/512:fs_down3_MHz-fs_down3_MHz/512)-fs_down3_MHz/2;
[tfr,T,F]=tfrcw(complex_sig4.',tt,512);
figure;
imagesc(T,yaxis1/2,fftshift(tfr,1))
xlabel('Time index');
ylabel('f(MHz)');
%% input: y,待分析信号;fs,采样率;s_name,信号名字
function fft_plot1(y,fs,s_name)
    L_i = length(y)*2;
    s_i_fft = fft(y,L_i);
    s_i_fftshfit = fftshift(s_i_fft);
    P = abs(s_i_fftshfit/L_i);
    figure;
    fshift = (-L_i/2:L_i/2-1)*(fs/L_i);
    plot(fshift,P);
    title([s_name,'的双边谱 ']);
    xlabel('f (Hz)');
    ylabel('|P(f)|');
end
function fft_plot2(y,fs,s_name)
    L_i = length(y);
    s_i_fft = fft(y,L_i);
    s_i_fftshfit = fftshift(s_i_fft);
    P = abs(s_i_fftshfit/L_i);
    figure;
    fshift = (-L_i/2:L_i/2-1)*(fs/L_i);
    plot(fshift,P);
    title([s_name,'的双边谱 ']);
    xlabel('f (Hz)');
    ylabel('|P(f)|');
end












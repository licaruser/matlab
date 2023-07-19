clc
clear all
fs=281.75*10^6;
ts = 1/fs;
fm = 2*10^6;
datalen = 247500;
T=datalen*ts;

%T=10e-5;
%datalen=floor(T*fs);

B =50*10^6;
Ndds = 10;
Ndds1  = 32;
Nddsout= 15;%dds输出位数

 mf = floor(((B/2)/fm/(2*pi))*2^(Ndds1/2));
 mf=mod(mf,2^32);
t=((1:datalen)-1)/fs;

p0=0;% 这里的p0是除掉2pi的

ChNum=4;

dataout=zeros(ChNum,datalen);
phase = zeros(ChNum,datalen);



for i=1:ChNum
	init_phase(i) = floor((fm/(ChNum*fs)*(i-1)+p0)*2^(Ndds1));%init_phase(i) = floor((fm/(ChNum*fs)*(i-1)+p0)*2^(Ndds1));
end


k = floor(fm/fs*2^Ndds1);
%x=A*exp(sqrt(-1)*2*pi*((f0-B/2)*t+0.5*u*t.^2+p0));
%-------------------------------------------------------
%二路并行线性调频
%-------------------------------------------------------

for i=1:ChNum

[dataout(i,:),phase(i,:)] =sin_FM_Modulation_Q(mf,k,Ndds,Ndds1,init_phase(i),datalen,Nddsout);
end

% dataouta1 = exp(sqrt(-1)*mf*phasea*2*pi/2^(3*Ndds+2));
% dataoutb1 = exp(sqrt(-1)*mf*phaseb*2*pi/2^(3*Ndds+2));
% dataoutc1 = exp(sqrt(-1)*mf*phasec*2*pi/2^(3*Ndds+2));
% dataoutd1 = exp(sqrt(-1)*mf*phased*2*pi/2^(3*Ndds+2));
% 
 dataout_0 = zeros(1,datalen*ChNum);
% figure
% plot(real(dataout_0)); axis([0,0.5e4,-4e4,4e4]);
for i=1:ChNum
  
   dataout_0(i:ChNum:end) = dataout(i,:); 
end
fvtool(dataout_0)

  %IF调制部分
 phase_r = 32767;
 phase_i = 32767;
 fclk=fs;
 len =datalen;
 
 f_IF =150e6;
 kf_IF =floor(f_IF/fclk*(2^Ndds1-1));
 kf_IF=mod(kf_IF,2^32);
 init_phase_IF=zeros(1,ChNum);
for i=1:ChNum
    init_phase_IF(i) = init_phase_IF(i)+ (i-1)*floor(kf_IF/ChNum);
    [dataout_IF(i,:),phasesum1(i,:)]=singletone_single(kf_IF,init_phase_IF(i),len,Ndds1,11,Nddsout);
end  
   dataout1_IF = zeros(1,len*ChNum);
   for i=1:ChNum
    dataout1_IF(i:ChNum:end) = dataout_IF(i,:);
   end
   
   
   
   
for i=1:ChNum
    for j = 1:len
       data(i,j) = (real(dataout_IF(i,j))*real(dataout(i,j))-imag(dataout_IF(i,j))*imag(dataout(i,j)))/2^15+sqrt(-1)*((real(dataout_IF(i,j))*imag(dataout(i,j))+imag(dataout_IF(i,j))*real(dataout(i,j)))/2^15);
    end
end

 datasave = zeros(1,len*ChNum);
   for i=1:ChNum
     datasave(i:ChNum:end) = data(i,:);
   end
%乘以相控阵因子
   for i=1:ChNum
    for j = 1:len
       data111(i,j) = round((real(data(i,j))*phase_r-imag(data(i,j))*phase_i)/2^15)+(sqrt(-1)*round(imag(data(i,j))*phase_r+real(data(i,j))*phase_i)/2^15);
    end
end
   
   
   
   
figure(2)
subplot(211)
plot(real(dataout_IF(1,:)));axis([0 1000 -1e5 1e5]);
subplot(212)
plot(real(datasave));axis([2000 4000 -1e5 1e5]);

   fvtool(datasave)
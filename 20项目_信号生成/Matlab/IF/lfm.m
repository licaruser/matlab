   clc
   close all
   clear all

   fclk=187.5*10^6;%281.75*10^6;%FPGA工作时钟频率
   ts = 1/fclk;
   B=20*10^6;%带宽HZ
 %  load 'p3_inv.mat';
 %  load 'amp.mat';
 %  load 'sincfir_Num.mat'
  

   T=20e-6;%S
   N=floor(T*fclk);
   f0=0;
   u=B/T;
   p0=0;
   
   len  = floor(T*fclk);
  
   
   Ndds = 10;
   Ndds1  = 32;
   Nddsout= 15;%dds输出位数
   
   ChNum =4;

   
   a=zeros(1,ChNum);
   b=zeros(1,ChNum);
   c=zeros(1,ChNum);
   dataout=zeros(2,len);%dataout=zeros(2,len);
   
 for i=1:ChNum
   a1(i) = floor((1/2)*u*1/fclk^2*(2^Ndds1));
   b1(i) = floor((f0-B/2+(i-1)*u/(ChNum*fclk))/fclk*(2^Ndds1));
   c1(i) = floor((p0/(2*pi)+0.5*u*(i-1)^2/(ChNum*fclk)^2+(f0-B/2)*(i-1)/(ChNum*fclk))*(2^Ndds1));

   a(i)=mod(a1(i),2^32);
   b(i)=mod(b1(i),2^32);
   c(i)=mod(c1(i),2^32);
  
 

  [dataout(i,:),phase(i,:)]=linear_FM_mod(a1(i),b1(i),c1(i),len,Ndds1,Ndds,Nddsout,N);
  
 
 
end  
% a(1) = 610839;a(2) = 610839;a(3) = 610839;a(4) = 610839;
% b(1) = 4065902336; b(2) = 4066207793; b(3) = 4066513213; b(4) = 4066818633 ;
% c(1) = 0 ; c(2) = 4237739243 ; c(3) = 4180587545; c(4) = 
  dataout1 = zeros(1,len*ChNum);
   for i=1:ChNum
     dataout1(i:ChNum:end) = dataout(i,:);

   end
   figure 
    subplot(212)    
plot(real(dataout1));a = title('线性调频信号虚部');
set(gca,'XTick',0:15000/2:15000)
set(gca,'XTicklabel',{'0','10','20us'})
 set(a,'FontSize',10);
 xlabel('时间/us') 
 ylabel('幅度') ;
    subplot(211)
plot(imag(dataout1),'r'); a = title('线性调频信号实部'); 
set(gca,'XTick',0:length(dataout1)/2:length(dataout1))
set(gca,'XTicklabel',{'0','10','20us'})
 set(a,'FontSize',10);
 xlabel('时间/us') 
 ylabel('幅度') ;
   hold on ,
%    fvtool(dataout1)
   
    amplitude =  abs(fftshift(fft(dataout1, length(dataout1))))/length(dataout1);
   f = (0:length(dataout1)-1)/length(dataout1)*fclk*4 - fclk*4/2 ; % 计算频率轴，减Fs/2是为了正确显示0频位置
figure
plot(f./1e6, 10*log10(amplitude))
xlabel('频率(MHz)')
ylabel('幅度(dBm)')
title('LFM信号频谱')
   
   
  %IF调制部分
 phase_r = 8192;
 phase_i = 8192;
 
 
f_doppler =0;
f_IF =0;

 kf_IF1 =floor(f_IF/fclk*(2^Ndds1-1));
 kf_IF = mod(kf_IF1,2^Ndds1-1);
 kf_doppler1 =floor(f_doppler/fclk*(2^Ndds1-1));
 kf_doppler = mod(kf_doppler1,2^Ndds1-1);
 kf_sum = kf_IF  + kf_doppler;
 
 init_phase_IF=zeros(1,ChNum);
 init_phase_doppler=zeros(1,ChNum);
for i=1:ChNum
    init_phase_IF(i) = init_phase_IF(i)+ (i-1)*floor(kf_IF1/ChNum);
    init_phase_doppler(i) = init_phase_doppler(i)+ (i-1)*floor(kf_doppler1/ChNum);
   init_phase_sum(i)= mod(init_phase_IF(i)+init_phase_doppler(i),2^32-1);
    [dataout_IF(i,:),phasesum1(i,:)]=singletone_single(kf_sum,init_phase_sum(i),len,Ndds1,11,Nddsout);
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

   for i=1:ChNum
    for j = 1:len
       data111(i,j) = round((real(data(i,j))*phase_r-imag(data(i,j))*phase_i)/(2^(15+1)))+(sqrt(-1)*round(imag(data(i,j))*phase_r+real(data(i,j))*phase_i)/(2^(15+1)));
    end
end
   
% datasave = zeros(1,len*ChNum);
%    for i=1:ChNum
%      datasave(i:ChNum:end) = data(i,:);
%    end  
%    Y=zeros(1,length(datasave));
%    for ii= 1:len*ChNum
%      F1 = circshift(datasave,[0,ii-1]);
%      Y(ii) = sum(datasave.*F1);
%    end
%    plot(real(Y));
%figure(11)
%subplot(211)
%plot(real(dataout1));axis([30 130 -0.5e5 0.5e5]);
%stem(real(dataout1));axis([30 130 -0.5e5 0.5e5]);
%subplot(212)
%plot(real(datasave));%axis([0 2000 -2e9 2e9]);

%figure(3)
%subplot(111)
%plot(20*log10(abs(fftshift(fft(real(dataout1)+sqrt(-1)*imag(dataout1))))))
  fvtool(datasave)
   
 
%插值仿真
aa=zeros(1,len*ChNum);
aaa = zeros(1,len*ChNum*2);
    aaa(1:2:end) = dataout1(1:1:end);
    aaa(2:2:end) = aa(1:1:end);
fvtool(aaa);

aaa1 = conv(aaa,Num5);
fvtool(aaa1)
   
   
   
   
  
   















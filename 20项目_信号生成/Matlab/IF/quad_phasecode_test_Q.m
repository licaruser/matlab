 clear all
close all
T=0.5*10^-6;
fs = 250*10^6;
ts = 1/fs;
N = floor(T*fs);
P_NUM=4;
% load 'fir_coff_50.mat';
% fir_50_Q = round(fir_50*2^16);
 
Ndds1 = 32;
Ndds = 10;
Nddsout = 15;
phase_init = zeros(1,P_NUM);


k=(1/(4*N)*2^Ndds1);
s=0;
len = 28*N;
dataout_0 = zeros(1,len*P_NUM);

for i=1:P_NUM
   phase_init(i) = (i-1)*round(1/(4*P_NUM*N)*2^Ndds1);
    % [Q_phasecode1]=quad_phasecode_Q(N,s,k,phase_init(i),len,Ndds1,Ndds,Nddsout);
   [dataout]=quad_phasecode_Q(N,s,k,phase_init(i),len,Ndds1,Ndds,Nddsout);
  
%dataout1(i,:)= Q_phasecode1;
   dataout1(i,:)=dataout;
   dataout_0(i:4:end) = dataout;  
end
%dataout_0 ;
% figure(22)
% fvtool(dataout_0);
% subplot(211)
% plot(real(dataout_0(1,1:7000)));
% a = title('泰勒编码信号实部'); 
% set(gca,'XTick',0:length(dataout_0)/4:length(dataout_0)/2)
% set(gca,'XTicklabel',{'0','0.14','0.28'})
%  set(a,'FontSize',10);
%  xlabel('时间/us') 
%  ylabel('幅度') ;
% subplot(212)
% plot(imag(dataout_0(1,1:7000)));
% a = title('泰勒编码信号虚部');
% set(gca,'XTick',0:length(dataout_0)/4:length(dataout_0)/2)
% set(gca,'XTicklabel',{'0','0.14','0.28'})
%  set(a,'FontSize',10);
%  xlabel('时间/us') 
%  ylabel('幅度') ;
     amplitude =  abs(fftshift(fft(dataout_0, length(dataout_0))))/length(dataout_0);
     f = (0:length(dataout_0)-1)/length(dataout_0)*fs*4 - fs*4/2 ; % 计算频率轴，减Fs/2是为了正确显示0频位置
     for i = 1:length(amplitude)
      if(amplitude(i)==0)
       amplitude(i) = amplitude(i);

      else
           amplitude(i) = 10*log10(amplitude(i));
     end
     end
figure
plot(f./1e6, amplitude);
xlabel('频率(MHz)')
ylabel('幅度(dBm)')
title('泰勒编码信号频谱')
% %-------------------------------------------------------
% %四路并行5倍插值滤波，变为20路
% %-------------------------------------------------------
% fir_outa = Interp_FIR_Q(dataouta,dataoutb,dataoutc,dataoutd,fir_50_Q);
% 
% % fir_outa =ones(20,length(dataouta))*2^11;
% 
% fir_out_serial = zeros(1,length(fir_outa(1,:))*20);
% %20路合一路
% for n=1:20
% 
%         fir_out_serial(n:20:end) = fir_outa(n,:);
%         
%        
% end
% 
% %-----------------------------------------------------
% %调制中频，由于20路并行，因此每一路的初始相位都不一样
% %-----------------------------------------------------
% f_IF0 = 1.2*10^9 ;%中频0
% f_IF1 = 1.2*10^9 + 100*10^6;%中频1
% f_IF2 = 1.2*10^9 + 200*10^6;%中频2
% delay0 = 1;
% delay1 = 1;
% delay2 = 1;
% choiceflag =0;
% for i=1:20
%     phase_IF0(i)=floor((f_IF0*(i-1)/(20*fs))*2^Ndds1);%分集模块每一路的初始相位
%     phase_IF1(i)=floor((f_IF1*(i-1)/(20*fs))*2^Ndds1);
%     phase_IF2(i)=floor((f_IF2*(i-1)/(20*fs))*2^Ndds1);
% end
% 
% k0 = floor(f_IF0/fs*2^Ndds1);%频率累计字，exp(-j*k0*n)
% k1 = floor(f_IF1/fs*2^Ndds1);%频率累计字，exp(-j*k1*n)
% k2 = floor(f_IF2/fs*2^Ndds1);%频率累计字，exp(-j*k2*n)
% 
% 
% 
% len1 = length(fir_outa(1,:));
% IF_out_serial = zeros(1,length(fir_outa(1,:))*20);
% for i = 1:20
%     [dataout(i,:)]=fre_diverity_Q(k0,k1,k2,fir_outa(i,:),delay0,delay1,delay2,choiceflag, phase_IF0(i), phase_IF1(i), phase_IF2(i),Ndds,Ndds1,Nddsout);%频率分集
% %     [dataout(i,:)]=fre_diverity(k0,k1,k2,fir_outa(i,:),delay0,delay1,delay2,choiceflag, phase_IF0(i), phase_IF1(i), phase_IF2(i));
% end
% 
% %下面程序不需要fpga中实现，只是测试用。
% IF_out_serial = zeros(1,length(dataout(1,:))*20);
% for i=1:20
% %     IF_out(i,:) = (fir_outa(i,:)).*exp(sqrt(-1)*(2*pi*k*(0:len1-1)+phase_IF(i)));
%     IF_out_serial(i:20:end) = dataout(i,:);
% end
% fvtool(IF_out_serial)

 %IF调制部分
 phase_r = 1024;
 phase_i = 1024;
 fclk = fs;
 ChNum =4;
 f_IF =150e6;
 f_doppler = -20e6;

 kf_IF1 =round(f_IF/fclk*(2^Ndds1-1));
 kf_IF = mod(kf_IF1,2^Ndds1-1);
 kf_doppler1 =round(f_doppler/fclk*(2^Ndds1-1));
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
       data(i,j) = (real(dataout_IF(i,j))*real(dataout1(i,j))-imag(dataout_IF(i,j))*imag(dataout1(i,j)))/2^15+sqrt(-1)*((real(dataout_IF(i,j))*imag(dataout1(i,j))+imag(dataout_IF(i,j))*real(dataout1(i,j)))/2^15);
    end
end

 datasave = zeros(1,len*ChNum);
   for i=1:ChNum
     datasave(i:ChNum:end) = data(i,:);
   end

   for i=1:ChNum
    for j = 1:len
       data111(i,j) = round((real(data(i,j))*phase_r-imag(data(i,j))*phase_i)/(2^(15+1)))+(sqrt(-1)*round(imag(data(i,j))*phase_r+real(data(i,j))*phase_i)/(2^(15+1)));
       %data111(i,j) = round((real(data(i,j))*phase_r-imag(data(i,j))*phase_i)/(2^(15+1)))+(sqrt(-1)*round(imag(data(i,j))*phase_r+real(data(i,j))*phase_i)/(2^(15+1)));
    end
end
   
datasave = zeros(1,len*ChNum);
   for i=1:ChNum
     datasave(i:ChNum:end) = data(i,:);
   end   
   
   
figure(1)
subplot(211)
plot(real(dataout1));axis([0 1000 -2e5 2e5]);
subplot(212)
plot(real(datasave));%axis([0 2000 -2e9 2e9]);

figure(3)
subplot(111)
plot(20*log10(abs(fftshift(fft(real(dataout1)+sqrt(-1)*imag(dataout1))))))
   fvtool(datasave)
   
   
   
   
figure(2)
subplot(211)
plot(real(dataout_IF(1,:)));axis([0 1000 -1e5 1e5]);
subplot(212)
plot(real(datasave));axis([2000 4000 -1e5 1e5]);

   fvtool(datasave)











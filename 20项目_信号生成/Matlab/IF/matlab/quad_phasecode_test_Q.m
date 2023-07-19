 clear all
close all
T=0.02*10^-6;
fs = 250*10^6;
ts = 1/fs;
N = round(T/ts);
P_NUM=4;
% load 'fir_coff_50.mat';
% fir_50_Q = round(fir_50*2^16);
 
Ndds1 = 32;
Ndds = 11;
Nddsout = 15;
init_p = 0;% 2pi归一化
phase_init = zeros(1,P_NUM);


k=round(1/(4*N)*2^Ndds1);
s=0;
len = 14*N;
dataout_0 = zeros(1,len*P_NUM);

for i=1:P_NUM
   phase_init(i) = (i-1)*round(1/(4*P_NUM*N)*2^Ndds1);
   [dataout]=quad_phasecode_Q(N,s,k,phase_init(i),len,Ndds1,Ndds,Nddsout);
   dataout_0(i:4:end) = dataout;  
end
      figure 
    subplot(212)    
plot(imag(dataout_0)); title('四相编码信号虚部');
set(gca,'XTick',0:length(dataout_0)/2:length(dataout_0))
set(gca,'XTicklabel',{'0','0.14','0.28us'})

    subplot(211)
plot(real(dataout_0),'r'); title('四相编码信号实部'); 
set(gca,'XTick',0:length(dataout_0)/2:length(dataout_0))
set(gca,'XTicklabel',{'0','0.14','0.28us'})
   fvtool(dataout_0)
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













 clear all
close all
T=0.02*10^-6;
fs = 281.75*10^6;
ts = 1/fs;
N = floor(T/ts);
P_NUM=4;
% load 'fir_coff_50.mat';
% fir_50_Q = round(fir_50*2^16);
NUM =8;
Ndds1 = 32;
Ndds = 10;
Nddsout = 15;
phase_init = zeros(1,P_NUM);


k=round(1/(4*N)*2^Ndds1);
s=0;

% 二进制相移键控，0到1,1到0，绝对相位控制
binary_code = [1 1 1 1 1 -1 -1 1 1 -1 1 -1 1];
len_code = length(binary_code);
len = len_code*N;
dataout_0 = zeros(1,len*P_NUM);
datalen =  8*length(dataout_0);
phase_d= zeros(P_NUM,len*NUM);

for ii = 1:13
    if binary_code(ii)==1
        for jj =1:N  
          a=ii*N-jj+1;
          phase(a) = 1 * (2^Nddsout-1) ;
        end
    end
     if binary_code(ii)==-1
        for jj=1:N
          b=ii*N-jj+1;
          phase(b) = -1 * (2^Nddsout-1);
        end
        end

end


for j=1:NUM
    for j0 = 1:len
       phase_dd(j0+(j-1)*len) = phase(j0);
    end
end
for j1 = 1:P_NUM
   phase_d(j1,:)=phase_dd;
end
 %for i = 1:P_NUM
 %  for j = 1:520
 %    phase_d(i,j) = phase_d(i,j) + sqrt(-1)*0;
 %  end
 %end
%for i=1:P_NUM
%   phase_init(i) = (i-1)*round(1/(4*P_NUM*N)*2^Ndds1);
%   dataout=;
%   dataout1(i,:)=dataout;
%   dataout_0(i:4:end) = dataout;  
%end

   Y=zeros(1,len);
   for ii= 1:len
     F1 = circshift(phase,[0,ii-1]);
     Y(ii) = sum(phase.*F1);
   end
   plot(Y);
fvtool(phase_dd)
figure(33)
subplot(111)
plot(phase_dd(1:520/8));
title('巴克码序列');
set(gca,'XTick',0:520/8/2:520/8)
set(gca,'XTicklabel',{'0','1.3','2.6us'})
%IF调制部分
datalen=length(phase_d(1,:));
 phase_r = 1024;
 phase_i = 1024;
 ChNum =4;
 f_IF =150e6;
 kf_IF =floor(f_IF/fs*(2^Ndds1-1));
 kf_IF=mod(kf_IF,2^32);
 init_phase_IF=zeros(1,ChNum);
for i=1:ChNum
    init_phase_IF(i) = init_phase_IF(i)+ (i-1)*floor(kf_IF/ChNum);
    [dataout_IF(i,:),phasesum1(i,:)]=singletone_single(kf_IF,init_phase_IF(i),datalen,Ndds1,11,Nddsout);
end  
   dataout1_IF = zeros(1,datalen*ChNum);
   for i=1:ChNum
    dataout1_IF(i:ChNum:end) = dataout_IF(i,:);
   end
   
   
   
   
for i=1:ChNum
    for j = 1:datalen
       data(i,j) = (real(dataout_IF(i,j))*real(phase_d(i,j))-imag(dataout_IF(i,j))*imag(phase_d(i,j)))/2^15+sqrt(-1)*((real(dataout_IF(i,j))*imag(phase_d(i,j))+imag(dataout_IF(i,j))*real(phase_d(i,j)))/2^15);
    end
end

 datasave = zeros(1,datalen*ChNum);
   for i=1:ChNum
     datasave(i:ChNum:end) = data(i,:);
   end

   for i=1:ChNum
    for j = 1:datalen
       data111(i,j) = round((real(data(i,j))*phase_r-imag(data(i,j))*phase_i)/(2^(15+1)))+(sqrt(-1)*round(imag(data(i,j))*phase_r+real(data(i,j))*phase_i)/(2^(15+1)));
    end
end
   
datasave = zeros(1,datalen*ChNum);
   for i=1:ChNum
     datasave(i:ChNum:end) = data(i,:);
   end   
   figure(2)
   subplot(111)
   plot(data(1,:));
   fvtool(data(1,:))
   
   

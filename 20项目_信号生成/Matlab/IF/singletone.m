   clc
   close all
   clear all



   fclk=187.5*10^6;%FPGA工作时钟频率
   ts = 1/fclk;
   f=20e6; %信号频率
  

   T=20e-6;

   p0=0;% p0/2pi
   
   len  = round(T*fclk);
   
   
   Ndds = 10;
   Ndds1  = 32;
   Nddsout= 15;%dds输出位数
   
   ChNum =4;%3;

   
   a=zeros(1,ChNum);
   b=zeros(1,ChNum);
   c=zeros(1,ChNum);
   dataout=zeros(2,len);
   init_phase=zeros(1,ChNum);
   init_phase1=zeros(1,ChNum);
   kf2= f/fclk*(2^Ndds1-1);
   kf1=floor(f/fclk*(2^Ndds1-1));
   kf=mod(kf1,2^32);
   
   
   kf21g= f/(fclk*4)*(2^Ndds1-1);
   kf11g=floor(f/(fclk*4)*(2^Ndds1-1));
   
   
 for i=1:ChNum
   
   
    % init_phase(i) = init_phase(i)+ (i-1)*floor(kf2/ChNum);
    init_phase(i) = init_phase(i)+ (i-1)*(kf2/ChNum);
     init_phase(i)=floor( mod(init_phase(i),(2^32)));
    [dataout(i,:),phasesum0(i,:)]=singletone_single(kf,init_phase(i),len,Ndds1,Ndds,Nddsout);
end  
  
   dataout1 = zeros(1,len*ChNum);
   for i=1:ChNum
     dataout1(i:ChNum:end) = dataout(i,:);
   end
%       figure 
%     subplot(212)    
% plot(real(dataout1)); a=title('点频信号虚部');
% set(gca,'XTick',0:15000/2:15000)
% set(gca,'XTicklabel',{'0','10','20us'})
% set(a,'FontSize',10);
% xlabel('时间/us') 
% ylabel('幅度') ;
%     subplot(211)
% plot(imag(dataout1),'r'); title('点频信号实部'); 
% set(gca,'XTick',0:length(dataout1)/2:length(dataout1))
% set(gca,'XTicklabel',{'0','10','20us'})
% set(a,'FontSize',10);
% xlabel('时间/us') 
% ylabel('幅度') ;
%    fvtool(dataout1)

 amplitude =  abs(fftshift(fft(dataout1, length(dataout1))))/length(dataout1);
   f = (0:length(dataout1)-1)/length(dataout1)*fclk*4 - fclk*4/2 ; % 计算频率轴，减Fs/2是为了正确显示0频位置
figure
plot(f./1e6, 10*log10(amplitude))
xlabel('频率(MHz)')
ylabel('幅度(dBm)')
title('20M信号频谱')
   %%创建RAM文件 位宽128位数据 RAM文件位宽512 拼位

        file_name_i = strcat('SIN_I.coe');
        file_name_q = strcat('SIN_Q.coe');
         fid1_i=fopen(file_name_i,'wb');
          fid1_q=fopen(file_name_i,'wb');
fprintf( fid1_i, 'memory_initialization_radix = 10;\n');                     
fprintf( fid1_i, 'memory_initialization_vector =\n')
fprintf( fid1_q, 'memory_initialization_radix = 10;\n');                     
fprintf( fid1_q, 'memory_initialization_vector =\n') 
  for ii=1:8192
%     Idata=xc_i(i,ii);
%     Qdata=xc_q(i,ii);
 Idata=real(dataout1(ii));
 Qdata=imag(dataout1(ii));

 %   if(Idata<0)
 %       Idata=2^32+Idata;
 %   end
 %   if(Qdata<0)
 %       Qdata=2^32+Qdata;
 %   end
    fprintf(fid1_i,'%0.0f\n',Idata);
    fprintf(fid1_q,'%0.0f\n',Qdata);
end
   
   fclose(fid1_i)
   fclose(fid1_q)
   
   
   
   
   
%    
%    
%    
%  %IF调制部分
%  phase_r = 1024;
%  phase_i = 1024;
%  
%  f_IF =20e6;
%  f_doppler =0;%250; %飞机速度900KM/h
% 
%  kf_IF1 =floor(f_IF/fclk*(2^Ndds1-1));
%  kf_IF = mod(kf_IF1,2^Ndds1-1);
%  kf_doppler1 =floor(f_doppler/fclk*(2^Ndds1-1));
%  kf_doppler = mod(kf_doppler1,2^Ndds1-1);
%  kf_sum = kf_IF  + kf_doppler;
%  
%  init_phase_IF=zeros(1,ChNum);
%  init_phase_doppler=zeros(1,ChNum);
% for i=1:ChNum
%     init_phase_IF(i) = init_phase_IF(i)+ (i-1)*floor(kf_IF1/ChNum);
%     init_phase_doppler(i) = init_phase_doppler(i)+ (i-1)*floor(kf_doppler1/ChNum);
%    init_phase_sum(i)= mod(init_phase_IF(i)+init_phase_doppler(i),2^32-1);
%     [dataout_IF(i,:),phasesum1(i,:)]=singletone_single(kf_sum,init_phase_sum(i),len,Ndds1,11,Nddsout);
% end  
%    dataout1_IF = zeros(1,len*ChNum);
%    for i=1:ChNum
%     dataout1_IF(i:ChNum:end) = dataout_IF(i,:);
%    end
%    
%    
%    
%    
% for i=1:ChNum
%     for j = 1:len
%        data(i,j) = (real(dataout_IF(i,j))*real(dataout(i,j))-imag(dataout_IF(i,j))*imag(dataout(i,j)))/2^15+sqrt(-1)*((real(dataout_IF(i,j))*imag(dataout(i,j))+imag(dataout_IF(i,j))*real(dataout(i,j)))/2^15);
%     end
% end
% 
%  datasave = zeros(1,len*ChNum);
%    for i=1:ChNum
%      datasave(i:ChNum:end) = data(i,:);
%    end
% 
%    for i=1:ChNum
%     for j = 1:len
%        data111(i,j) = round((real(data(i,j))*phase_r-imag(data(i,j))*phase_i)/(2^(15+1)))+(sqrt(-1)*round(imag(data(i,j))*phase_r+real(data(i,j))*phase_i)/(2^(15+1)));
%     end
% end
%    
% datasave = zeros(1,len*ChNum);
%    for i=1:ChNum
%      datasave(i:ChNum:end) = data(i,:);
%    end   
%    
%    
% figure(1)
% subplot(211)
% plot(real(dataout1));axis([0 1000 -2e5 2e5]);
% subplot(212)
% plot(real(datasave));%axis([0 2000 -2e9 2e9]);
% 
% figure(3)
% subplot(111)
% plot(20*log10(abs(fftshift(fft(real(dataout1)+sqrt(-1)*imag(dataout1))))))
%    fvtool(datasave)
%    
%  
% 
% 
%         %写文件
%    %%第二阶文件
% 
% %         file_name_i = strcat(strcat('sim_data_I',num2str(i)),'.dat');
% %         file_name_q = strcat(strcat('sim_data_Q',num2str(i)),'.dat');
%         file_name_i = strcat('SIN_I.coe');
%         file_name_q = strcat('SIN_Q.coe');
%     
%         
%         
%          fid1_i=fopen(file_name_i,'wb');
%          fid1_q=fopen(file_name_q,'wb');
%          
% fprintf( fid1_i, 'memory_initialization_radix = 10;\n');                     
% fprintf( fid1_i, 'memory_initialization_vector =\n')
%          
% fprintf( fid1_q, 'memory_initialization_radix = 10;\n');                     
% fprintf( fid1_q, 'memory_initialization_vector =\n')
%         length = 50000;
%         for ii=1:length
% %     Idata=xc_i(i,ii);
% %     Qdata=xc_q(i,ii);
%  Idata=real(datasave(ii));
%  Qdata=imag(datasave(ii));
%  %   if(Idata<0)
%  %       Idata=2^32+Idata;
%  %   end
%  %   if(Qdata<0)
%  %       Qdata=2^32+Qdata;
%  %   end
%     fprintf(fid1_i,'%0.0f\n',Idata);
%     fprintf(fid1_q,'%0.0f\n',Qdata);
% end
% fclose(fid1_i);
% fclose(fid1_q);
% 
% 









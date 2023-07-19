   clc
   close all
   clear all

agilityNum = 6; %捷变数量

   fclk=187.5*10^6;%FPGA工作时钟频率
   ts = 1/fclk;
   f=[13e6,12e6,11e6,10e6,9e6,8e6]; %信号频率
  

   T=2e-6;   %码字宽度

   p0=0;% p0/2pi
   
   len  = floor(T*fclk);
   lensum = len*agilityNum;
   
   
   Ndds = 10;
   Ndds1  = 32;
   Nddsout= 15;%dds输出位数
   
   ChNum =4;%3;

   
   dataoutsum = zeros(ChNum,lensum);
   dataout=zeros(ChNum,len);
   init_phase=zeros(1,ChNum);
   init_phase1=zeros(1,ChNum);
   kf2= f(1)/fclk*(2^Ndds1-1);

   
   kf1 = zeros(1,agilityNum+1);
   for i=1:agilityNum
     kf1(i)=floor(f(i)/fclk*(2^Ndds1-1));
     kf(i)=mod(kf1(i),2^32);
   end
   
   for i = 1:ChNum
       init_phase(i) = init_phase(i)+ (i-1)*(kf1(1)/ChNum);
     init_phase(i)=floor( mod(init_phase(i),(2^32)));
   end
   
   init_phase00  = zeros(1,ChNum);
   init_pp = zeros(agilityNum,ChNum);
   for j=1:agilityNum
 for i=1:ChNum
   
   
    % init_phase(i) = init_phase(i)+ (i-1)*floor(kf2/ChNum);
   if(j == 1)
    [dataout(i,:),phasesum0(i,:)]=singletone_single(kf(j),init_phase(i),len,Ndds1,Ndds,Nddsout);
   end
   if(j ~= 1)
   [dataout(i,:),phasesum0(i,:)]=singletone_single(kf(j),init_phase00(i),len,Ndds1,Ndds,Nddsout);
   end
 
  %  if(j < agilityNum)
  %  init_phase00(i) = phasesum0(i,len) + kf(j+1);
  %  end
    phasesum(i,((j-1)*len+1):(j*len))= phasesum0(i,:);
    dataoutsum(i,((j-1)*len+1):(j*len))= dataout(i,:);
 end  
    for i0 = 1:ChNum
    init_phase00(i0) = phasesum0(4,len) + (i0)*(kf1(j+1)/ChNum);
    end
    init_pp(j,:) = init_phase00;
  end


figure(1)
subplot(111)
plot(real(dataoutsum(1,:))); axis([0 lensum -32768 32768]);



dataout1 = zeros(1,len*agilityNum*ChNum);
   for i=1:ChNum
     dataout1(i:ChNum:end) = dataoutsum(i,:);
   end
   figure(2)
   plot(real(dataout1))
     figure
  subplot(211)
 plot(real(dataout1));
title('频率编码实部');
set(gca,'XTick',0:9000/2:9000)
set(gca,'XTicklabel',{'0','6','12us'});
 subplot(212)
 plot(imag(dataout1));
 title('频率编码虚部');
set(gca,'XTick',0:9000/2:9000)
set(gca,'XTicklabel',{'0','6','12us'});

   fvtool(dataout1(1,:))
   
   
   dataout_sum = zeros(1,len*ChNum); 
   dataout_sum = zeros(1,len*ChNum);
   for i=1:ChNum
     dataout_sum(i:ChNum:end) = dataout(i,:);
   end
   figure(3)
   subplot(511)
     plot(real(dataout(1,:)))
    subplot(512)
     plot(real(dataout(2,:)))
     subplot(513)
     plot(real(dataout(3,:)))
     subplot(514)
     plot(real(dataout(4,:)))
     subplot(515)
     plot(real(dataout_sum))
     
     phase_sum = zeros(1,len*ChNum);
     for i2=1:ChNum
     phase_sum(i:ChNum:end) = phasesum0(i,:);
     end
  figure(5)
  plot(phase_sum)
  
  leng= length(dataout1);
  copy_num = 100;
  copy = zeros(1,copy_num*length(dataout1));
  for i8=1:copy_num
  copy(i8:1:(i8+length(dataout1)-1)) = dataout1;
  end
  
  fvtool(copy);
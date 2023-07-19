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
   plot(real(dataout1));
   subplot(211)
   plot(imag(dataout1),'r');
   hold on ,
   fvtool(dataout1)
   
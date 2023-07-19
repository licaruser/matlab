   clc
   close all
   clear all



   fclk=281.25*10^6;%FPGA工作时钟频率
   ts = 1/fclk;
   B=100*10^6;%带宽
   B1=-B;
 %  load 'p3_inv.mat';

  

   T=10e-6;
   N=floor(T*fclk);
   f0=0;
   u=B/T;
   u1=B1/T;
   p0=0;
   
   len  = floor(T*fclk)*2;
   
   
   Ndds = 10;
   Ndds1  = 32;
   Nddsout= 15;%dds输出位数
   
   ChNum =4;

   
   a_p=zeros(1,ChNum);
   b_p=zeros(1,ChNum);
   c_p=zeros(1,ChNum);
   dataout=zeros(2,len);
   a_n=zeros(1,ChNum);
   b_n=zeros(1,ChNum);
   c_n=zeros(1,ChNum);
   dataout=zeros(2,len); 
   
 for i=1:ChNum
   a_p(i) = round((1/2)*u*1/fclk^2*2^Ndds1);
   b_p(i) = round((f0-B/2+(i-1)*u/(ChNum*fclk))/fclk*2^Ndds1);
   c_p(i) = round((p0/(2*pi)+0.5*u*(i-1)^2/(ChNum*fclk)^2+(f0-B/2)*(i-1)/(ChNum*fclk))*2^Ndds1);
   
   a_n(i) = round((1/2)*u1*1/fclk^2*2^Ndds1);
   b_n(i) = round((f0-B1/2+(i-1)*u1/(ChNum*fclk))/fclk*2^Ndds1);
   c_n(i) = round((p0/(2*pi)+0.5*u1*(i-1)^2/(ChNum*fclk)^2+(f0-B1/2)*(i-1)/(ChNum*fclk))*2^Ndds1);

   a_p(i)=mod(a_p(i),2^32);
   b_p(i)=mod(b_p(i),2^32);
   c_p(i)=mod(c_p(i),2^32);
   
   
   a_n(i)=mod(a_n(i),2^32);
   b_n(i)=mod(b_n(i),2^32);
   c_n(i)=mod(c_n(i),2^32);
  
 

   dataout(i,:)=Triangular_wave_single(a_p(i),b_p(i),c_p(i),a_n(i),b_n(i),c_n(i),len,Ndds1,Ndds,Nddsout,N);
  
 
 
end  
  
   dataout1 = zeros(1,len*ChNum);
   for i=1:ChNum
     dataout1(i:ChNum:end) = dataout(i,:);

   end
   
   
 

  
%    fid=fopen('lfm15.coe','w');
%    fprintf(fid,'memory_initialization_radix=10;\n');
%    fprintf(fid,'memory_initialization_vector =\n');
%    fprintf(fid,'%d,\n',data_IF_P_2(8,:));
%    fclose(fid);
%   f_IF0 = -150*10^6 ;%中频0
%    Q_coef_IF = fclk;%输入值
%    Q_Cut = 4e4;
%    theta = 0;%波束指向的相位
%   
%    phase_IF0 = zeros(1,12);
%    phase_IF = floor((f_IF0/(2*fclk))*Q_coef_IF);
%    if(phase_IF<0)
%        phase_IF =phase_IF+Q_coef_IF;
%    end
%    phase_IF0(1) =floor(theta/(2*pi)*Q_coef_IF);
%    if(phase_IF0(1)<0)
%         phase_IF0(1) = phase_IF0(1) + Q_coef_IF;
%    end
%    phase_IF0(2) =phase_IF0(1)+phase_IF;
%    if( phase_IF0(2)>Q_coef_IF)
%         Q_coef_IF(2)=phase_IF0(2)-Q_coef_IF;
%    end
%        
%   
%   
%   
%    k0 = 2*phase_IF;%频率累计字，exp(-j*k0*n)
%   if(k0>=Q_coef_IF)
%      k0=k0-Q_coef_IF;
%   end
%    
% %    if(k0>=4*Q_coef_IF)
% %      k0=k0-4*Q_coef_IF;
% %    elseif(k0>=3*Q_coef_IF)
% %      k0=k0-3*Q_coef_IF;
% %     elseif(k0>=2*Q_coef_IF)
% %      k0=k0-2*Q_coef_IF;
% %    elseif(k0>=1*Q_coef_IF)
% %      k0=k0-1*Q_coef_IF;
% %    end
%    
%     [dataout_IF0,dds_out0_save0]=Modulate_IF(dataout0,len,k0,phase_IF0(1),Q_coef_IF,Q_Cut,Nddsout);
%     [dataout_IF1,dds_out0_save1]=Modulate_IF(dataout1,len,k0,phase_IF0(2),Q_coef_IF,Q_Cut,Nddsout);
%  
%    
%    data_IF = zeros(1,length(dataout_IF0)*2);
%    data_IF(1:2:end) = dataout_IF0;
%    data_IF(2:2:end) = dataout_IF1;
%    
%    fvtool(data_IF)
  
   
   
   
   
   
   
  
   















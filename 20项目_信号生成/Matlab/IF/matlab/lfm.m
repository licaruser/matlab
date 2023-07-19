   clc
   close all
   clear all

% load 'fir_10to40MHza.mat';
% load 'fir_40to80MHz.mat';
% load 'fir_80to400MHz.mat';
% load 'fir_400to2000MHz.mat';
% fir_10to40MHz_Q= floor(fir_10to40MHza*2^17);
% fir_40to80MHz_Q= round(fir_40to80MHz*2^16);
% fir_80to400MHz_Q = round(fir_80to400MHz*(2^19));
% fir_400to2000MHz_Q=round(fir_400to2000MHz*(2^18-250));
% fir_len=length(fir_10to40MHz_Q);
% fir_len1=length(fir_40to80MHz_Q);
% fir_len2=length(fir_80to400MHz_Q);
% fir_len3=length(fir_400to2000MHz_Q);
   t_pulse = 4e-6;
   fclk=250*10^6;%FPGA工作时钟频率
   pulse_width= round(t_pulse*fclk);
   ts = 1/fclk;
   B=2.5*10^6;%带宽
 %  load 'p3_inv.mat';

  


   N=pulse_width;
   f0=0;
   u=B/t_pulse;
   p0=B*t_pulse/8;
   
   len  = pulse_width;
   
   
   Ndds = 10;
   Ndds1  = 32;
   Nddsout= 15;%dds输出位数
   
   ChNum =4;

   
   a=zeros(1,ChNum);
   b=zeros(1,ChNum);
   c=zeros(1,ChNum);
   dataout=zeros(1,len);
   
 for i=1:ChNum
   a(i) = floor((1/2)*u*1/fclk^2*2^Ndds1);
   b(i) = floor((f0-B/2+(i-1)*u/(ChNum*fclk))/fclk*2^Ndds1);
   c(i) = floor((p0/(2*pi)+0.5*u*(i-1)^2/(ChNum*fclk)^2+(f0-B/2)*(i-1)/(ChNum*fclk))*2^Ndds1);

   a(i)=mod(a(i),2^32);
   b(i)=mod(b(i),2^32);
   c(i)=mod(c(i),2^32);
  
 

   dataout(i,:)=linear_FM_mod(a(i),b(i),c(i),len,Ndds1,Ndds,Nddsout,N);
  
 
 
end  
  
   dataout1 = zeros(1,len*ChNum);
   for i=1:ChNum
     dataout1(i:ChNum:end) = dataout(i,:);

   end

   baker=[32767,32767,32767,32767,32767,-32767,-32767,32767,32767,-32767,32767,-32767,32767];
   baker_interp=zeros(1,length(baker)*16);
   for i=1:16
       baker_interp(i:16:end)=baker;
   end
   dataout1= baker_interp;
    f_IF0 = 300*10^6 ;%中频0
    fs=1000*10^6;
   init_phase0=0;
   init_phase1=floor((f_IF0/fs)*2^32);
   init_phase2=floor((f_IF0/fs)*2^32)*2;
   init_phase3=floor((f_IF0/fs)*2^32)*3;
   kf_IF =floor((f_IF0/fs)*2^32)*4; 
   kf_IF = mod(kf_IF,2^32);
   
   Q_coef_IF =2^32; 
   Q_Cut = 2^19;
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
%    k0 = 2*phase_IF;%频率累计字，exp(-j*k0*n)
%   if(k0>=Q_coef_IF)
%      k0=k0-Q_coef_IF;
%   end
   
%    if(k0>=4*Q_coef_IF)
%      k0=k0-4*Q_coef_IF;
%    elseif(k0>=3*Q_coef_IF)
%      k0=k0-3*Q_coef_IF;
%     elseif(k0>=2*Q_coef_IF)
%      k0=k0-2*Q_coef_IF;
%    elseif(k0>=1*Q_coef_IF)
%      k0=k0-1*Q_coef_IF;
%    end
   len1=length(dataout1(1:4:end));
    [dataout_IF0,dds_out0_save0]=Modulate_IF(dataout1(1:4:end),len1,kf_IF,init_phase0,Q_coef_IF,Q_Cut,Nddsout);
    [dataout_IF1,dds_out0_save1]=Modulate_IF(dataout1(2:4:end),len1,kf_IF,init_phase1,Q_coef_IF,Q_Cut,Nddsout);
    [dataout_IF2,dds_out0_save2]=Modulate_IF(dataout1(3:4:end),len1,kf_IF,init_phase2,Q_coef_IF,Q_Cut,Nddsout);
    [dataout_IF3,dds_out0_save3]=Modulate_IF(dataout1(4:4:end),len1,kf_IF,init_phase3,Q_coef_IF,Q_Cut,Nddsout);
 
   
   data_IF = zeros(1,length(dataout_IF0)*4);
   data_IF(1:4:end) = dataout_IF0;
   data_IF(2:4:end) = dataout_IF1;
   data_IF(3:4:end) = dataout_IF2;
   data_IF(4:4:end) = dataout_IF3;
   
   data_IF_gain = floor(data_IF*(11585+11585*sqrt(-1))/2^15);
   f_doppler = 30*10^6 ;%中频0
   kf_doppler = floor(f_doppler/fs*2^32)*4;
   init_phase0_doppler=0;
   init_phase1_doppler=floor(f_doppler/fs*2^32);
   init_phase2_doppler=floor(f_doppler/fs*2^32)*2;
   init_phase3_doppler=floor(f_doppler/fs*2^32)*3;
   len2=length(data_IF_gain(1:4:end));
    [dataout_doppler0,dds_out0_save0]=Modulate_IF(data_IF_gain(1:4:end),len2,kf_doppler,init_phase0_doppler,Q_coef_IF,Q_Cut,Nddsout);
    [dataout_doppler1,dds_out0_save1]=Modulate_IF(data_IF_gain(2:4:end),len2,kf_doppler,init_phase1_doppler,Q_coef_IF,Q_Cut,Nddsout);
    [dataout_doppler2,dds_out0_save2]=Modulate_IF(data_IF_gain(3:4:end),len2,kf_doppler,init_phase2_doppler,Q_coef_IF,Q_Cut,Nddsout);
    [dataout_doppler3,dds_out0_save3]=Modulate_IF(data_IF_gain(4:4:end),len2,kf_doppler,init_phase3_doppler,Q_coef_IF,Q_Cut,Nddsout);
   dataout_doppler =zeros(1,length(dataout_doppler0)*4);
   dataout_doppler(1:4:end)=dataout_doppler0;
   dataout_doppler(2:4:end)=dataout_doppler1;
   dataout_doppler(3:4:end)=dataout_doppler2;
   dataout_doppler(4:4:end)=dataout_doppler3;
  % data_IF_doppler = exp(sqrt(-1)*2*pi*kf_doppler*(0:length(data_IF_gain)-1)).*data_IF_gain;
   fvtool(dataout_doppler)
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   

   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
 

  
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
  
   
   
   
   
   
   
  
   















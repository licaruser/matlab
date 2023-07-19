

%a:带宽控制字；b：频率控制字；c:相位控制字；N：线性调制时钟
%x(n) = A*rect(n)*exp(j*p(n)),p(n) =2*pi/2^Ndds*(an^2+bn+c) 
% a = (1/2)*(B/T)*1/fclk^2*2^Ndds
% b = (-B/2+fo)/fs*2^Ndds
function [dataout,phase] =sin_FM_Modulation_Q(mf,k,Ndds,Ndds1,p,len,Nddsout)
    phase_suma = 0;
    phase_sumb = 0;
    Ndds_local = 24;
 
    for i=1:len
        
        %-----里面的sin表-----------------
           phase_suma = phase_suma + k;
           if(phase_suma>=2^Ndds1)
              phase_suma = phase_suma - 2^Ndds1;
           elseif(phase_suma<=-2^Ndds1)
              phase_suma = phase_suma + 2^Ndds1; 
           end
           phase_sum1 = (phase_suma+p);
           if(phase_sum1>=2^Ndds1)
               phase_sum1 =  phase_sum1 - 2^Ndds1;
           elseif(phase_sum1<0)
                phase_sum1 =  phase_sum1 + 2^Ndds1;
               
           end
           phase_sum_save(i) =  phase_sum1;
           kk = 6;
           phase_sum1 = floor(phase_sum1/2^kk);
           phase_sum1H = floor(phase_sum1/2^((Ndds1-kk)/2));
           phase_sum1L = mod(phase_sum1,2^((Ndds1-kk)/2));
           phase_sum1H_save(i)=phase_sum1H; 
           phase_sum1L_save(i)=phase_sum1L;
%            mult_in0 = DDS1_sin((Ndds1-kk)/2,phase_sum1H,Ndds_local) ;
%            mult_in2 = DDS1_cos((Ndds1-kk)/2,phase_sum1H,Ndds_local) ;
          [mult_in0,mult_in2] = DDS1((Ndds1-kk)/2,phase_sum1H,Ndds_local);
           mult_in0_save(i) = mult_in0;
           mult_in2_save(i) = mult_in2;
%            mult_in1 =  DDS2_cos((Ndds1-kk)/2,phase_sum1L,Ndds_local);
%            mult_in1_save(i) = mult_in1;
           mult_in1 = 2^Ndds_local;
%            mult_in3 =  DDS2_sin((Ndds1-kk)/2,phase_sum1L,Ndds_local);
           mult_in3 = floor((2*pi*phase_sum1L/2^(Ndds1-kk))*(2^Ndds_local));
           mult_in3_save(i) = mult_in3;
           P1(i)=mult_in2*mult_in3;
           P1_a(i)= floor(P1(i)/2^(Ndds_local-1));
           P2(i) = floor(mult_in0*mult_in1/2^(Ndds_local-1));
           
%             mult_ina0 = floor(sin(2*pi*phase_sum1H*2^((Ndds1-kk)/2)/2^(Ndds1-kk))*2^17)/2^17;
%             mult_ina1 = floor(cos(2*pi*phase_sum1L/2^((Ndds1-kk)))*2^17)/2^17;
%             mult_ina2 = floor(cos(2*pi*phase_sum1H*2^((Ndds1-kk)/2)/2^((Ndds1-kk)))*2^17)/2^17;
%             mult_ina3 = floor(sin(2*pi*phase_sum1L/2^((Ndds1-kk)))*2^17)/2^17;
           phaseout(i) = floor(( P2(i)+ P1_a(i))/2);%剩余2^Ndds_local
%             phaseout(i) = floor((sin(2*pi*phase_sum1H*2^10/2^20)*cos(2*pi*phase_sum1L/2^20)+cos(2*pi*phase_sum1H*2^10/2^20)*sin(2*pi*phase_sum1L/2^20))*2^15);
           mult_save(i) = phaseout(i)*mf;
           %-----w\外层的sin+cos表-----------------
           phase_sumb = floor((floor(phaseout(i)/2)*mf)/2^(Ndds_local-1));
           phase_sum2 = floor(phase_sumb/2^(Ndds1/2-(Ndds+2)));
           phase_sum3 = mod(phase_sum2,2^(Ndds+2));
%            if(phase_sum2<0)%确保查表的相位在0-2pi之间
%                phase_sum2 = phase_sum2 + 2^(Ndds+2);
%            end
           phase_sum3_save(i) = phase_sum3;
           
           dataout(i) = DDS(Ndds,phase_sum3,Nddsout);
                     
           
    end
    phase = phaseout;
     
end
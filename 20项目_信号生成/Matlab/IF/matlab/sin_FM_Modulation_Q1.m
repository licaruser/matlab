

%a:带宽控制字；b：频率控制字；c:相位控制字；N：线性调制时钟
%x(n) = A*rect(n)*exp(j*p(n)),p(n) =2*pi/2^Ndds*(an^2+bn+c) 
% a = (1/2)*(B/T)*1/fclk^2*2^Ndds
% b = (-B/2+fo)/fs*2^Ndds
function [dataout,phase] =sin_FM_Modulation_Q1(mf,k,Ndds,Ndds1,p,len,Nddsout)
    phase_suma = 0;
    phase_sumb = 0;
    Ndds_local = 27;
 
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
           
%             phaseout(i) = floor((sin(2*pi*phase_sum1H*2^10/2^20)*cos(2*pi*phase_sum1L/2^20)+cos(2*pi*phase_sum1H*2^10/2^20)*sin(2*pi*phase_sum1L/2^20))*2^15);
           mult_save(i) = phaseout(i)*mf;
           %-----w\外层的sin+cos表-----------------
           phase_sumb = floor((phaseout(i)*mf)/2^Ndds_local);
           phase_sum2 = floor(phase_sumb/2^(Ndds1/2-(Ndds+2)));
           if(phase_sum2<0)%确保查表的相位在0-2pi之间
               phase_sum2 = phase_sum2 + 2^(Ndds+2);
           end
           phase_sum2_save(i) = phase_sum2;
           dataout(i) = DDS(Ndds,phase_sum2,Nddsout);
                     
           
    end
    phase = phaseout;
     
end
function [dataout]=Triangular_wave_single(a_p,b_p,c_p,a_n,b_n,c_n,len,Ndds1,Ndds,Nddsout,N)

 %     phase1 =(a*(1:len).^2+b*(1:len)+c)/2^Ndds;
   k2_p = 2*a_p;
   k1_p = a_p+b_p;
   k0_p = c_p;
   
   k2_n = 2*a_n;
   k1_n = a_n+b_n;
   k0_n = c_n;
   
   k2_p=mod(k2_p,2^32);
   k1_p=mod(k1_p,2^32);
   k0_p=mod(k0_p,2^32);
   
   k2_n=mod(k2_n,2^32);
   k1_n=mod(k1_n,2^32);
   k0_n=mod(k0_n,2^32);
   
   
  %     dataout = A*exp((sqrt(-1)*2*pi*phase));
   sum1_buf_p=0;
   sum2_buf_p=0;
   sum1_buf_n=0;
   sum2_buf_n=0;
   sum1_p = 0;
   sum1_n = 0;
   sum2_p = 0 ;
   sum2_n = 0 ;
   cnt =0;
   cnt1=0;
   cnt2=0;
   sum1_p_save=zeros(1,N);
   sum2_p_save=zeros(1,N);
   sum1_n_save=zeros(1,N);
   sum2_n_save=zeros(1,N);
   for i=1:len
       
     if(cnt <N)
         sum1_n = 0;
         sum2_n = 0;
         sum1_buf_n=0;
         sum2_buf_n=0;
        sum1_p_save(i) = sum1_p;
        sum2_p_save(i) = sum2_p;
        sum1_p = sum1_p + k2_p;
        if(sum1_p>=2^Ndds1)%大于2pi
           sum1_p = sum1_p - 2^Ndds1;
        elseif(sum1_p<=-2^Ndds1)%小于-2pi
           sum1_p = sum1_p + 2^Ndds1;
        end
        sum2_p = sum2_p + sum1_buf_p + k1_p;
        if(sum2_p>=2^Ndds1)%大于2pi
           sum2_p = sum2_p - 2^Ndds1;
        elseif(sum2_p<=-2^Ndds1)%小于2pi
           sum2_p = sum2_p + 2^Ndds1;

        end
        cnt1=cnt1+1;
      %  phase_save(i)=mod(sum2_buf_p + k0_p+sum2_buf_n,2^Ndds1);
       phase_save(i)=mod(sum2_buf_p + k0_p,2^Ndds1);
        sum1_buf_p = sum1_p;
        sum2_buf_p = sum2_p;
     else
          cnt2=cnt2+1;
         sum1_p = 0;
         sum2_p = 0;
         sum1_buf_p=0;
         sum2_buf_p=0;
         sum1_n_save(cnt2) = sum1_n;
         sum2_n_save(cnt2) = sum2_n;
         sum1_n = sum1_n + k2_n;
        if(sum1_n>=2^Ndds1)%大于2pi
           sum1_n = sum1_n - 2^Ndds1;
        elseif(sum1_n<=-2^Ndds1)%小于-2pi
           sum1_n = sum1_n + 2^Ndds1;
        end
        sum2_n = sum2_n + sum1_buf_n + k1_n;
        if(sum2_n>=2^Ndds1)%大于2pi
           sum2_n = sum2_n - 2^Ndds1;
        elseif(sum2_n<=-2^Ndds1)%小于2pi
           sum2_n = sum2_n + 2^Ndds1;

        end
      
%         phase_save(i)=mod(sum2_buf_p + k0_n+sum2_buf_n,2^Ndds1);
        phase_save(i)=mod(sum2_buf_n + k0_n,2^Ndds1);
        sum1_buf_n = sum1_n;
        sum2_buf_n = sum2_n;
     end
       
       phase(i) = floor(phase_save(i)/2^(Ndds1-Ndds-2));
       if(phase(i)>=2^(Ndds+2))%超过2pi
          phase(i) = phase(i) -  2^(Ndds+2);
       elseif(phase(i)<0)
           phase(i) = phase(i) +  2^(Ndds+2);        
       end
       cnt_save(i) = cnt;
       if(cnt<2*N-1)
          cnt = cnt +1;
       elseif(cnt==2*N-1)
           
            cnt = 0; 
       end
     
           
       dataout(i) = DDS(Ndds,phase(i),Nddsout);
   
   end
   i
   
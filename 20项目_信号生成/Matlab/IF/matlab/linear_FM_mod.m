function [dataout]=linear_FM_mod(a,b,c,len,Ndds1,Ndds,Nddsout,N)

 %     phase1 =(a*(1:len).^2+b*(1:len)+c)/2^Ndds;
   k2 = 2*a;
   k1 = a+b;
   k0 = c;
      
  %     dataout = A*exp((sqrt(-1)*2*pi*phase));
   sum1_buf=0;
   sum2_buf=0;
   sum1 = 0;
   sum2 = 0 ;
   cnt =0;
   for i=1:len
       
     
      sum1 = sum1 + k2;
      if(sum1>=2^Ndds1)%大于2pi
          sum1 = sum1 - 2^Ndds1;
      elseif(sum1<=-2^Ndds1)%小于-2pi
          sum1 = sum1 + 2^Ndds1;
      end
      sum2 = sum2 + sum1_buf + k1;
      if(sum2>=2^Ndds1)%大于2pi
          sum2 = sum2 - 2^Ndds1;
      elseif(sum2<=-2^Ndds1)%小于2pi
          sum2 = sum2 + 2^Ndds1;

      end
      
       phase_save(i)=mod(sum2_buf + k0,2^Ndds1);
%       phase_save(i)= sum2_buf + k0;
       
       phase(i) = floor(phase_save(i)/2^(Ndds1-Ndds-2));
       if(phase(i)>=2^(Ndds+2))%超过2pi
          phase(i) = phase(i) -  2^(Ndds+2);
       elseif(phase(i)<0)
           phase(i) = phase(i) +  2^(Ndds+2);        
       end
       cnt_save(i) = cnt;
       if(cnt<N-1)
          cnt = cnt +1;
       elseif(cnt==N-1)
           sum1=0;
           sum2=0;
           sum1_buf=0;
           sum2_buf=0;
            cnt = 0; 
       end
     
           
       dataout(i) = DDS(Ndds,phase(i),Nddsout);
       sum1_buf = sum1;
       sum2_buf = sum2;
   end
   i
   
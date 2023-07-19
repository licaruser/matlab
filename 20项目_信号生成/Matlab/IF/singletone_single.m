function [dataout,phasesum1]=singletone_single(kf,init_phase,len,Ndds1,Ndds,Nddsout)

   phasesum = 0;
   phasesum1 = zeros(1,len);

  
   for i=1:len
      % phasesum = kf+phasesum;
       if(phasesum<0)
       	  phasesum = phasesum + 2^Ndds1;
       elseif(phasesum>=2^Ndds1)%大于2pi
          phasesum = phasesum - 2^Ndds1;
       end
       phasesum1(i) = phasesum+init_phase;
       if(phasesum1(i)<0)
       	 phasesum1(i) = phasesum1(i) + 2^Ndds1;
       	 
       elseif(phasesum1(i)>=2^Ndds1)%大于2pi
          phasesum1(i) = phasesum1(i) - 2^Ndds1;
       end
       phase(i) = floor(phasesum1(i)/2^(Ndds1-Ndds-2));
       dataout(i) = DDS(Ndds,phase(i),Nddsout);
       phasesum = kf+phasesum;
   end
end
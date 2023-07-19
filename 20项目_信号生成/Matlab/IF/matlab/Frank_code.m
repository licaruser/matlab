function out = Frank_code(M,Tb)
phase =zeros(1,M^2);
pos =zeros(1,M^2);
 for i=1:M
   for j=1:M
      phase((i-1)*M+j)= 2*pi/M*(i-1)*(j-1);
      pos((i-1)*M+j)=(i-1)*(j-1)/M;
   end
 end
 
 phase1 =zeros(1,M^2*Tb);
 
 for i=1:M^2
    phase1((i-1)*Tb+1:i*Tb)=phase(i); 
 end
 

  out = exp(sqrt(-1)*(phase1));

end 
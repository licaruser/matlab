function out = P1(M,Tb)
phase =zeros(1,M^2);
pos = zeros(1,M^2);
 for j=1:M
   for i=1:M
      phase((j-1)*M+i)= -pi/M*(M-(2*j-1))*(M*(j-1)+(i-1));
      pos((j-1)*M+i) = (M-(2*j-1))*(M*(j-1)+(i-1));
   end
 end

 phase1 =zeros(1,M^2*Tb);
 
 for i=1:M^2
    phase1((i-1)*Tb+1:i*Tb)=phase(i); 
 end
 

  out = exp(sqrt(-1)*(phase1));
   plot(20*log10(abs(fftshift(fft(out,1024)))));

end 
function out = P2(M,Tb)
phase =zeros(1,M^2);
 for j=1:M
   for i=1:M
      phase((j-1)*M+i)= pi/(2*M)*(M-(2*j-1))*(M-(2*i-1));
   end
 end

 phase1 =zeros(1,M^2*Tb);
 phase2 =zeros(1,M^2*Tb);
 
 for i=1:M^2
    phase1((i-1)*Tb+1:i*Tb)=phase(i); 
 end
 for i=1:length(phase1)
    if(phase1(i)>2*pi)
         phase2(i) =phase1(i)-2*pi;
    elseif(phase1(i)<-2*pi)
          phase2(i) =phase1(i)+2*pi; 
    else
         phase2(i) =phase1(i); 
    end
        
 end

  out = exp(sqrt(-1)*(phase1));
   plot(20*log10(abs(fftshift(fft(out,1024)))));

end 
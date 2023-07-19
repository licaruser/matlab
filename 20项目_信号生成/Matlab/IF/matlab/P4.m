function out = P4(M,Tb)
phase =zeros(1,M);
 
   for i=1:M
      phase(i)= pi/M*(i-1)^2-pi*(i-1);
   end


 phase1 =zeros(1,M*Tb);
 phase2 =zeros(1,M*Tb);
 
 for i=1:length(phase)
    phase1((i-1)*Tb+1:i*Tb)=phase(i); 
 end
 for i=1:length(phase1)
    if(phase1(i)>2*pi)
         phase2(i) =mod(phase1(i),2*pi);
    elseif(phase1(i)<-2*pi)
          phase2(i) =mod(phase1(i),-2*pi); 
    else
         phase2(i) =phase1(i); 
    end
        
 end
f0 =0;
fs =10e6;
  out = exp(sqrt(-1)*(2*pi*f0/fs*(0:length(phase1)-1)+phase1));
  plot(20*log10(abs(fftshift(fft(out,1024)))));

end 
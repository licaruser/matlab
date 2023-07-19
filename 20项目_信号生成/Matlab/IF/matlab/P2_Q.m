function out = P2_Q(M,Tb)
Q=16;
kf0=floor((M-1)/(2*M)*2^Q);
kf1=floor(1/M*2^Q);
initial_phase = floor((M-1)^2/(4*M)*2^Q);

phase =zeros(1,M^2);
 for j=0:M-1
   for i=0:M-1
      phase(j*M+(i+1))= (initial_phase-kf0*i-kf0*j+kf1*i*j);
   end
 end

 phase1 =zeros(1,M^2*Tb);
 phase2 =zeros(1,M^2*Tb);
 
 for i=1:M^2
    phase1((i-1)*Tb+1:i*Tb)=phase(i); 
 end
 phase=mod(phase1,2^Q);
 for i=1:length(phase1)
    if(phase1(i)>2*pi)
         phase2(i) =phase1(i)-2*pi;
    elseif(phase1(i)<-2*pi)
          phase2(i) =phase1(i)+2*pi; 
    else
         phase2(i) =phase1(i); 
    end
        
 end
 
phasea= floor(phase/2^(Q-12));

  out = floor(exp(sqrt(-1)*2*pi*(phasea/2^12))*(2^15-1));
   plot(20*log10(abs(fftshift(fft(out,1024)))));

end 
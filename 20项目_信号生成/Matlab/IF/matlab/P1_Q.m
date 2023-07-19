function out = P1_Q(M,Tb)
phase =zeros(1,M^2);
pos = zeros(1,M^2);
Q=16;
two_M_n_Q = (1/(2*M))*2^Q;
 for j=1:M
   for i=1:M
      phase((j-1)*M+i)= -two_M_n_Q*(M-(2*j-1))*(M*(j-1)+(i-1));
 
   end
 end

 phase1 =zeros(1,M^2*Tb);
 
 for i=1:M^2
    phase1((i-1)*Tb+1:i*Tb)=phase(i); 
 end
 

  out = exp(sqrt(-1)*2*pi*(phase1)/2^Q);
%    plot(20*log10(abs(fftshift(fft(out,1024)))));
plot(phase./10000)
title('P1编码相位图')
xlabel('相变的 i 指数') 
ylabel('P1编码相移（rad）') 
end 
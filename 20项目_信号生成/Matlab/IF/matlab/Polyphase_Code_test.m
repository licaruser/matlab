 clc
 clear all
 
 
 M=8;
 Tb=8;
 
 
 out = Frank_code_Q(M,Tb);f=linspace(-1e9/2,1e9/2-1,1024);f1=linspace(-1e9/8,1e9/8-1,1024);
  figure
  subplot(131)
 plot(real(out));
title('Frank码实部');
set(gca,'XTick',0:512/2:512)
set(gca,'XTicklabel',{'0','0.256','0.512us'});
 subplot(132)
 plot(imag(out));
 title('Frank码虚部');
set(gca,'XTick',0:512/2:512)
set(gca,'XTicklabel',{'0','0.256','0.512us'});
 subplot(133)
 plot(f,20*log10(abs(fftshift(fft(out,1024)))));title('Frank码频谱');
 out1 = P1_Q(M,Tb);
   figure
  subplot(131)
 plot(real(out1));
title('P1码实部');
set(gca,'XTick',0:512/2:512)
set(gca,'XTicklabel',{'0','0.256','0.512us'});
 subplot(132)
 plot(imag(out1));
 title('P1码虚部');
set(gca,'XTick',0:512/2:512)
set(gca,'XTicklabel',{'0','0.256','0.512us'});
 subplot(133)
 plot(f,20*log10(abs(fftshift(fft(out1,1024)))));title('P1码频谱');
 
 
 out2 =   P2_Q(M,Tb);
    figure
  subplot(131)
 plot(real(out2));
title('P2码实部');
set(gca,'XTick',0:512/2:512)
set(gca,'XTicklabel',{'0','0.256','0.512us'});
 subplot(132)
 plot(imag(out2));
 title('P2码虚部');
set(gca,'XTick',0:512/2:512)
set(gca,'XTicklabel',{'0','0.256','0.512us'});
 subplot(133)
 plot(f,20*log10(abs(fftshift(fft(out2,1024)))));title('P2码频谱');
 
 
 
 out3 =   P3(M,Tb);
     figure
  subplot(131)
 plot(real(out3));
title('P3码实部');
set(gca,'XTick',0:64/2:64)
set(gca,'XTicklabel',{'0','0.256','0.512us'});
 subplot(132)
 plot(imag(out3));
 title('P3码虚部');
set(gca,'XTick',0:64/2:64)
set(gca,'XTicklabel',{'0','0.256','0.512us'});
 subplot(133)
 plot(f,20*log10(abs(fftshift(fft(out3,1024)))));title('P3码频谱');
 
 
 
 out4 = P4(M,Tb);
     figure
  subplot(131)
 plot(real(out4));
title('P4码实部');
set(gca,'XTick',0:64/2:64)
set(gca,'XTicklabel',{'0','0.256','0.512us'});
 subplot(132)
 plot(imag(out4));
 title('P4码虚部');
set(gca,'XTick',0:64/2:64)
set(gca,'XTicklabel',{'0','0.256','0.512us'});
 subplot(133)
 plot(f,20*log10(abs(fftshift(fft(out4,1024)))));title('P4码频谱');
% 
%  subplot(256)
%  plot(imag(out));
%  subplot(252)
%  plot(real(out1));
%  subplot(256)
%  plot(imag(out1));
%  subplot(253)
%  plot(real(out2));
%  subplot(257)
%  plot(imag(out2));
%   subplot(254)
%  plot(real(out3));
%  subplot(258)
%  plot(imag(out3));
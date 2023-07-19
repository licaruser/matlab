%function [aout]=pn_gen(mode_choice)
clear all
 pncode_choice =17;
% coef_num = 0;
  switch (pncode_choice)                                       
      case 0
          coef_num = 4;
          coef=[1,0,1,1];% 013
      case 1
          coef_num = 5;
          coef=[1,0,0,1,1];%023
      case 2
          coef_num = 6;
          coef=[1,0,0,1,0,1];%045
      case 3
          coef_num = 7;
          coef=[1,0,0,0,0,1,1];%0103
      case 4
          coef_num = 8;
          coef=[1,0,0,0,0,0,1,1];%0203
      case 5
          coef_num = 9;
          coef=[1,0,0,0,1,1,1,0,1];%0435
      case 6
          coef_num = 10;
          coef=[1,0,0,0,0,1,0,0,0,1];%01021
      case 7
          coef_num = 11;
          coef=[1,0,0,0,0,0,0,1,0,0,1];%02011
      case 8
          coef_num = 12;
          coef=[1,0,0,0,0,0,0,0,0,1,0,1];%04005
      case 9
          coef_num = 13;
          coef=[1,0,0,0,0,0,1,0,1,0,0,1,1];%010123
      case 10
          coef_num = 14;
          coef=[1,0,0,0,0,0,0,0,0,1,1,0,1,1];%020033
      case 11
          coef_num = 15;
          coef=[1,0,0,0,1,0,0,0,1,0,0,0,0,1,1];%042103
      case 12
          coef_num = 16;
          coef=[1,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1];%0100003
      case 13
          coef_num = 17;
          coef=[1,0,0,0,1,0,0,0,0,0,0,0,0,1,0,1,1];%0210013
      case 14
          coef_num = 18;
          coef=[1,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1];%0400011
      case 15
          coef_num = 19;
          coef=[1,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,1];%01000201
      case 16
          coef_num = 20;
          coef=[1,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,1,1];%02000047
      case 17
          coef_num = 21;
          coef=[1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1];%04000011
  end
  
  data_reg = zeros(1,coef_num-1); 
  data_reg(coef_num-1) = 1;
  
  for j=1:20000
     sum1=0;
      pn_out(j) = data_reg(coef_num-1);
     for i=1:coef_num-1
         sum1 =sum1 + coef(i+1)*data_reg(i);
        
     end
     for i=coef_num-2:-1:1
        data_reg(i+1)=data_reg(i);
     end
     data_reg(1) = mod(sum1,2);
     
    

  end
 
  u=pn_out;
  v=pn_out;
  N=length(pn_out);
for i=0:N
    u1=[u(i+1:N) u(1:i)];%表示u序列左移
    temp1(N+1-i)=sum(u1.*v);
    u2=[u(N-i+1:N) u(1:N-i)];%表示u序列右移
    temp2(i+1)=sum(u2.*v);
end
y=[temp1(2:N) temp2(1:N)];
    d=abs(y);
    d=20*log10(y+1e-6);
[a,b]=xcorr(u1);
plot(b,y);
  xlabel('\tau')
ylabel('自相关系数')
 title('m序列自相关函数');
  plot(pn_out); axis([1,20000,0,1.2]);title('21阶移位寄存器m序列');
  xlabel('序列顺序')
ylabel('幅度')
 %end
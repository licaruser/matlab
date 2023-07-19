function [xout]=random_gen(xin,m1)
  a=5^7;
  b=1;
  xout =mod(a*xin+b,m1) ;
 
end
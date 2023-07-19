%实信号与复信号

A=10;
t=0:0.1:10*pi;
t1=pi:0.1:10*pi;
figure(1)
X=A*cos(t);
Xj=A*exp(1j*t1);
plot(t,(X))
hold on
plot(t1,real(Xj))
hold on
plot(t1,imag(Xj))
xlabel('t');
ylabel('A');
title("实信号与复信号")
legend("实信号","复信号实部","复信号虚部");
clc
clear all
close all
% 二值伪随机信号（M序列）
n = 8; % 阶次
p = 2^n -1; % 循环周期
ms = idinput(p, 'prbs');
figure
stairs(ms);
title('M序列');
ylim([-1.5 1.5]);
sum(ms==1); % 1的个数
sum(ms==-1); % -1的个数
ans =127;

ans =128;

mean(ms); % 直流分量
ans =-0.0039;

a = zeros(length(ms)*10, 1); % 采样
for i = 1:10
a(i:10:end) = ms;
end
c = xcorr(a, 'coeff'); % 自相关函数
figure
plot(c);
title('相关函数');

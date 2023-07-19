clear
clc

code = [1 1 1 1 1 -1 -1 1 1 -1 1 -1 1];%13位巴克码
tao = 0.5e-6;  %chip时宽
fc = 20e6;  %载频(信号频率)
% fs = 200e6;  %采样率
fs = 20e6;  %采样率
t_tao = 0:1/fs:tao-1/fs;  %chip时宽内采样时间点序列
n = length(code);  %码长
% phase = 0;  %没必要在这定义相位
t = 0:1/fs:13*tao-1/fs;
s = zeros(1,length(t));
for ii = 1:n
    if code(ii) == 1
        phase = 0;  %应该是pi吧？对，经仿真验证原代码是错的，应该改为pi
%         phase = pi;  % 对于二相编码，只有 0，pi两种取值。
    else
        phase = pi;
    end
    s(1,(ii-1)*length(t_tao)+1:ii*length(t_tao)) = cos(2*pi*fc*t_tao+phase);
end
figure
plot(t,s,'b-o')
% plot(t,s)
xlabel('t(单位：秒)');
title('二相码（13位巴克码）');

%%  自相关函数  %%
[a,b] = xcorr(code);
% d = abs(a);
figure
plot(b,a,'r-o');title('Baker码序列自相关2')
axis tight

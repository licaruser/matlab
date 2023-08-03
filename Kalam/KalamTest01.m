close all;clear;clc;
% 估计小车在每一时刻的位置和速度
time = (1:100).'; % 离散的时间序列，单位是s
v = 5; % 小车的初始速度是5m/s，未知真实值
u = 0.1; % 加速度
noise = 3 * randn(length(time), 1); % GPS测量误差，标准差为3m
Z_ = zeros(length(time), 1); 
v_ = v + (time-1)*u; % 真实的速度值
for ii=2:length(time)
    Z_(ii) = Z_(ii-1) + v_(ii-1) + 1/2*u; % 真实的位置
end
% 已知量
Z = Z_ + noise; % GPS的观测值，带有测量误差
Q = [1e-4 0; 0 1e-4]; % 过程噪声的协方差矩阵，这是一个超参数
R = 1; % 观测噪声的协方差矩阵，也是一个超参数。因为是一维的，就是一个数
% 初始化
X = [0; 0]; % 初始状态，[位置, 速度]，就是我们要估计的内容
P = [0.1 0; 0 0.1]; % 先验误差协方差矩阵的初始值，根据经验给出

F = [1 1; 0 1]; % 状态转移矩阵
B = [1/2; 1]; % 控制矩阵
H = [1 0];

XLog = [];
for i=1:length(time)
    X_ = F*X + B*u;
    P_ = F*P*F'+Q;
    K = P_*H'/(H*P_*H'+R);
    X = X_+K*(Z(i)-H*X_);
    P = (eye(2)-K*H)*P_;
    XLog = [XLog, X];
end
figure(1)
plot(time, Z_);hold on;
plot(time, XLog(1, :), 'r.');
title('对位置的估计');
xlabel('时间');ylabel('位置');
figure(2)
plot(time, v_);hold on;
plot(time, XLog(2, :), 'r.');
title('对速度的估计');
xlabel('时间');ylabel('速度');
% 生成一个具有两个信号源的相控阵数据
fc = 2e9; % 载波频率
fs = 4e9; % 采样频率
c = physconst('LightSpeed'); % 光速
lambda = c / fc; % 波长
d = lambda / 2; % 元件间距离
source_angles = [30 60]; % 信号源到达角度
n_elements = 8; % 元件数量
n_samples = 500; % 采样点数

% 生成相控阵数据
t = (0:n_samples-1) / fs; % 时间向量
A = exp(1j * 2 * pi * fc * (sin(deg2rad(source_angles))' * t)); % 信号源到达角度
A = [A; zeros(n_elements-size(A,1), n_samples)]; % 补充零

% MUSIC算法估计DOA
doa = phased.MUSICEstimator('SensorArray', phased.ULA('ElementSpacing', d, 'NumElements', n_elements), 'OperatingFrequency', fc, 'NumSignals', 2);
angles = -90:90; % 估计角度范围
spectrum = zeros(size(angles));

for i = 1:length(angles)
    doa.AngularSpectrum = [angles(i); 0];
    spectrum(i) = step(doa, A);
end

% 展示DOA估计结果
figure;
plot(angles, abs(spectrum));
title('DOA估计');
xlabel('角度 (度)');
ylabel('谱值');
grid on;
clear;
clc;
close all;  

% 定义天线元素位置和幅度
antennaPositions = [0.0, 0.5, 1.0, 1.5];
antennaAmplitudes = [1.0, 0.8, 0.6, 0.4];

% 计算两个天线之间的相位差
calculatePhaseDifference = (2 * pi * d) / wavelength;

% 测量信号的入射角度
measureAngle =  angle(wavelength);

%anglea = 0;

wavelength = 0.5;  % 波长
anglea = measureAngle(wavelength);

disp(['入射角度: ', num2str(anglea), ' degrees']);


% 计算入射角度
function incidentAngle = angle(wavelength)
    maxSignal = 0.0;  % 最大信号强度
    maxIndex = 0;    % 最大信号强度对应的天线索引

    for i = 1:numel(antennaPositions)
        phaseDifference = calculatePhaseDifference(antennaPositions(i), wavelength);
        signalStrength = antennaAmplitudes(i) / sind(phaseDifference);
        
        if signalStrength > maxSignal
            maxSignal = signalStrength;
            maxIndex = i;
        end
    end

    % 计算入射角度
    incidentAngle = asind(maxIndex * wavelength / (antennaPositions(maxIndex)));
end
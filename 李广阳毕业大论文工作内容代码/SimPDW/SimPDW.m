clc; clear all; close all;
%总体产生5个脉冲信号
%实现信号的
%载频CarrierFre，到达时间TimeArr，脉冲幅度PulseAmp，脉冲重复周期PRI，脉冲到达角DireArr，脉宽PulseWith，
%用到的三个参数，到达角DireArr，载频CarrierFre，脉宽PulseWith
%

Signal1 = [3520 24 10]; %信号1【载频 脉宽 到达角】
Signal2 = [3030 23 70]; %信号2【载频 脉宽 到达角】
Signal3 = [3025 105 50];
Signal4 = [3040 111 10];
Signal5 = [2890 94 10];

Signal_Number = [300 323 312 284 281];%信号1-5的数量
%此处写一个函数传入参数，产生一个雷达脉冲信号
Signal_Num = Signal_Number(1);
Signal1 = SignalGenerate(Signal1,Signal_Num);
Signal_Num = Signal_Number(2);
Signal2 = SignalGenerate(Signal2,Signal_Num);
Signal_Num = Signal_Number(3);
Signal3 = SignalGenerate(Signal3,Signal_Num);
Signal_Num = Signal_Number(4);
Signal4 = SignalGenerate(Signal4,Signal_Num);
Signal_Num = Signal_Number(5);
Signal5 = SignalGenerate(Signal5,Signal_Num);

%  信号全部载频
CarFreALL =  [Signal1(:,1);Signal2(:,1);Signal3(:,1);Signal4(:,1);Signal5(:,1)];
%CarFreALL = sort(CarFreALL);

%  信号全部脉宽
PulWidALL = [Signal1(:,2);Signal2(:,2);Signal3(:,2);Signal4(:,2);Signal5(:,2);];
%PulWidALL = sort(PulWidALL);

%  信号全部到达角
DirArrALL = [Signal1(:,3);Signal2(:,3);Signal3(:,3);Signal4(:,3);Signal5(:,3);];
%DirArrALL = sort(DirArrALL);

plot3(CarFreALL,PulWidALL,DirArrALL,'.');
xlabel('载频/MHz');ylabel('脉宽/us');zlabel('到达角/度');
title('雷达信号脉冲描述字图');
grid on;

mydata = [CarFreALL,PulWidALL];

save('mydata','mydata');

aa = 1;



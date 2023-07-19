
%此程序是雷达仿真代码
%仿真参数(和实现完全对应)：13位barker码 Fs = 245.76e6  抽取Decimation = 20后 Fs = 12.288e6
%                         5重频 脉冲个数：N_CI=256 Tp = 4us; T0 = 4.2e-6; m = [7,8,9,11,13];
%性能：16通道，可实现测角，最大300km的测距，1500m/s的测速范围
%仿真步骤：目标信息 --> 系统参数设置 --> 基带信号 --> 回波模拟 --> 分为左右两通道 --> 抽取 --> 
%         生成脉压系数 --> 脉压 --> 和差 --> MTD --> CFAR --> 目标凝聚 --> 目标关联 --> 
%         解距离模糊 --> 查表测角 --> 打印检测结果
%使用比相测角法，AD采集得到信号一共为16路，将1-8路信号作为左通道，9-16路信号作为右通道信号，
%左通道mtd结果减去右通道MTD结果构造差通道结果
%左通道MTD结果加上右通道MTD结果构造和通道结果
%之后求出鉴角曲线值，根据和差通道的比值测角  
clc
close all
clear all

tic
%% 目标信息
R0 =  [   3, 150,  90, 250, 200, 289].*1e3;                                %距离
Vr =  [-100, 300, 200, 470, 380, 670];                                     %速度
fai_t=[-2,     2,  -3,   4,  -1,   1];                                     %角度
SNR = [-10,   -8, -12, -15, -13,  -9] - 0 ;                                %信噪比

%% 系统参数设置
protect0 = 4;                                                              %cfar参数
test0 = 4;
k0 = 32;

C = 3e8;
Fc = 1.8e9;                                                                %载频
Lamda = C/Fc;                                                              %波长
Fs = 245.76e6;                                                             %采样频率
decimation = 20;                                                           %抽取
N_CI = 256;                                                                %脉冲数

barker = [1 1 1 1 1 -1 -1 1 1 -1 1 -1 1];                                  %巴克码
k = length(barker);

Tp = 4e-6;                                                                 %脉冲宽度
T0 = 4.2e-6; 
m = [7,8,9,11,13];
PRT = T0.*m;                                                               %脉冲重复周期
B = 1/(Tp/k);                                                              %barker信号带宽
PRF = 1./PRT;                                                              %脉冲重复频率 

nTp = round(Tp/k*Fs)*k;                                                    %脉冲采样点数
nPRT = floor(PRT*Fs);                                                      %一个PRT对应的采样点数
MY_NFFT = 2^ceil(log2((max(nPRT)/decimation)));                            %距离维fft点数
juli_max = C*PRT/2;                                                        %最大不模糊测距范围 
start_juli = Tp*C/2;                                                       %盲距

%天线参数
Ny=16;                                                                     %天线阵元个数
d_lambda_1=0.5;                                                            %阵元间距与波长比值

%% 基带信号
Sbarker = repmat(barker,nTp/k,1);
Sbarker = reshape(Sbarker,1,[]);
Sbarker = Sbarker.*32766;                                                  %量化

figure;subplot(211);plot(Sbarker);
Sbarker_fft = fft(Sbarker);
x = -Fs/2 : Fs/nTp : Fs/2 - Fs/nTp;
subplot(212);plot( x*1e-6,abs(fftshift(Sbarker_fft)));
title('基带信号频率分布');xlabel('频率/MHz');
toc
%% 回波模拟 
Echo = Echo_sim(R0,Vr,N_CI,SNR,fai_t,Sbarker,nPRT,nTp,PRT,Fs,Fc,C,juli_max,Ny,d_lambda_1);   %回波模拟
toc
%% 分为左右两通道
Echo1 = sum(Echo(:,:,:,1:8),4);                                            %左边8个通道相加
Echo2 = sum(Echo(:,:,:,9:16),4);                                           %有边8个通道相加
clear Echo;

%% 抽取
s_barker1 = Decimation(Echo1,MY_NFFT,decimation);
s_barker2 = Decimation(Echo2,MY_NFFT,decimation);
clear Echo1 Echo2;
%% 生成脉压系数
coeff = coeff_produce(Sbarker,MY_NFFT,decimation,N_CI,nTp);
clear Sbarker;
%% 脉压
pc1 = PC(s_barker1,MY_NFFT,coeff);
pc2 = PC(s_barker2,MY_NFFT,coeff);
clear s_barker1 s_barker2;
%% 和差
pc_he = pc1 + pc2;
pc_cha = pc1 - pc2;
% clear pc1 pc2;
%%  动目标检测  mtd
mtd_he = MTD(pc_he);
mtd_cha = MTD(pc_cha);
% clear pc_he pc_cha;
%% CFAR
cfar = CFAR(mtd_he,protect0,test0,k0);

%% 目标凝聚
target = Target(cfar,protect0);
% clear cfar;
%% 打印出目标  并把点数换算为视在距离
target1 = zeros(size(target,1),4,size(target,3));                          %存放速度、距离、和、差
%target1三维数组，第一维存放不同的目标，第二维存放目标信息(分别为速度、距离、和、差)，第三维是不同的cpi
for ii = 1: size(target,3)
    for i = 1:size(target,1)
        if(target(i,1,ii) ~= 0)
            target1(i,1,ii) = (target(i,1,ii)-1-N_CI/2)*(PRF(ii)/N_CI)*Lamda/2;  %存放速度信息
            target1(i,3,ii) = mtd_he(target(i,1,ii),target(i,2,ii),ii);        %存放和
            target1(i,4,ii) = mtd_cha(target(i,1,ii),target(i,2,ii),ii);       %存放差
            if(target(i,2,ii) > 900)                                       %回波脉冲前面部分被遮挡，则脉压结果会在后面出现
                target(i,2,ii) = target(i,2,ii) - 1024;                    %因此需要人为的折算回来
            end
            target1(i,2,ii) = (target(i,2,ii)*(C/Fs/2)*decimation + start_juli);%存放距离信息
            
            fprintf('CPI%d  目标%d: 距离为：%11.2f 米;  速度为：%7.2f (m/s);\n',...
            ii,i,target1(i,2,ii),...
            target1(i,1,ii));
        else
            target1(i,:,ii) = [0 0 0 0];
        end
    end
    fprintf('\n');
end
% clear mtd_he mtd_cha;
%% 目标关联
target_association = Target_association(target1);

%% 解距离模糊
real_juli = jiemohu(target_association,PRT);

%% 测角查表
[curve_EL,theta_6] = phase_curve_XKZ;                         %得到鉴角曲线

%% 打印最终检测结果
for i = 1:size(real_juli,1)
    
    EL_bi=imag(real_juli(i,4)./real_juli(i,3));
    if((curve_EL(1)-EL_bi)<0)
        result_x_EL=1;
    elseif((curve_EL(length(curve_EL))-EL_bi)>0)
        result_x_EL=length(curve_EL);
    else
        for mm=1:length(curve_EL)-1
            if( (curve_EL(mm)-EL_bi)>0 && (curve_EL(mm+1)-EL_bi)<0 )
               if(curve_EL(mm)+curve_EL(mm+1)-2*EL_bi)>0
                   result_x_EL=mm+1;
               else
                   result_x_EL=mm; 
               end
               break;
            end
        end
    end
    real_juli(i,5)=theta_6(result_x_EL);
    
     fprintf('目标%d: 距离为：%11.2f 米;  速度为：%7.2f (m/s);  角度：%3.2f\n',...
            i,real_juli(i,2),real_juli(i,1),real_juli(i,5));
end
toc

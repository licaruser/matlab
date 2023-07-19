
%此函数主要生成和差波束（比相测角）的鉴角曲线
function [curve_EL,theta_6]=phase_curve_XKZ

theta=-30:0.1:30;
d_lambda_1=0.5;
d_lambda_2=d_lambda_1;
%% 阵列指向                                                                 %俯仰角
fai0=0;                                                                    %方位角
%% 左上
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 子阵排布                                                        
aa0_2_zuoshang=exp(1i*2*pi*d_lambda_2*[0:1:7]'*sin(fai0*pi/180));    %y空域导向矢量
for m=1:length(theta)
         aa=exp(1i*2*pi*d_lambda_2*[0:1:7]'*sin(theta(m)*pi/180));
         pattern_he_zuoshang(m)=aa0_2_zuoshang'*aa;%aa0为DBF的选择
 end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%plot 接收左上
%% 右
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 子阵排布                                                        
aa0_2_youshang=exp(1i*2*pi*d_lambda_2*[8:1:15]'*sin(fai0*pi/180));    %y空域导向矢量

for m=1:length(theta)
         aa=exp(1i*2*pi*d_lambda_2*[8:1:15]'*sin(theta(m)*pi/180));
         pattern_he_youshang(m)=aa0_2_youshang'*aa;%aa0为DBF的选择 
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%plot 作图右上
%% 合成和方向图
pattern_sum=pattern_he_zuoshang+pattern_he_youshang;
% figure;plot(theta,20*log10(abs(pattern_sum)./max(max(abs(pattern_sum)))));zlim([-60 0]);
% xlabel('方位角');title('接收和归一化方向图');set(gca,'clim',[-80 10]);
%% 合成方位差方向图
pattern_EL_dif=pattern_he_zuoshang-pattern_he_youshang;
% figure;plot(theta,20*log10(abs(pattern_EL_dif)./max(max(abs(pattern_EL_dif)))));
% xlabel('方位角');zlim([-60 0]);title('接收方位差归一化方向图');set(gca,'clim',[-80 10]);

%% 产生方位鉴角曲线
curve_EL_dif=pattern_EL_dif;
curve_sum=pattern_sum;
identifi_EL=imag(curve_EL_dif./curve_sum);

theta_6n=find(theta==-6);
theta_6p=find(theta==6);
theta_6=theta(theta_6n:theta_6p);
curve_EL=identifi_EL(theta_6n:theta_6p);

figure;plot(theta_6,curve_EL);
title('方位鉴角曲线');xlabel('角度');ylabel('差和比值');
end
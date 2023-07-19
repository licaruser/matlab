% improved algorithm for estimating PRIs applies to interleaved pulse
% trains  with PRI jitter.    改进的PRI估计算法适用于PRI抖动的交织脉冲串
close all
clear all
clf   %清除图像窗口
clc
N=1000;
%三部雷达的toa，脉冲到达时间
t1=0:333;%0 1 2 3 4 5 6 7 8 9...333
t2=0.1:sqrt(2):(0.1+332*sqrt(2));%0.1、1.514、2.928、4.342...
t3=0.2:sqrt(5):(0.2+332*sqrt(5));%0.2、2.436、4.672、6.908...
toa=[t1 t2 t3];  %混在一起的toa到达时间
clear t1 t2 t3
a=0.0;                                      %设置抖动程度
jitter=(1-2*rand(1,1000))*a;%-0.1~0.1     %rand(1,1000)产生一个一行千列的0-1的随机数组 10%的抖动 
toa=toa+jitter;                         %为每个脉冲的TOA加随机抖动
toa=sort(toa);                          %排序
K=201;
taumin=0;
taumax=10;
epsilon=a;                                  %epsilon为PRI抖动上限(=a)
zetazero=0.03;
O=zeros(1,K); %产生一个一行201列的数组
D=zeros(1,K);                               %初始化D(k)
C=zeros(1,K);
A=zeros(1,K);                               %初始化门限函数
for i=1:K                                   %PRI箱中心，验证标志
    tauk(i)=(i-1/2)*(taumax-taumin)/K+taumin;
    flag(i)=1;
end
bk=2*epsilon*tauk; %0.2*tauk                %第k个PRI bin的width
n=2;
tic;
while n<=N   %N = 1000，是全部的TOA的到达时间
    m=n-1;
    while m>=1
        tau=toa(n)-toa(m);      %"&"和“&&”都是与的意思，前者是判断左右两个，&&效率高，先判断前面
        if (tau>(1-epsilon)*taumin)&(tau<=(1+epsilon)*taumax)                 %求tau值满足的PRI箱的范围
            k1=fix((tau/(1+epsilon)-taumin)*K/(taumax-taumin)+1);
            k2=fix((tau/(1-epsilon)-taumin)*K/(taumax-taumin)+1);             %此步骤计算tua加上向前抖动和向后抖动之后会处于哪个PRI盒子
            if k2 > 201 %tua已经超过了预设值
                break
            end
            for k=k1:k2
                if flag(k)==1                                                  %检测第k个PRI箱是否第一次使用
                    O(k)=toa(n);
                end
                etazero=(toa(n)-O(k))/tauk(k);                                 %计算初始相位并分解 
                nu=etazero+0.4999999;%可以认为0.5-1.5范围内的倍数都是该pri，1.5以上是pri的2倍
                zeta=etazero/nu-1;%abs(zeta)之后的比值看其是否接近PRI
                nu=fix(nu);%算相位因子分子的起始时间，太远就会大于1或者是大于等于2
                if ((nu==1)&(toa(m)==O(k)))|((nu>=2)&(abs(zeta)<=zetazero))    %确定是否需要移动时间起点，当相位因子分子差值较小等于1时，看O(k)中的值是否等于toa(m),若是，说明此toa(n)-O(k)=pri的值，相位是1，更新相位即可O(k)=toa(n)
                    O(k)=toa(n);         %当相位因子分子差值较大，大于等于2时，说明toa(n)-O(k)至少大于pri的1.5倍数，判断abs（zeta）是否接近pri的值
                end
                toa(n)
                
                tauk(k)
                eta=(toa(n)-O(k))/tauk(k)                       %计算相位，(toa(n)-O(k))为更新后的Tn，tauk(k)为Tn-Tm。47
                %disp("Toa时间：",toa(n),"相位起始时间：",O(k),"小盒中心值：",tauk(k),"计算的相位值：",eta);
                D(k)=D(k)+exp(2*pi*j*eta);                      %升级PRI变换
                C(k)=C(k)+1;%没有加相位抑制的pri统计值
                flag(k)=0;                                      %对已使用过的PRI箱设标志    
            end
        elseif tau>taumax*(1+epsilon)
            break
        end
        m=m-1;
    end
    n=n+1;
end
toc
disp(['运行时间：',num2str(toc)]);
D=abs(D);%对复数进行处理求模值
plot(tauk,D)%横坐标就是PRI  纵坐标是对应的个数
axis([0 10 0 800])
hold on         
X=[225./tauk;0.15*C;4*sqrt(N*N*bk/750)]; 
A=max(X);                                                      %门限函数
plot(tauk,A,'r-')
xlabel('tauk')
ylabel('|D(k)|')
i=1;
for k=1:K
    if D(k)>A(k)
        p(i)=tauk(k);
        i=i+1;
    end
end
p=sort(p);                                                     %峰值处理，消除相邻区间，得到可能PRI 



         
                
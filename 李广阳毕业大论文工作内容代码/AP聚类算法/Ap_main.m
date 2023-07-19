clear all;close all;clc;            %清除所有变量，关闭所有窗口，  清除命令窗口的内容
x=[1,0;                                   %定义一个矩阵
    1,1;
    0,1;
    4,1;
    4,0;
    5,1];
N=size(x,1);             %N为矩阵的列数，即聚类数据点的个数
M=N*N-N;                  %N个点间有M条来回连线，考虑到从i到k和从k到i的距离可能是不一样的
s=zeros(M,3);             %定义一个M行3列的零矩阵,用于存放根据数据点计算出的相似度

j=1;                              %通过for循环给s赋值，第一列表示起点i，第二列为终点k，第三列为i到k的负欧式距离作为相似度。
for i=1:N
    for k=[1:i-1,i+1:N]
        s(j,1)=i;
        s(j,2)=k;
        s(j,3)=-sum((x(i,:)-x(k,:)).^2);
        j=j+1;
    end;
end;
p=median(s(:,3));           %p为矩阵s第三列的中间值，即所有相似度值的中位数，用中位数作为preference,将获得数量合适的簇的个数
tmp=max(max(s(:,1)),max(s(:,2)));            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
S=-Inf*ones(N,N);                           %-Inf负无穷大，定义S为N*N的相似度矩阵，初始化每个值为负无穷大
for j=1:size(s,1)                                     %用for循环将s转换为S，S（i，j）表示点i到点j的相似度值
    S(s(j,1),s(j,2))=s(j,3);end;
nonoise=1;                                             %此处仅选择分析无噪情况（即S（i，j）=S（j,i）），所以略去下面几行代码
%if ~nonoise                                          %此处几行注释掉的代码是 在details,sparse等情况下时为了避免使用了无噪数据而使用的，用来给数据添加noise
%rns=randn('state');
%randn('state',0);
%S=S+(eps*S+realmin*100).*rand(N,N);
%randn('state',rns);
%end;
%Place preferences on the diagonal of S
if length(p)==1                                                  %设置preference
    for i=1:N
        S(i,i)=p;
    end;
else
    for i=1:N
        S(i,i)=p(i);
    end;
end;
% Allocate space for messages ,etc
dS=diag(S);                                                 %%%%%%%%%%%%%%%%列向量，存放S中对角线元素信息
A=zeros(N,N);
R=zeros(N,N);
%Execute parallel affinity propagation updates
convits=50;maxits=500;                               %设置迭代最大次数为500次，迭代不变次数为50
e=zeros(N,convits);
dn=0;
i=0;                       %e循环地记录50次迭代信息，dn=1作为一个循环结束信号，i用来记录循环次数
while ~dn
    i=i+1;
    %Compute responsibilities
    Rold=R;                 %用Rold记下更新前的R
    AS=A+S                  %A(i,j)+S(i,j)
    [Y,I]=max(AS,[],2);      %获得AS中每行的最大值存放到列向量Y中，每个最大值在AS中的列数存放到列向量I中
    for k=1:N
        AS(k,I(k))=-realmax;%将AS中每行的最大值置为负的最大浮点数，以便于下面寻找每行的第二大值
    end;
    [Y2,I2]=max(AS,[],2);   %存放原AS中每行的第二大值的信息
    R=S-repmat(Y,[1,N]);    %更新R,R(i,k)=S(i,k)-max{A(i,k')+S(i,k')}      k'~=k  即计算出各点作为i点的簇中心的适合程度
end 


% 
%  for k=1:N                         %eg:第一行中AS(1,2)最大,AS(1,3)第二大，
%         R(k,I(k))=S(k,I(k))-Y2(k); %so R(1,1)=S(1,1)-AS(1,2); R(1,2)=S(1,2)-AS(1,3); R(1,3)=S(1,3)-AS(1,2).............
%     end;                           %这样更新R后，R的值便表示k多么适合作为i 的簇中心，若k是最适合i的点，则R(i,k)的值为正
%     lam=0.5;
%     R=(1-lam)*R+lam*Rold;          %设置阻尼系数，防止某些情况下出现的数据振荡
%     %Compute availabilities
%     Aold=A;
%     Rp=max(R,0)                    %除R(k,k)外，将R中的负数变为0，忽略不适和的点的不适合程度信息
%     for k=1:N
%         Rp(k,k)=R(k,k);
%     end;
%     A=repmat(sum(Rp,1),[N,1])-Rp   %更新A(i,k),先将每列大于零的都加起来，因为i~=k,所以要减去多加的Rp(i,k)



    
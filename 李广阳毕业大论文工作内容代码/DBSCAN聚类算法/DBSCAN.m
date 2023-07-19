%
% Copyright (c) 2015, Yarpiz (www.yarpiz.com)
% All rights reserved. Please read the "license.txt" for license terms.
%
% Project Code: YPML110
% Project Title: Implementation of DBSCAN Clustering in MATLAB
% Publisher: Yarpiz (www.yarpiz.com)
% 
% Developer: S. Mostapha Kalami Heris (Member of Yarpiz Team)
% 
% Contact Info: sm.kalami@gmail.com, info@yarpiz.com
%
%//上面的部分应该是运行前的加载文件，不做过多解读
function [IDX, isnoise]=DBSCAN(X,epsilon,MinPts)    %//DBSCAN聚类函数
 
    C=0;                       %//统计簇类个数，初始化为0
    
    n=size(X,1);               %//把矩阵X的行数数赋值给n，即一共有n个点
    IDX=zeros(n,1);            %//定义一个n行1列的矩阵
    
    D=pdist2(X,X);             %//计算(X,X)的行的距离
    
    visited=false(n,1);        %//创建一维的标记数组，全部初始化为false，代表还未被访问
    isnoise=false(n,1);        %//创建一维的异常点数组，全部初始化为false，代表该点不是异常点
    
    for i=1:n                  %//遍历1~n个所有的点
        if ~visited(i)         %//未被访问，则执行下列代码
            visited(i)=true;   %//标记为true，已经访问
            
            Neighbors=RegionQuery(i);     %//查询周围点中距离小于等于epsilon的个数
            if numel(Neighbors)<MinPts    %//如果小于MinPts，numel返回元素Neighbors中的元素个数
                % X(i,:) is NOISE        
                isnoise(i)=true;          %//该点是异常点
            else              %//如果大于MinPts,且距离大于epsilon
                C=C+1;        %//该点又是新的簇类中心点,簇类个数+1
                ExpandCluster(i,Neighbors,C);    %//如果是新的簇类中心，执行下面的函数
            end
            
        end
    
    end                    %//循环完n个点，跳出循环
    
    function ExpandCluster(i,Neighbors,C)    %//判断该点周围的点是否直接密度可达
        IDX(i)=C;                            %//将第i个C簇类记录到IDX(i)中
        
        k = 1;                             
        while true                           %//一直循环
            j = Neighbors(k);                %//找到距离小于epsilon的第一个直接密度可达点
            
            if ~visited(j)                   %//如果没有被访问
                visited(j)=true;             %//标记为已访问
                Neighbors2=RegionQuery(j);   %//查询周围点中距离小于epsilon的个数
                if numel(Neighbors2)>=MinPts %//如果周围点的个数大于等于Minpts，代表该点直接密度可达
                    Neighbors=[Neighbors Neighbors2];   %#ok  //将该点包含着同一个簇类当中
                end
            end                              %//退出循环
            if IDX(j)==0                     %//如果还没形成任何簇类
                IDX(j)=C;                    %//将第j个簇类记录到IDX(j)中
            end                              %//退出循坏
            
            k = k + 1;                       %//k+1,继续遍历下一个直接密度可达的点
            if k > numel(Neighbors)          %//如果已经遍历完所有直接密度可达的点，则退出循环
                break;
            end
        end
    end                                      %//退出循环
    
    function Neighbors=RegionQuery(i)        %//该函数用来查询周围点中距离小于等于epsilon的个数
        Neighbors=find(D(i,:)<=epsilon);
    end
 
end
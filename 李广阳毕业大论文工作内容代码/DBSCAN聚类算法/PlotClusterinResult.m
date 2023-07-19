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
%//上面的程序依旧应该是加载文件，不做过多的解析
function PlotClusterinResult(X, IDX)                %//绘图，标绘聚类结果
    k=max(IDX);                                     %//求矩阵IDX每一列的最大元素及其对应的索引
 
    Colors=hsv(k);                                  %//颜色设置
 
    Legends = {};
    for i=0:k                                       %//循环每一个簇类
        Xi=X(IDX==i,:);                    
        if i~=0                                     
            Style = 'x';                            %//标记符号为x
            MarkerSize = 8;                         %//标记尺寸为8
            Color = Colors(i,:);                    %//所有点改变颜色改变
            Legends{end+1} = ['Cluster #' num2str(i)]; 
        else
            Style = 'o';                            %//标记符号为o
            MarkerSize = 6;                         %//标记尺寸为6
            Color = [0 0 0];                        %//所有点改变颜色改变
            if ~isempty(Xi)
                Legends{end+1} = 'Noise';           %//如果为空，则为异常点
            end
        end
        if ~isempty(Xi)
            plot(Xi(:,1),Xi(:,2),Style,'MarkerSize',MarkerSize,'Color',Color);
        end
        hold on;
    end
    hold off;                                    %//使当前轴及图形不在具备被刷新的性质
    axis equal;                                  %//坐标轴的长度单位设成相等
    grid on;                                     %//在画图的时候添加网格线
    legend(Legends);
    legend('Location', 'NorthEastOutside');      %//legend默认的位置在NorthEast，将其设置在外侧
 
end                                              %//结束循环
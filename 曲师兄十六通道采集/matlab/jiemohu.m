
function y_guji = jiemohu(target_association,PRT)

%% 查看不同PRF距离遮挡情况,参考论文《HPRF PD 末制导雷达解距离模糊方法设计》
%% 解模糊

    C=3e8;
    y_guji = [];
    for h = 1:size(target_association,3)                                   %对不同的速度进行轮循
    r_shizai = target_association(:,2,h);                                  %取同一速度的距离信息

    Ru = C*PRT/2;                                                          %计算每个PRT的最大视在距离
    Rmax = 300000;
    pos = find((r_shizai) ~= 0);      %获取未被遮挡的cpi信息，目标被遮挡后对应的cpi的目标信息为0
     %% 建立余差表
     if(isempty(pos))   %全被遮挡
         continue;
     end
      K3 = ceil(Rmax/Ru(pos(1)));    %以第一没有被遮挡的cpi的视在距离为基准，计算共有多少中情况
      yuchatable2 = zeros(K3,length(pos));  %生成查找表
     for p = 1 : K3                %对每种情况都进行遍历
         for pp = 1:length(pos)    %对没有被遮挡的目标个数进行遍历
             if pp ~= 1
                %以第一个没有被遮挡的cpi为基准，列出所有实际距离存在的可能，然后求出其余cpi对应的视在距离
                yuchatable2(p,pp-1) = mod((p-1)*Ru(pos(1))+r_shizai(pos(1)),Ru(pos(pp)));   
             end
         end
%         yuchatable2(p,length(pos)) = fix((p*Ru(pos(1))+r_shizai(pos(1)))/Ru(pos(1)));
     end

     %% 查表
      a2=[];     
     for p=1:K3
         e = 0;
         for pp = 1:length(pos)
             if pp~=1
                e = e+abs(r_shizai(pos(pp))-yuchatable2(p,pp-1));
             end
         end
         a2=[a2,e];
     end

    [~,mohudu]=min(a2);
    [~,a] = max(abs(target_association(:,3,h)));                           %寻找信噪比最大的点进行测角
    %目标速度是对不同cpi内的所有目标求平均速度：mean(target_association(pos,1,h))
    y_guji = [y_guji;mean(target_association(pos,1,h)),(mohudu-1)*Ru(pos(1))+r_shizai(pos(1)),target_association(a,3:4,h)];
    end

end
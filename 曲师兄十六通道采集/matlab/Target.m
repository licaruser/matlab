function target = Target(cfar,protect0)
%此函数的阈值参数都是自己试出来的，不知道怎么计算，可根据实际情况做修改
%target是一个三维矩阵，第一维存放不同的目标，第二维存放目标信息(分别为速度、距离、模值)，第三维是不同的cpi
    for j = 1:size(cfar,3)                                                 %CPI循环
        
        % 寻找目标，先设一个固定的门限，把你毛刺给干掉
        target_cnt = 0;
        target1 = [];
        for ii = 1:size(cfar,2)
            for i = 1: size(cfar,1)
                if(cfar(i,ii,j) > 50000  )
                    target_cnt = target_cnt + 1;
                    target1(target_cnt,1) = i;
                    target1(target_cnt,2) = ii;
                    target1(target_cnt,3) = cfar(i,ii,j);
                end
            end
        end
        if(isempty(target1))   %若没找到目标，则跳出此循环，进行下一个cpi检测
            continue;
        end
        %删除多余目标，小于最大值的的8分之1给干掉
        target2 = [];
        target_max = max(target1(:,3));
        for i = 1 : size(target1,1)
            if(target1(i,3) > target_max/8)
                target2 = [target2;target1(i,:)];
            end
        end
        
        %目标凝聚，
        target3 = [];
        for i = 1: size(target2,1)
            for ii = 1:size(target2,1)
                if( i~=ii &&  (abs(target2(i,1)-target2(ii,1))<protect0*4  &&   abs(target2(i,2)-target2(ii,2))<protect0*2 && target2(i,3) < target2(ii,3))  )
                    break;
                end
            end
            
            if(ii == size(target2,1))
                target3 = [target3;target2(i,:)];
                for k = 1:(size(target3,1)-1)
                    if( (abs(target2(i,1)-target3(k,1))<protect0*4  &&   abs(target2(i,2)-target3(k,2))<protect0*2 && target2(i,3) == target3(k,3))  )
                        target3(size(target3,1),:) = [];
                        break;
                    end
                end
            end
        end
       target(1:size(target3,1),1:size(target3,2),j) = target3;
    end

end
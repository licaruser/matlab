function target_association = Target_association(target)
%目标关联：自己写的，按速度进行关联，若有两个目标速度接近，则此方法有问题
%target_association为一个三维数组。第一维存放不同cpi但速度相同的目标
%第二维存放目标的信息(分别为速度、距离、和、差)，第三维存放不同速度的目标
    d = 0;
    while(~isempty(find(target(:,1,:),1)))                                 %判断是否还有未关联的目标
        [k,kk] = find(target(:,1,:),1);                                    %寻找第一个未关联目标的坐标
        [h,hh] = find(abs(target(k,1,kk)-target(:,1,:))<20);               %寻找和第一个未关联目标速度小于20的所有目标的坐标

        d = d+1;
        for p = 1:size(h,1)                                                %对找到的所有目标做轮循
            target_association(hh(p),:,d) = target(h(p),:,hh(p));          %将目标分类保存起来
            target(h(p),:,hh(p)) = [0 0 0 0];                              %把已经找到的目标清空
        end
    end

end
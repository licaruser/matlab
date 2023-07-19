function cfar = CFAR(mtd,protect,test,k0)  %protect为保护单元，test为参考单元，k0为系数
    
    cfar = zeros(size(mtd));
    mtd = abs(mtd);                                                        %求模
    y_x = mtd.*mtd;                                                        %为了和硬件是实现对应起来，求模没开方

    bit_length = size(dec2bin(max(max(max(y_x)))),2);
    if( bit_length > 32 )
        y_x = round(y_x./(2^(bit_length-32)));
    end
        
    for i = 1:size(mtd,3)                                                  %CPI循环
        for ii=1:size(y_x,1)                                               %脉冲个数循环
            cfar(ii,:,i) = CFAR2(y_x(ii,:,i),protect,test,k0);             %距离维做检测(实现时为了方便，是速度维做的)
        end
        figure;mesh(reshape(cfar(:,:,i),size(cfar,1),size(cfar,2)));
        title(['CFAR',num2str(i)]);
    end

end
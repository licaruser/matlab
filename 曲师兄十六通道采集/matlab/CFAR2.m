function x = CFAR2(y,protect,test,k0)%y为数据向量，protect为保护单元，test为参考单元，k0为系数

y = reshape(y,size(y,1),size(y,2));
L=size(y);
x=zeros(L(1),L(2));
ava = sum(sum(y))/L(1)/L(2);
a_L=protect+test;
y2=ones(L(1),L(2)+a_L*2)*ava;
y2( L(1),(a_L+1) : (L(2)+a_L) ) = y;
for i=1:L(1)
    for i2=1:L(2)
        L1 = y2(i,i2:i2+test-1);
        L2 = y2(i,i2+protect*2+test+1:i2+protect*2+test*2);
        L3 = ava * test;
        sum1=sum(L1);
        sum2=sum(L2);
        sum3=sum(L3);
        ava_t=max([sum1,sum2,sum3])/test;
        if(y(i,i2)>=(ava_t*k0))%过门限则记录，不过的归零
            x(i,i2)=y(i,i2);
        end
    end
end
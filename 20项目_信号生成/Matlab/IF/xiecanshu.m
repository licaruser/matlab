
fid=fopen('AXI.text','w'); %创建y.coe文件
DATA_NUM=[8 8 8 8 64 8 8 8 8 8 8 8 8 8 32 8 8 8 8 8 8 32 8 32 8 32 32 32 8 8 8 32];
%canshushumu=200;%参数数目
a=7;
NUM =length(DATA_NUM);
for j= 1:NUM-1
 lieshu= DATA_NUM(j)/4;
    for i=1:lieshu
   % fprintf(fid,'assign %s ={',);
    fprintf(fid,'slv_reg[B_CH_BASE+%d],slv_reg[B_CH_BASE+%d],slv_reg[B_CH_BASE+%d],slv_reg[B_CH_BASE+%d],\n',a-(i-1)*4,a-(i-1)*4-1,a-(i-1)*4-2,a-(i-1)*4-3);
    end
fprintf(fid,'\n');
a=a+DATA_NUM(j+1)+DATA_NUM(j)/8;
end
fclose(fid);
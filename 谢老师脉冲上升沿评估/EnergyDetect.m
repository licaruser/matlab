function [PulseUpPos PulseDownPos PulseUpFlag PulseDownFlag] = EnergyDetect(DataIn)
%%%%%%%%%%%%%%%%%%% 能量检测方法 %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 版本:     V1.0
% 参数意义：
%           DataIn：输入数据
%           PulseUpPos:脉冲前沿的位置
%           PulseDownPos:脉冲后沿的位置
%           PulseUpFlag:DOB滤波器是否检测到脉冲前沿的标志
%           PulseDownFlag:DOB滤波器是否检测到脉冲后沿的标志
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
PulseUpFlag = 0;
PulseDownFlag = 0;
PulseUpPos = 0;
PulseDownPos = 0;
%% 检测所用的参数
FrameSize = 128;
DataLength = length(DataIn);
% FrameNum = floor(DataLength/FrameSize);
%% 1、利用前面的纯噪声部分计算噪声功率和方差
DataRead = DataIn.*DataIn;
NoisePower = mean(DataRead(1:32*FrameSize));
%% 2、能量检测方法检测脉冲边沿
PulseFlag = 0;
CntBegin = 0;
CntEnd = 0;
BeginFrameThrh = 128;
EndFrameThrh = 128;
data_buff= zeros(1,FrameSize);
for k = 1:DataLength
    for j=2:FrameSize
        data_buff(FrameSize-j+2) =  data_buff(FrameSize-j+1);
    end
     data_buff(1) = DataRead(k);
     
    DataPower = mean(data_buff);              %获取这一帧的信号平均功率
    if (DataPower > 1.5*NoisePower)
        CntEnd = 0;
        CntBegin = CntBegin + 1;
        if (CntBegin >= BeginFrameThrh)   %连续有超过BeginFrameThrh帧信号超过检测门限，则认为是脉冲开始
            if (PulseFlag == 0)                   %此前还未检测到脉冲
%                 % 寻找精确的脉冲起始位置
                  PulseUpPos = k-FrameSize+1;
             end                
                PulseUpFlag = 1;
                PulseFlag = 1;     
         end
           
    else
        if PulseFlag == 1
            CntEnd = CntEnd + 1;
            if CntEnd >= EndFrameThrh       %有连续超过EndFrameThrh帧信号低于检测门限，则认为是脉冲结束 
                % 寻找精确的脉冲结束位置
                  PulseDownPos =  k-FrameSize-127;
%                 PulseDownPos = (k-EndFrameThrh)*FrameSize;
%                 for l = 1:FrameSize
%                     ptr = (k-EndFrameThrh-1)*FrameSize;
%                     TempData = DataRead(ptr+l:ptr+l+FrameSize);
%                     TempPower = mean(TempData);
%                     if TempPower < 1.4*NoisePower
%                         PulseDownPos = ptr + l;
%                         break;
%                     end
%                 end
                PulseDownFlag = 1;
                PulseFlag = 0;
                CntBegin = 0;
          
            end
        else
            CntBegin = 0;
            CntEnd = 0; 
        end
    end
end
            
 

        
        
        
        

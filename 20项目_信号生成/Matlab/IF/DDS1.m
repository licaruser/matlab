%-------------------------------
%N：2^N等价于pi/2，表的大小为2^N,即pi/2
%2^(N+1)等价pi，2^(N+2)等价2pi
%其余的象限通过三角函数变换得到
%只做一张(0-pi/2)的正弦表，余弦和其它象限通过正弦表得到
%输出为12位,包括符号位
%-------------------------------

function [dds_out_imag,dds_out_real] = DDS1(N,phase,N1)
if(phase>=2^(N-2)*3)%3/2*pi
   phase1 = 2^N-phase;   
   dds_out_imag = -floor(sin(2*pi*phase1*2^N/2^(2*N))*(2^N1-1));
   phase2=2^(N-2)*3-phase;
   dds_out_real = -floor(sin(2*pi*phase2*2^N/2^(2*N))*(2^N1-1));
   
elseif(phase>=2^(N-2)*2)%pi
    phase1=phase-2^(N-1);
    phase2=phase-2^(N-2);
    dds_out_imag = -floor(sin(2*pi*phase1*2^N/2^(2*N))*(2^N1-1));
    dds_out_real = -floor(sin(2*pi*phase2*2^N/2^(2*N))*(2^N1-1)); 
elseif(phase>=2^(N-2))
     phase1=2^(N-1)-phase;
     phase2=phase-2^(N-2);
    dds_out_imag = floor(sin(2*pi*phase1*2^N/2^(2*N))*(2^N1-1));
     dds_out_real = -floor(sin(2*pi*phase2*2^N/2^(2*N))*(2^N1-1)); 
else
    phase1=phase; 
    phase2=2^(N-2)-phase;
    dds_out_imag = floor(sin(2*pi*phase1*2^N/2^(2*N))*(2^N1-1));
     dds_out_real = floor(sin(2*pi*phase2*2^N/2^(2*N))*(2^N1-1)); 
end
% dds_out_imag = (sin(2*pi*phase*2^N/2^(2*N))*(2^N1-1));
   


   
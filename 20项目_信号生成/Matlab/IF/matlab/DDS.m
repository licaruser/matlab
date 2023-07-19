%-------------------------------
%N：2^N等价于pi/2，表的大小为2^N,即pi/2
%2^(N+1)等价pi，2^(N+2)等价2pi
%其余的象限通过三角函数变换得到
%只做一张(0-pi/2)的正弦表，余弦和其它象限通过正弦表得到
%输出为12位,包括符号位
%-------------------------------

function [dds_out] = DDS(N,phase,N1)
    
    if(phase<=2^N)%0<pi/2        
        dds_out_real = round(sin((2^N-phase)/2^N*pi/2)*(2^N1-1));%cos(a)=sin(pi/2-a)
        dds_out_imag = round(sin(phase/2^N*pi/2)*(2^N1-1));
    elseif((phase>2^N)&&(phase<=2^(N+1)))%pi/2<p<pi
        phase = 2^(N+1)-phase;
        dds_out_real = -round(sin((2^N-phase)/2^N*pi/2)*(2^N1-1));
        dds_out_imag = round(sin(phase/2^N*pi/2)*(2^N1-1)); 
    elseif(phase>2^(N+1)&&(phase<=(2^N*3)))%pi<p<pi*3/2
        phase = phase-2^(N+1);
        dds_out_real = -round(sin((2^N-phase)/2^N*pi/2)*(2^N1-1));
        dds_out_imag = -round(sin(phase/2^N*pi/2)*(2^N1-1)); 
    else
         phase = 2^(N+2)-phase;
         dds_out_real = round(sin((2^N-phase)/2^N*pi/2)*(2^N1-1));
        dds_out_imag = -round(sin(phase/2^(N)*pi/2)*(2^N1-1)); 
    end
    dds_out = dds_out_real + dds_out_imag*sqrt(-1);

   
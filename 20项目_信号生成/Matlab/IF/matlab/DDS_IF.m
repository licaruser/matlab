%-------------------------------
%N：2^N等价于pi/2，表的大小为2^N,即pi/2
%2^(N+1)等价pi，2^(N+2)等价2pi
%其余的象限通过三角函数变换得到
%只做一张(0-pi/2)的正弦表，余弦和其它象限通过正弦表得到
%输出为12位,包括符号位
%-------------------------------

function [dds_out] = DDS_IF(Q_pi_half,phase,N1)
    Q_pi=Q_pi_half*2;
    Q_pi_1_5=Q_pi_half*3;
    Q_pi_2 = Q_pi_half*4;
    
    
    if(phase<=Q_pi_half)%0<pi/2        
        dds_out_real = floor(sin((Q_pi_half-phase)/Q_pi_half*pi/2)*(2^N1-1));%cos(a)=sin(pi/2-a)
        dds_out_imag = floor(sin(phase/Q_pi_half*pi/2)*(2^N1-1));
    elseif((phase>Q_pi_half)&&(phase<=Q_pi))%pi/2<p<pi
        phase = Q_pi-phase;
        dds_out_real = -floor(sin((Q_pi_half-phase)/Q_pi_half*pi/2)*(2^N1-1));
        dds_out_imag = floor(sin(phase/Q_pi_half*pi/2)*(2^N1-1)); 
    elseif(phase>Q_pi&&(phase<=Q_pi_1_5))%pi<p<pi*3/2
        phase = phase-Q_pi;
        dds_out_real = -floor(sin((Q_pi_half-phase)/Q_pi_half*pi/2)*(2^N1-1));
        dds_out_imag = -floor(sin(phase/Q_pi_half*pi/2)*(2^N1-1)); 
    else
         phase = Q_pi_2-phase;
         dds_out_real = floor(sin((Q_pi_half-phase)/Q_pi_half*pi/2)*(2^N1-1));
        dds_out_imag = -floor(sin(phase/Q_pi_half*pi/2)*(2^N1-1)); 
    end
    dds_out = dds_out_real + dds_out_imag*sqrt(-1);

   

clear all
load 'PCMCode_5.mat';
PCMCode_5_Q = floor(PCMCode_5/2/pi*2^16);
wave1=floor(exp(sqrt(-1)*2*pi*PCMCode_5_Q/2^16)*2^15);
PCMCode_5_Q = mod(PCMCode_5_Q,2^16);
% wave2=floor(exp(sqrt(-1)*2*pi*PCMCode_5_Q/2^16)*2^15);
% wave3=floor(exp(sqrt(-1)*PCMCode_5)*2^15);
% wave4=wave3/2^15;
fid=fopen('PCMCode_5_Q.dat','w');
fprintf(fid,'%d\n',PCMCode_5_Q);
fclose(fid);
m_CodeNumAll = 512 * 31;%%%查表最大值 特定模式 表大小
m_fs = 1000e6;
pulse_num =16;%%16个脉冲
code_num = 32;%%有32个码字
m_CodeWidth = 0.02e-6;
m_PCMCodeIndex = 5;
%m_PulseWidth = m_CodeWidth*(2^m_PCMCodeIndex-1);
m_PulseWidth = m_CodeWidth*(code_num-1);
m_SubStepNum = 8;%%每个脉冲分成8个子脉冲 每个子脉冲频点不同
Npw = m_fs*m_PulseWidth;

m_SubStepFreInterval = floor((10e6/m_fs)*2^32);

	for i = 1: m_SubStepNum   %%

% 		m_SubPulseFre(i) = -(m_SubStepNum / 2 - 0.5)*2 * m_SubStepFreInterval + (i-1)*2 * m_SubStepFreInterval;
        SubFreq_sequence(i)= (-(m_SubStepNum / 2 - 0.5) +(i-1))*2;      
        m_SubPulseFre(i) = SubFreq_sequence(i)*m_SubStepFreInterval; 
    end
    	for i = 1: m_SubStepNum/2   %%
          SubFreq_sequence_h(i) = SubFreq_sequence(i*2);
          SubFreq_sequence_l(i) = SubFreq_sequence(i*2-1);
        end
       for i = 1: m_CodeNumAll/2   %%
          PCMCode_5_Q_h(i) = PCMCode_5_Q(i*2);
          PCMCode_5_Q_l(i) = PCMCode_5_Q(i*2-1);
    end
fid=fopen('SubFreq_sequenceh.dat','w');
fprintf(fid,'%d\n',SubFreq_sequence_h);
fclose(fid);

fid0=fopen('SubFreq_sequencel.dat','w');
fprintf(fid,'%d\n',SubFreq_sequence_l);
fclose(fid);

fid1=fopen('PCMCode_5_Q_h.dat','w');
fprintf(fid,'%d\n',PCMCode_5_Q_h);
fclose(fid);

fid2=fopen('PCMCode_5_Q_l.dat','w');
fprintf(fid,'%d\n',PCMCode_5_Q_l);
fclose(fid);



% PhaseHnPulse= zeros(pulse_num,)
PulseNumTh=0; 

 for PulseNumTh=0:pulse_num-1   %%%16个脉冲

   [Hn1,Phase_code] = ComplexCodeGenerate_Q(PulseNumTh,Npw,m_SubStepNum,m_PCMCodeIndex,m_fs,m_CodeWidth,PCMCode_5_Q,m_CodeNumAll);
   [Hn,phase_freq] =ComplexWaveBaseBandPhaseGenerate_Q(Npw,m_fs,m_CodeWidth,Hn1,m_PCMCodeIndex,m_SubPulseFre,m_SubStepNum);
   phase_freq_d = floor(phase_freq/2^16);
  phase_sum=Phase_code+ floor(phase_freq/2^16);
  phase_sum1=mod(phase_sum,2^16);
  phase_sum2=floor(phase_sum1/2^3);
  Hn2=floor(exp(sqrt(-1)*2*pi*phase_sum2/2^13)*2^15);
 end
 
 ChNum =4;
 Hn2_four = zeros(4,Npw*m_SubStepNum/4);
 for i=1:ChNum
    Hn2_four(i,1:end) = Hn2(i:ChNum:end);
   end 
     %%
     %写文件
     
       for i = 1: m_CodeNumAll/2   %%
         PCMcoderam(i) =   PCMCode_5_Q(i);
       end
      for i = 1: m_SubStepNum/2   %%
         SubFreq_sequ(i) =  SubFreq_sequence_h(i)*2^8 + SubFreq_sequence_l(i);
      end
 a = 1 + 2*2^16 + 3*2^32 + 4*2^48 + 5*2^64 + 6* 2^80 +7*2^96 + 8*2^112;
file_name_subf = strcat('subfreq_sequence.coe');
fid1_i=fopen(file_name_subf,'wb');
         
fprintf( fid1_i, 'memory_initialization_radix = 10;\n');                     
fprintf( fid1_i, 'memory_initialization_vector =\n')
 for ii=1:16
  fprintf(fid1_i,'%0.0f\n',a);
 end
 fclose(fid1_i);
 
 
 
pcm = strcat('PCM.coe');
fid1_i=fopen(pcm,'wb'); 
fprintf( fid1_i, 'memory_initialization_radix = 10;\n');                     
fprintf( fid1_i, 'memory_initialization_vector =\n')
 for ii=1:m_CodeNumAll/2
  fprintf(fid1_i,'%0.0f\n',PCMcoderam(ii));
 end
 fclose(fid1_i);

 
 
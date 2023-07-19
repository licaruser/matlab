
clear all
load 'PCMCode_5.mat';
m_fs = 1000e6;
pulse_num =16;
m_PCMCodeIndex = 5;
m_CodeWidth = 0.02e-6;
m_PulseWidth = m_CodeWidth*(2^m_PCMCodeIndex-1);
m_SubStepNum = 8;
Npw = m_fs*m_PulseWidth;

m_SubStepFreInterval = 10e6;

	for i = 1: m_SubStepNum

		m_SubPulseFre(i) = -(m_SubStepNum / 2 - 0.5)*2 * m_SubStepFreInterval + (i-1) * 2*m_SubStepFreInterval;
	end


% PhaseHnPulse= zeros(pulse_num,)
PulseNumTh=0;
m_CodeNumAll = 512 * 31;
 for PulseNumTh=0:pulse_num-1

   [Hn1,PhaseHnPulse] = ComplexCodeGenerate(PulseNumTh,Npw,m_SubStepNum,m_PCMCodeIndex,m_fs,m_CodeWidth,PCMCode_5,m_CodeNumAll);
   [Hn] =ComplexWaveBaseBandPhaseGenerate(Npw,m_fs,m_CodeWidth,Hn1,m_PCMCodeIndex,m_SubPulseFre,m_SubStepNum);

 end
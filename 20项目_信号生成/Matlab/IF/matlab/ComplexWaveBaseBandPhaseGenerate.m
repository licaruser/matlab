function [Hn] =ComplexWaveBaseBandPhaseGenerate(Npw,m_fs,m_CodeWidth,Hn1,m_PCMCodeIndex,m_SubPulseFre,m_SubStepNum)

	 PointNum = (m_CodeWidth * m_fs);%单个码元点数
	 StepFret = linspace(0.0, double(Npw - 1), Npw) / m_fs;
     
	for  kk = 0:m_SubStepNum-1 

		for ll = kk*((2^m_PCMCodeIndex) - 1) * PointNum:(kk + 1)*(2^m_PCMCodeIndex - 1) * PointNum-1
		
			 SubPhase(ll - kk*(2^m_PCMCodeIndex - 1)*PointNum+1) = 2.0 * pi * (m_SubPulseFre(kk+1)) * StepFret(ll - kk*(2^m_PCMCodeIndex - 1)*PointNum+1);
             freqmodule(ll+1)=(cos(SubPhase(ll - kk*(2^m_PCMCodeIndex - 1)*PointNum+1))+sqrt(-1)*sin(SubPhase(ll - kk*(2^m_PCMCodeIndex - 1)*PointNum+1)));
			 Hn(ll+1) = Hn1(ll+1)*(cos(SubPhase(ll - kk*(2^m_PCMCodeIndex - 1)*PointNum+1))+sqrt(-1)*sin(SubPhase(ll - kk*(2^m_PCMCodeIndex - 1)*PointNum+1)));
		end
	end

end

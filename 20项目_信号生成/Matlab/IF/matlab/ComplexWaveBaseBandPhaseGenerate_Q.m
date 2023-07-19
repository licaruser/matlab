function [Hn,phase_save] =ComplexWaveBaseBandPhaseGenerate_Q(Npw,m_fs,m_CodeWidth,Hn1,m_PCMCodeIndex,m_SubPulseFre,m_SubStepNum)

	 PointNum = (m_CodeWidth * m_fs);%单个码元点数
	 StepFret = linspace(0.0, double(Npw - 1), Npw) ;
     phase_save = zeros(1,m_SubStepNum*((2^m_PCMCodeIndex) - 1) * PointNum);
     
	for  kk = 0:m_SubStepNum-1 

		for ll = kk*((2^m_PCMCodeIndex) - 1) * PointNum:(kk + 1)*(2^m_PCMCodeIndex - 1) * PointNum-1
		    
			% SubPhase(ll - kk*(2^m_PCMCodeIndex - 1)*PointNum+1) =  (m_SubPulseFre(kk+1)) * StepFret(ll - kk*(2^m_PCMCodeIndex - 1)*PointNum+1);
            SubPhase(ll - kk*(2^m_PCMCodeIndex - 1)*PointNum+1) =  (m_SubPulseFre(kk+1))*(2^2) * StepFret(ll - kk*(2^m_PCMCodeIndex - 1)*PointNum+1);
             freqmodule(ll+1)=(cos(2*pi*SubPhase(ll - kk*(2^m_PCMCodeIndex - 1)*PointNum+1)/2^32)+sqrt(-1)*sin(2*pi*SubPhase(ll - kk*(2^m_PCMCodeIndex - 1)*PointNum+1)/2^32));
			 Hn(ll+1) = Hn1(ll+1)*(cos(2*pi*SubPhase(ll - kk*(2^m_PCMCodeIndex - 1)*PointNum+1)/2^32)+sqrt(-1)*sin(2*pi*SubPhase(ll - kk*(2^m_PCMCodeIndex - 1)*PointNum+1)/2^32));
             
        end
        phase_savedd (kk*((2^m_PCMCodeIndex) - 1) * PointNum+1:(kk+1)*((2^m_PCMCodeIndex) - 1) * PointNum)= SubPhase; 
        phase_save(kk*((2^m_PCMCodeIndex) - 1) * PointNum+1:(kk+1)*((2^m_PCMCodeIndex) - 1) * PointNum)= mod(SubPhase,2^32);
    end


    
    
    
end

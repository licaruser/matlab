  function [dataout_IF,dds_out0_save]=Modulate_IF(datain_bb,len,k0,init_phase0,Q_coef_IF,Q_Cut,Nddsout)
  phase_sum0 =0;

  Q_pi_half=floor((Q_coef_IF/Q_Cut)/4);%局部参数
  for i=1:len
        phase_all0 = phase_sum0 + init_phase0;
        if(phase_all0>=Q_coef_IF)
          phase_all0 = phase_all0-Q_coef_IF;    
        end
        phase_sum0 = phase_sum0 + k0; 
        if(phase_sum0>=Q_coef_IF)
           phase_sum0 = phase_sum0-Q_coef_IF;  
        end
      
       
        
        
        
        
%         if(phase_all0>=2^Ndds1)%大于2pi,减去2pi
%            phase_all0 =  phase_all0 - 2^Ndds1;
%         end
%         if(phase_all1>=2^Ndds1)%大于2pi,减去2pi
%            phase_all1 =  phase_all1 - 2^Ndds1;
%         end
%         if(phase_all2>=2^Ndds1)%大于2pi,减去2pi
%            phase_all2 =  phase_all2 - 2^Ndds1;
%         end
        phase_sum0a_save0(i) = phase_all0;
        phase_sum0a = floor(phase_all0/Q_Cut);%不要用除法，用乘法
        phase_sum0a_save(i) = phase_sum0a;
   
%         phase_sum0a = (phase_sum0/2^(2*Ndds));
%         phase_sum1a = (phase_sum1/2^(2*Ndds));
%         phase_sum2a = (phase_sum2/2^(2*Ndds));

        [dds_out0] = DDS_IF(Q_pi_half,phase_sum0a,Nddsout);
        dds_out0_save(i) = dds_out0;
      
       % dataout_IF(i) = real(datain_bb(i))*real(dds_out0)-imag(datain_bb(i))*imag(dds_out0);%中频输出只有实部。
       dataout_IF(i) = floor(dds_out0*datain_bb(i)/2^15);
%         dataout_IF(i) =dds_out0_save(i);
  
        
  end
  dataout_IF;  
  
function [Q_phasecode1]=quad_phasecode_Q(N,s,k,phase_init,len,Ndds1,Ndds,Nddsout)

phase = 0;
phase1 = 0;
cnt =0;
Vk0_real = [1,1,-1,-1,1,1,1,1,1,1,-1,-1,1,1];
Vk0_imag = [0,1,1,-1,-1,-1,-1,-1,-1,-1,-1,1,1,0];
%Vk0_imag = [0,-1,-1,1,1,1,1,1,1,1,1,-1,-1,0];

Vk1_real = [1,1,-1,-1,1,1,1,1,1,1,-1,-1,1,1];
Vk1_imag = [0,-1,-1,1,1,1,1,1,1,1,1,-1,-1,0];
for i=1:len
      if(mod(i,N)==1)
            cnt =  cnt + 1;
           if(cnt==15)%vhdl中应该是13
               cnt = 1;%vhdl中应该是0
           end
         
           
          
      end
       cnt_save(i)=cnt;     
          
      if(mod(i,2*N)==1)
         phase =  0;
      else
         phase = phase + k;
      end
       if(mod(i+N,2*N)==1)
         phase1 =  0;
      else
         phase1 = phase1 + k;
       end
      phasea = phase + phase_init;
      phaseb = phase1 + phase_init;
%       if(phasea>=0.5)
%          phasea = phasea - 0.5;
%       end   
%       if(phaseb>=0.5)
%          phaseb = phaseb - 0.5;
%       end   
      phase_save(i) = phasea;
      phase_save1(i) = phaseb;
      phasea = floor(phasea/2^(Ndds1-(Ndds+2)));
      phaseb = floor(phaseb/2^(Ndds1-(Ndds+2)));
      phase_savea(i) = phasea;
      phase_save1a(i) = phaseb;
      if(s==0)
          Q_phasecode1(i) =imag(DDS(Ndds,phasea,Nddsout))*Vk0_real(cnt)+sqrt(-1)*imag(DDS(Ndds,phaseb,Nddsout))*Vk0_imag(cnt);
      else
           Q_phasecode1(i) =imag(DDS(Ndds,phasea,Nddsout))*Vk1_real(cnt)+sqrt(-1)*imag(DDS(Ndds,phaseb,Nddsout))*Vk1_imag(cnt);
      end
      
%         if(s==1)
%            Q_phasecode1(i) =sin(phasea*2*pi)*Vk0_real(cnt) + sqrt(-1)*sin(phaseb*2*pi)*Vk0_imag(cnt);
%         else
%            Q_phasecode1(i) =sin(phasea*2*pi)*Vk1_real(cnt) + sqrt(-1)*sin(phaseb*2*pi)*Vk1_imag(cnt);
%         end
end

i=0;
function Echo = Echo_sim(RO,Vr,N_CI,SNR,fai_t,Sbarker,nPRT,nTp,PRT,Fs,Fc,C,juli_max,Ny,d_lambda_1)

Echo = zeros(N_CI,max(nPRT)-nTp,size(nPRT,2),Ny);                          %存放全部CPI的回波,一维脉冲个数，二维脉冲点数
                                                                           %三维CPI,四维通道信息
%% 回波模拟
    for k = 1 : size(nPRT,2)                                               %cpi循环
        Echo_r = zeros(N_CI,max(nPRT),size(RO,2),Ny);                      %存放单个CPI所有目标的回波,一维脉冲个数
                                                                           %二维脉冲点数，三维目标信息,四维通道信息
        for ii = 1 : size(RO,2)                                            %目标个数循环
            aat = exp(1i*2*pi*d_lambda_1*[0:1:(Ny-1)]'*sin(fai_t(ii)*pi/180));%目标导向矢量
            real_juli = RO(ii);
            juli_n = fix((real_juli)*2*Fs/C);
            for i = 1:N_CI                                                 %脉冲个数循环
               juli = RO(ii) - Vr(ii)*PRT(k)*(i-1);
        %       juli_n = fix((real_juli)*2*Fs/C);
               
               if(real_juli> juli_max(k))                                  %目标距离较远时，前几个prt接收不到回波
                   real_juli = real_juli- juli_max(k);
                   juli_n = fix((real_juli)*2*Fs/C);
               else
                   Echo_r(i,juli_n+1:juli_n+nTp,ii,1) = Sbarker.* exp(-1i*2*pi*juli*2/(C/Fc));  %加入距离和速度信息
               end
            end
            %Echo_r(:,:,ii,1) = awgn(Echo_r(:,:,ii,1),SNR(ii), 'measured');  %加入噪声(感觉有点有问题)
            Sr = aat*reshape(Echo_r(:,:,ii,1),1,[]);                       %加入方位信息，一通道变为16通道
            Echo_r(:,:,ii,:)  = reshape(Sr.',N_CI,[],1,Ny);
        end
        Echo(:,1:(nPRT(k)-nTp),k,:) = sum(Echo_r(:,1+nTp:nPRT(k),:,:),3);  %单个CPI多目标回波相加
    end
    
end





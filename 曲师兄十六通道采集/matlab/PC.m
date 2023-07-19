function pc = PC(s_barker,MY_NFFT,coeff)

    pc = zeros(size(s_barker));
    for i = 1:size(s_barker,3)                                             %CPI
        %reshape目的是把三维数组转化为两维的，fft的参数2是代表行的方向做fft,默认为列的方向
        s_barker_fft = fft(reshape(s_barker(:,:,i),size(s_barker,1),size(s_barker,2)),MY_NFFT,2);
        out = s_barker_fft.*coeff;

        bit_length = max( [size(dec2bin(max(abs(real(out)))),2) size(dec2bin(max(abs(imag(out)))),2) ]);
        if( bit_length > 15 )
            out = round(out./(2^(bit_length-15)));
        end

        pc(:,:,i) = ifft(out,MY_NFFT,2);                                   %2表示行的方向做ifft
        
        a = pc(:,:,i);
        b = reshape(a,size(s_barker,1),size(s_barker,2));
        figure;mesh(abs(b));title(['PC',num2str(i)]);
    end

end
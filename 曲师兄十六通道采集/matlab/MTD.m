function mtd = MTD(pc)

mtd = zeros(size(pc));
    for i= 1:size(pc,3)                                                    %cpi循环
        a = reshape(pc(:,:,i),size(pc,1),size(pc,2));                      %三维数组变为两维的
        mtd_r = fftshift(fft(a),1);                                        %1代表列(多普勒维)方向做fftshift
        
        bit_length = max( [size(dec2bin(max(abs(real(mtd_r)))),2) size(dec2bin(max(abs(imag(mtd_r)))),2) ]);
        if( bit_length > 15 )
            mtd_r = round(mtd_r./(2^(bit_length-15)));
        end
     mtd(:,:,i) = mtd_r;
    figure;mesh(abs(mtd_r) );title(['MTD',num2str(i)]);
    end
end
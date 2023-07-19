function s_barker = Decimation(Echo,MY_NFFT,decimation)


    s2 = zeros(size(Echo,1),MY_NFFT*decimation,size(Echo,3));               %20±∂≥È»°
    s2(:,1:size(Echo,2),:) = Echo;
    s_barker = s2;
    s_barker = permute(s_barker,[2 1 3]);
    s_barker = reshape(s_barker,1,[]);
    s_barker = reshape(s_barker,decimation,[]);                                
    s_barker = s_barker(1,:);
    s_barker = reshape(s_barker,MY_NFFT,size(Echo,1),[]);
    s_barker = permute(s_barker,[2 1 3]);


end
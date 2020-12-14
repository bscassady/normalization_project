function prop_common = similarity(A, B, binary_threshold)
    % Generates a binary mask of an image with a given threshold.
    [height,width] = size(A);
    BinA = binary_mask(A, binary_threshold);
    BinB = binary_mask(B, binary_threshold);
    nb_common = 0;
    total = 0;
    for i = 1:height  
        for j = 1:width
            total = total + 1;
            if A(i,j) == B(i,j)
                nb_common = nb_common + 1;
            end
        end
    end
    prop_common = nb_common/total;
end
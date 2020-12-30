function mask = binary_mask(I, threshold)
    % Generates a binary mask of an image with a given threshold.
    [M,N] = size(I);
    mask = zeros(M,N);
    for i = 1:M  
        for j = 1:N 
            if I(i,j) > threshold
                mask(i,j) = 1;
            end 
        end
    end
end

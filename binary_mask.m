function mask = binary_mask(I, threshold)
    % Generates a binary mask of an image with a given threshold.
    [height,width] = size(I);
    mask = zeros(height,width);
    for i = 1:height  
        for j = 1:width 
            if im(i,j) > threshold
                mask(i,j) = 1;
        end 
    end
end

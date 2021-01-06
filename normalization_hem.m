function normed_hipsi = normalization_hem(Hipsi, Hsymcontra)
    % Normalizes Hipsi using Hsymcontra : for every pixel of binary Hipsi,
    % normed_hipsi is abs of Hipsi minus Hsymcontra
    [height, width] = size(Hipsi);
    normed_hipsi = zeros(height, width);
    for i = 1:height
        for j = 1:width
            normed_hipsi(i,j) = abs(Hipsi(i,j)-Hsymcontra(i,j));
        end
    end
end
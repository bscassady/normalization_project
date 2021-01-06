% function prop_common = similarity(A, B, binary_threshold)
%     % Gives the proportion of pixels in common between the two binary masks
%     % of images A and B, given a threshold
%     [height,width] = size(A);
%     BinA = binary_mask(A, binary_threshold);
%     BinB = binary_mask(B, binary_threshold);
%     nb_common = 0;
%     total = 0;
%     for i = 1:height  
%         for j = 1:width
%             total = total + 1;
%             if BinA(i,j) == BinB(i,j)
%                 nb_common = nb_common + 1;
%             end
%         end
%     end
%     prop_common = nb_common/total;
% end

function prop_common = similarity(A1, B1)
    % Gives the proportion of pixels in common between two binary masks
    [height, width] = size(A1);
    nb_common = 0;
    total = 0;
    for i = 1:height  
        for j = 1:width
            total = total + 1;
            if A1(i,j) == B1(i,j)
                nb_common = nb_common + 1;
            end
        end
    end
    prop_common = nb_common/total;
end

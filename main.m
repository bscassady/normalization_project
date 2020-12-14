%%
    

% Display brain's image
colormap('gray'), subplot(1,2,1);
imagesc(B1);

% Create binary mask of brain and display it
BiMaB1 = binary_mask(V, 80);
subplot(1,2,2); imagesc(BiMaB1);

% Create Bounding ellipse and display it on mask


    
% A_line = BiMa;
% The median vertical line of the image is shown in white
% imshow(A_line, [0 255]); title('Original rotated image with the median vertical axis of the image (white)');
% mask = center_image(BiMa);


% Create Bounding Box (BB) and display it on the mask
BB = regionprops(BiMa, 'BoundingBox'); % Returns x, y, w & h : position of the upper left corner and width and length of rectangle resp.
subplot(1,2,1), rectangle('Position', [BB.BoundingBox(1), BB.BoundingBox(2), BB.BoundingBox(3), BB.BoundingBox(4)],'EdgeColor','r','LineWidth',2 )

% Create median vertical line of Bounding Box
x = [(BB.BoundingBox(1) + BB.BoundingBox(3)/2) (BB.BoundingBox(1) + BB.BoundingBox(3)/2)];
y = [BB.BoundingBox(2) (BB.BoundingBox(2) + BB.BoundingBox(4))];
subplot(1,2,1), line(x,y, 'Color','red','LineWidth',2); %Approximation not good

% 2.3.1 Superposition des deux hémisphères
proportion_pixels_communs = similarity(B1, B1, 80);
proportion_pixels_communs

% Create a method to find line to line the position of the longitudinal fissure and give a map of uncertainty of its position
% % Loop to go through image inside bounding box
% % Get intensity profile and detect when == 0 : if == 0 draw linear
% regression on original image
% % and calculate distance from this point to line D
% % Gather distances in a map and connect dots

dist_map = containers.Map;
for x = BB.BoundingBox(1) : (BB.BoundingBox(1) + BB.BoundingBox(3))
    for y = BB.BoundingBox(2) : (BB.BoundingBox(2) + BB.BoundingBox(4))

        if V(int16(x),int16(y)) == 0
        end
        if brain(x,y) == 0

        end
    end
end



% Functions



function new_im = shift_image(im, shift)
    [M,N]=size(im);
    if (shift>0)
        new_im = [im(:,int16(shift+1):N) im(:,1:int16(shift))];
    elseif (shift<0)
        new_im = [im(:,N-abs(int16(shift))+1:N) im(:,1:N-abs(int16(shift)))];
    else
        new_im = im;
    end
end 
    
function new_im = center_image(im)
    el = regionprops(im, {'Centroid', 'MajorAxisLength', 'MinorAxisLength', 'Orientation'});
    center = el(1).Centroid(2); % x number of rotated centroid
    [M,N]=size(im);
    shift = center-N/2;
    if (shift>0)
        new_im = [im(:,int16(shift+1):N) im(:,1:int16(shift))];
    elseif (shift<0)
        new_im = [im(:,N-abs(int16(shift))+1:N) im(:,1:N-abs(int16(shift)))];
    else
        new_im = im;
    end
end

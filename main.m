% Display brain's image
colormap('gray'), subplot(1,2,1);
imagesc(B1);

% Create binary mask of brain and display it
BiMaB1 = binary_mask(B1, 80);
subplot(1,2,2); imagesc(BiMaB1);

% Create Bounding ellipse and display it on mask

% Create Bounding Box (BB) and display it on the mask
BB = regionprops(BiMaB1, 'BoundingBox'); % Returns x, y, w & h : position of the upper left corner and width and length of rectangle resp.
rectangle('Position', [BB.BoundingBox(1), BB.BoundingBox(2), BB.BoundingBox(3), BB.BoundingBox(4)],'EdgeColor','r','LineWidth',2 )

% Create median vertical line of Bounding Box
x = [(BB.BoundingBox(1) + BB.BoundingBox(3)/2) (BB.BoundingBox(1) + BB.BoundingBox(3)/2)];
y = [BB.BoundingBox(2) (BB.BoundingBox(2) + BB.BoundingBox(4))];
line(x,y, 'Color','red','LineWidth',2); %Approximation not good

% Create a method to find line to line the position of the longitudinal fissure and give a map of uncertainty of its position
% % Loop to go through image inside bounding box
% % Get intensity profile and detect when == 0 : if == 0 draw point on mask
% % and calculate distance from this point to line D
% % Gather distances in a map and connect dots
dist_map = containers.Map;
for x = BB.BoundingBox(1) : (BB.BoundingBox(1) + BB.BoundingBox(3))
    for y = BB.BoundingBox(2) : (BB.BoundingBox(2) + BB.BoundingBox(4))
        if B1(x,y) == 0
            
        end
    end
end

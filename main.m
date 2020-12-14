brain = B1;

% Display brain's image
colormap('gray'), subplot(1,2,1);
imagesc(brain);

% Create binary mask of brain and display it
BiMa = binary_mask(brain, 80);
subplot(1,2,2); imagesc(BiMa);

% Create Bounding ellipse and display it on mask

% Create Bounding Box (BB) and display it on the mask
BB = regionprops(BiMa, 'BoundingBox'); % Returns x, y, w & h : position of the upper left corner and width and length of rectangle resp.
subplot(1,2,1), rectangle('Position', [BB.BoundingBox(1), BB.BoundingBox(2), BB.BoundingBox(3), BB.BoundingBox(4)],'EdgeColor','r','LineWidth',2 )

% Create median vertical line of Bounding Box
x = [(BB.BoundingBox(1) + BB.BoundingBox(3)/2) (BB.BoundingBox(1) + BB.BoundingBox(3)/2)];
y = [BB.BoundingBox(2) (BB.BoundingBox(2) + BB.BoundingBox(4))];
subplot(1,2,1), line(x,y, 'Color','red','LineWidth',2); %Approximation not good

% Create a method to find line to line the position of the longitudinal fissure and give a map of uncertainty of its position
% % Loop to go through image inside bounding box
% % Get intensity profile and detect when == 0 : if == 0 draw linear
% regression on original image
% % and calculate distance from this point to line D
% % Gather distances in a map and connect dots
dist_map = containers.Map;
for x = BB.BoundingBox(1) : (BB.BoundingBox(1) + BB.BoundingBox(3))
    for y = BB.BoundingBox(2) : (BB.BoundingBox(2) + BB.BoundingBox(4))
        if brain(x,y) == 0
            
        end
    end
end



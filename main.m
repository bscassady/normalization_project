brain = B1;


V = niftiread('data/B1.nii');
figure(1);
subplot(1,2,1);
imagesc(V);
%Create a binary mask of the image
maskV = binary_mask(V, 80);
subplot(1,2,2);imshow(maskV);
%CENTERING AND DRAWING ELLIPSE
%bonding ellipse of the original image
el = regionprops(maskV, {'Centroid', 'MajorAxisLength', 'MinorAxisLength', 'Orientation'});
maskV = imrotate(maskV,90);
V=imrotate(V,90);
[M,N] = size(maskV);

propsV = regionprops(maskV, 'BoundingBox');
bbxV = vertcat(propsV.BoundingBox);
center = el(1).Centroid(2); 
shift1 = center - N/2;%Shift necessary to center the image
V_shift = shift_image(maskV, shift1);

V=shift_image(V, shift1);
figure(2);
subplot(1,2,1);imshow(V_shift);% shift the center of the ellipse on the median vertical line of the image
angle1 = -el(1).Orientation;
V_rot = imrotate(V_shift, angle1);% rotate the brain so that major axis of the ellipse alings with the median line

V=imrotate(V,angle1);
[M2, N2] = size(V_rot);
if mod(N2,2)==1 
    N2 = N2-1;
    V_rot = V_rot(:, 1:N2);
end
V_line = V_rot;
V_line(:,int16(N2/2))=ones(M2,1)*255; %The brain should be centered 




%subplot(1,2,2); imshow(V_line);



% Create Bounding ellipse and display it on mask
el = regionprops(V_rot, {'Centroid', 'MajorAxisLength', 'MinorAxisLength', 'Orientation'});

subplot(1,2,2); imshow(V_line);

t = linspace(0,2*pi,50);
hold on
    for k = 1:length(el)
        a = el(k).MajorAxisLength/2;
        b = el(k).MinorAxisLength/2;
        Xc = el(k).Centroid(1);
        Yc = el(k).Centroid(2);
        phi = deg2rad(-el(k).Orientation);
        x = Xc + a*cos(t)*cos(phi) - b*sin(t)*sin(phi);
        y = Yc + a*cos(t)*sin(phi) + b*sin(t)*cos(phi);
        plot(x,y,'r','Linewidth',5);
        plot(Xc,Yc,'b','Linewidth',5);
    end

hold off

figure(3)
subplot(1,2,1);imagesc(V);
   

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

%%
%Segmentation of ipsilateral and contralateral hemispheres of the brain
V_clean=V.*int16(binary_mask(V, 80));
figure(4)
imagesc(V_clean);
[Hipsi, Hcontra,Hsymcontra]=partition(V_clean);
figure(5)
subplot(1,3,1);imagesc(Hipsi);
subplot(1,3,2);imagesc(Hcontra);
subplot(1,3,3);imagesc(Hipsi-Hsymcontra);
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


function [Hipsi, Hcontra,Hsymcontra]=partition(im)
    [M,N]=size(im);
    if mod(N,2)==1 % change the size of A_rot if the width is an odd number of pixels
        N = N-1;
        im = im(:, 1:N);
    end
    left=im(:,1:int16(N/2));
    right=im(:,int16(N/2)+1:int16(N));
    average_left=sum(sum(left)/nnz(left));
    average_right=sum(sum(right)/nnz(right));
    if average_left>average_right
        Hipsi=left;
        Hcontra=right;
    end
    if average_right>average_left
        Hipsi=right;
        Hcontra=left;
    end
    Hsymcontra = Hcontra(:, end:-1:1);
end

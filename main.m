% Choose brain image
V = B1;

% Display brain image
figure(1),subplot(1,2,1), colormap('gray');
imagesc(V); title('Original image of the brain');

%%
% 2.1.1 Create a binary mask of the brain.
maskV = binary_mask(V, 80);
figure(1),subplot(1,2,2);imshow(maskV); title('Binary mask of the brain');

%%
% 2.1.2 Calculate the bounding ellipse of the brain
el = regionprops(maskV, {'Centroid', 'MajorAxisLength', 'MinorAxisLength', 'Orientation'});

t = linspace(0,2*pi,50);
figure(2),colormap('gray'),imagesc(V);
hold on
    for k = 1:length(el)
        a = el(k).MajorAxisLength/2;
        b = el(k).MinorAxisLength/2;
        Xc = el(k).Centroid(1);
        Yc = el(k).Centroid(2);
        phi = deg2rad(-el(k).Orientation);
        x = Xc + a*cos(t)*cos(phi) - b*sin(t)*sin(phi);
        y = Yc + a*cos(t)*sin(phi) + b*sin(t)*cos(phi);
        plot(x,y,'g','Linewidth',2);
        plot(Xc,Yc,'g','Linewidth',2);
    end

hold off

%%
% 2.1.3 Rotate the image to align the major axis of the ellipse with the vertical axis

angle1 = -90 - el(1).Orientation; % Calculate angle between vertical axis and major axis of ellipse
maskV_rot = imrotate(maskV, angle1); % Rotate the mask so that major axis of the ellipse aligns with the vertical axis

V_rot = imrotate(V,angle1); % Original image centered and rotated
[M2, N2] = size(V_rot);

% Calculate ellipse of the rotated image
ellipse_rotated = regionprops(maskV_rot, {'Centroid', 'MajorAxisLength', 'MinorAxisLength', 'Orientation'});
center = ellipse_rotated(1).Centroid;

% Shift necessary to center the image
shift1 = int16(center(1) - M2/2); % Shift necessary in x-axis
shift2 =  int16(center(2) - N2/2); % Shift necessary in y-axis

% Align vertical axis with major axis of ellipse
maskV_shift = circshift(maskV_rot, [-shift2 -shift1]); % for binary mask
V_shift = circshift(V_rot, [-shift2 -shift1]); % for original image

% Shift the center of the ellipse on the median vertical line of the image
figure(3),subplot(1,2,1);
imshow(maskV_shift), title('Binary mask shifted with the axis of the ellipse');

V_line = V_shift;
V_line(:,int16(N2/2)) = ones(M2,1)*255;
subplot(1,2,2), colormap('gray'), imagesc(V_line);
title('Original brain image shifted with the axis of the ellipse');

%%
% 2.1.4 Calculate the bounding box of the brain
BB = regionprops(maskV, 'BoundingBox'); % Returns x, y, w & h : position of the upper left corner and width and length of rectangle resp.
X_BB = round(BB.BoundingBox(1));
Y_BB = round(BB.BoundingBox(2));
Width_BB = BB.BoundingBox(3);
Height_BB = BB.BoundingBox(4);

figure(2);
rectangle('Position', [BB.BoundingBox(1), BB.BoundingBox(2), BB.BoundingBox(3), BB.BoundingBox(4)],'EdgeColor','r','LineWidth',2 )

%%
% 2.1.5 Draw the median vertical line D of the bounding box
lx = [(X_BB + Width_BB/2) (X_BB + Width_BB/2)];
ly = [Y_BB (Y_BB + Height_BB)];
Xpos_D = X_BB + Width_BB/2;
figure(2), colormap('gray');
line(lx,ly, 'Color','r','LineWidth',2); % Approximation not good
title('Bounding box and its median line in red and bounding ellipse in green');

%%
% 2.1.6
% Using the position information of D and the profile of the gray level in the image along the lines horizontal, propose an
% automatic method to find line to line the position of the longitudinal fissure and give a map of uncertainty of its position

[V_fis, fissure] = get_fissure(V,BB,0.04); % Detection of the fissure in OG image, function at the bottom of this script

%%
% 2.1.7
% Give the line (which we will call the median axis Am) which best approximates the longitudinal
% fissure. Does this line coincide with the line D?

figure(4),colormap('gray');
imagesc(V_fis); title('Longitudinal fissure');

%Linear approximation of the fissure
fissure_trans = transpose(fissure);
y_approxi = fissure_trans(1,1:end);
x_approxi = double(int16(X_BB):1:int16(X_BB)+size(fissure,1)-1);

p_transpose = polyfit(x_approxi,y_approxi,1); %linear equation for transposed line

x_approxi  = double(1:1:size(V_fis,1));

p = [1/p_transpose(1) -(p_transpose(2)/p_transpose(1))]; %return linear equation to original axis

Am = p(1).*x_approxi+p(2); %line approximation
hold on
plot(x_approxi,Am,'y','Linewidth',1);

%%
% 2.1.8 Rotate the image so that the center line Am is aligned with the vertical axis

angle2 = atan(p(1))*(180/pi);%Angle between Am and vertical axis
   
if angle2 >= 0
    angle2 = angle2-90;
    V_rot = imrotate(V, angle2);
    maskV_rot = imrotate(maskV, angle2);
else
    angle2 = angle2 + 90;
    A_rot = imrotate(V, angle2);
    maskV_rot = imrotate(maskV, angle2);
end 

%Final shifting and centering 
[M,N] = size(maskV_rot);
ellipse_rotated = regionprops(maskV_rot, {'Centroid', 'MajorAxisLength', 'MinorAxisLength', 'Orientation'});
center = ellipse_rotated(1).Centroid;
shift1 = int16(center(1) - M/2);
shift2 =  int16(center(2) - N/2);% Shift necessary to center the image

V_shift = circshift(V_rot, [-shift2 -shift1]);%Real image centered

figure(5);
colormap('gray'), imagesc(V_shift), title('Brain rotated following the longitudinal fissure');

%%
% 2.1.9 How would you extend the method of detection of longitudinal fissure for a 
% 3D diffusion MRI image covering completeness of the brain ?

%Creating another loop for parsing the third dimension. Otherwise, the
%detection should less or more the same. 

%%
% 2.2.1 Create an image of each brain hemisphere: Hipsi and Hcontra

V_clean = V_shift.*int16(binary_mask(V_shift, 80));
figure(6), colormap('gray'), imagesc(V_clean);
title('Brain image centered and without artefacts');

[Hipsi, Hcontra, Hsymcontra] = partition(V_clean);
figure(7), colormap('gray')
subplot(1,3,1);imagesc(Hipsi);
subplot(1,3,2);imagesc(Hcontra);
subplot(1,3,3);imagesc(Hsymcontra);
title('From left to right: ipsilateral , contralateral and symmetrical of contralteral hemispheres');

%%
% 2.2.2 Rotate the Hcontra image horizontally around the median axis Am to get Hsymcontra image

% cf previous section (2.2.1)

%%
% 2.2.3 Automate the previous steps and propose a function that takes an image 2D diffusion MRI
% and returns the two corresponding Hipsi and Hsymcontra images.

%%
% 2.3.1 Are the parts of the brain on the Hipsi and Hsymcontra images well superposed?

prop_pix_common = similarity(Hipsi, Hsymcontra);

%%
% 2.3.2 Use the Hsymcontra image to normalize voxel to voxel the Hipsi image

normed_hem = normalization_hem(Hipsi, Hsymcontra);
figure(8), colormap('gray'), imagesc(normed_hem);title("Normalized ipsilateral hemisphere");

%%
% 2.3.3 What is the effect on artifacts? Are they eliminated?
% or exacerbated? Are poorly defined lesions better visible now? Would it be easier
% automatically cut the lesion after normalization?

% Artifacts not eliminated. Lesion is not very visible, yet it is the only
% part not hollow. Indeed, the brain is not perfectly symetric. Therefore,
% the inside of the brain is correctly removed, except for the lesion,
% while every contour can be seen on the normalized image. It makes a lot
% of artifacts, which canno't be removed with a method as simple as the one
% we used. 
%%
% 2.3.4 Apply a Gaussian blur to the Hsymcontra image before using for normalization of Hipsi.
% Does this improve the quality of standardization? What is the optimum value of sigma?

Gaussian_hsymcontra = imgaussfilt(Hsymcontra, 4);
gauss_normed_hem = normalization_hem(Hipsi, Gaussian_hsymcontra);
figure(9), colormap('gray'), imagesc(gauss_normed_hem);title("Normalized ipsilateral hemisphere using Gaussian blur on Hsymcontra");

% With a sigma too small, the lesion is not yet easy to distinguish from
% the contour residus. Yet, as we rise the value, the background becomes
% gray and lights up. We need it to stay with a different shade than the
% lesion, and we don't want the lesion to spread too much. The best
% compromise seems to be a sigma of 4. We still see the contours, however
% the lesion is clearly shown.

%%
% 2.3.5 When the lesion is not located in a single hemisphere, will that be a problem? An image
% where the lesion reaches both hemispheres is provided for discussion



%%
% Functions

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


function [A_fissure, fissure] = get_fissure(im, box, width)
    [~,N] = size(im);
    W = N/2;
    A_fissure = im;
    fissure = ones(box.BoundingBox(4),1)*N/2; % fissure vector
    for i=(box.BoundingBox(2)-0.5):(box.BoundingBox(2)+box.BoundingBox(4)-0.5)
        profile = A_fissure(i,int16(W-width*N):int16(W+width*N)); % grey value along the interval
        derivative = diff(profile); % Derivee de proche en proche du profil
        [~,Xmax] = max(derivative); % Get max of derivative
        [~,Xmin] = min(derivative); % Get min of derivative
        pos = uint8(W-width*N +Xmin + (Xmax - Xmin)/2); % Vector of X position for each y
        fissure(i,1) = pos; % keep the position in memory
        A_fissure(i, pos) = 255; % fissure line in white  
    end
end

function [Hipsi, Hcontra, Hsymcontra] = partition(im)
    [~,N]=size(im);
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
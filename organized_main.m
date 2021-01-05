% Choose brain image
V = B1;

% Display brain image
figure(1),subplot(1,2,1), colormap('gray');
imagesc(V);

%%
% 2.1.1 Create a binary mask of the brain.
maskV = binary_mask(V, 80);
subplot(1,2,2);imshow(maskV);

%%
% 2.1.2 Calculate the bounding ellipse of the brain
el = regionprops(maskV, {'Centroid', 'MajorAxisLength', 'MinorAxisLength', 'Orientation'});

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
        plot(x,y,'r','Linewidth',2);
        plot(Xc,Yc,'b','Linewidth',2);
    end

hold off

%%
% 2.1.3 Rotate the image to align the major axis of the ellipse with the vertical axis
[M,N] = size(V);
center = el(1).Centroid;
shift1 = int16(center(1) - M/2);
shift2 =  int16(center(2) - N/2);% Shift necessary to center the image
V_shift = circshift(maskV, [-shift2 -shift1]);
ellipse_test=regionprops(V_shift, {'Centroid', 'MajorAxisLength', 'MinorAxisLength', 'Orientation'});
e=ellipse_test(1).Centroid(2);
V = circshift(V, [shift1 shift2]);
figure(2);
subplot(1,2,1);imshow(V_shift); % Shift the center of the ellipse on the median vertical line of the image
angle1 = 90+el(1).Orientation;
V_rot = imrotate(V_shift, angle1); % Rotate the brain so that major axis of the ellipse aligns with the median line

V = imrotate(V,angle1);
[M2, N2] = size(V_rot);
if mod(N2,2)==1 
    N2 = N2-1;
    V_rot = V_rot(:, 1:N2);
end
V_line = V_rot;
V_line(:,int16(N2/2))=ones(M2,1)*255; % The brain should be centered 

subplot(1,2,2); imshow(V_line);

%%
% 2.1.4 Calculate the bounding box of the brain
BB = regionprops(maskV, 'BoundingBox'); % Returns x, y, w & h : position of the upper left corner and width and length of rectangle resp.
X_BB = round(BB.BoundingBox(1));
Y_BB = round(BB.BoundingBox(2));
Width_BB = BB.BoundingBox(3);
Height_BB = BB.BoundingBox(4);
figure(1),subplot(1,2,1);
rectangle('Position', [BB.BoundingBox(1), BB.BoundingBox(2), BB.BoundingBox(3), BB.BoundingBox(4)],'EdgeColor','r','LineWidth',2 )

%%
% 2.1.5 Draw the median vertical line D of the bounding box
lx = [(X_BB + Width_BB/2) (X_BB + Width_BB/2)];
ly = [Y_BB (Y_BB + Height_BB)];
Xpos_D = X_BB + Width_BB/2;
figure(1), subplot(1,2,1), line(x,y, 'Color','red','LineWidth',2); %Approximation not good

%%
% 2.1.6
% Using the position information of D and the profile of the gray level in the image along the lines horizontal, propose an
% automatic method to find line to line the position of the longitudinal fissure and give a map of uncertainty of its position

Xpos = zeros(Height_BB,1); % Position en x des points centraux du cerveau
dist_map = zeros(Height_BB,1); % Distance entre Ypos et Xpos_D
i = 1;

for y = Y_BB:(Y_BB + Height_BB)
    profile = V(X_BB : X_BB + Width_BB,y); % Creer le profil d'intensite
    derivative = diff(profile); % Derivee de proche en proche du profil
    [maxi,Xmax] = max(derivative); % Get max of derivative
    [mini,Xmin] = min(derivative); % Get min of derivative
    Xpos(i) = Xmin + (Xmax - Xmin)/2; % Vector of X position for each y
    dist_map(i) = abs(Xpos_D - Xpos(i)); % Vector of distances btw D & X pos
    i = i + 1;
end

%%
% 2.1.7
% Give the line (which we will call the median axis Am) which best approximates the longitudinal
% fissure. Does this line coincide with the line D?

%%
% 2.1.8 Rotate the image so that the center line Am is aligned with the vertical axis

%%
% 2.1.9 How would you extend the method of detection of longitudinal fissure for a 
% 3D diffusion MRI image covering completeness of the brain ?

%%
% 2.2.1 Create an image of each brain hemisphere: Hipsi and Hcontra
V_clean = V.*int16(binary_mask(V, 80));
figure(3), colormap('gray')
imagesc(V_clean);
[Hipsi, Hcontra, Hsymcontra] = partition(V_clean);
figure(4), colormap('gray')
subplot(1,3,1);imagesc(Hipsi);
subplot(1,3,2);imagesc(Hcontra);
subplot(1,3,3);imagesc(Hsymcontra);

%%
% 2.2.2 Rotate the Hcontra image horizontally around the median axis Am to get Hsymcontra image

% cf previous section (2.2.1)

%%
% 2.2.3 Automate the previous steps and propose a function that takes an image 2D diffusion MRI
% and returns the two corresponding Hipsi and Hsymcontra images.

%%
% 2.3.1 Are the parts of the brain on the Hipsi and Hsymcontra images well superposed?

% 2.3.2 Use the Hsymcontra image to normalize voxel to voxel the Hipsi image

%%
% 2.3.3 What is the effect on artifacts? Are they eliminated?
% or exacerbated? Are poorly defined lesions better visible now? Would it be easier
% automatically cut the lesion after normalization?

%%
% 2.3.4 Apply a Gaussian blur to the Hsymcontra image before using for normalization of Hipsi.
% Does this improve the quality of standardization? What is the optimum value of sigma?

%%
% 2.3.5 When the lesion is not located in a single hemisphere, will that be a problem? An image
% where the lesion reaches both hemispheres is provided for discussion

%%
% Functions


function [Hipsi, Hcontra, Hsymcontra] = partition(im)
    [M,N]=size(im);
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
V = niftiread('data/B1.nii');
subplot(1,2,1);
imagesc(V);
maskV = binary_mask(V, 80);
maskV = imrotate(maskV,90);
[M,N] = size(maskV);

propsV = regionprops(maskV, 'BoundingBox');
bbxV = vertcat(propsV.BoundingBox);
maskV = center_image(maskV);
el = regionprops(maskV, {'Centroid', 'MajorAxisLength', 'MinorAxisLength', 'Orientation'});

subplot(1,2,2); imshow(maskV);
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

    
   
     % shift the center of the ellipse on the median vertical line of the image
    

    
 %A_line = maskV;
 % % the median vertical line of the image is shown in white
    %imshow(A_line, [0 255]); title('Original rotated image with the median vertical axis of the image (white)');

    
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
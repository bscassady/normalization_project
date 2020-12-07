V = niftiread('data/B1.nii');
subplot(1,2,1);
imagesc(V);
maskV = binary_mask(V, 80);
subplot(1,2,2); imagesc(maskV);
propsV = regionprops(maskV, 'BoundingBox');
bbxV = vertcat(propsV.BoundingBox);
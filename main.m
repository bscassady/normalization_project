V = niftiread('data/B1.nii');
subplot(1,2,1);
imagesc(V);
maskV = binary_mask(V, 80);
subplot(1,2,2); imagesc(maskV);
st = regionprops(maskV, 'BoundingBox');
rectangle('Position', [st.BoundingBox(1), st.BoundingBox(2), st.BoundingBox(3), st.BoundingBox(4)],'EdgeColor','r','LineWidth',2 )

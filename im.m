% Read all data with rotation

A1 = imrotate(niftiread('data/A1.nii'),90);
A1mask = imrotate(niftiread('data/A1mask.nii'),90);
A2 = imrotate(niftiread('data/A2.nii'),90);
A2mask = imrotate(niftiread('data/A2mask.nii'),90);
A3 = imrotate(niftiread('data/A3.nii'),90);
A3mask = imrotate(niftiread('data/A3mask.nii'),90);

B1 = imrotate(niftiread('data/B1.nii'),90);
B1mask = imrotate(niftiread('data/B1mask.nii'),90);
B2 = imrotate(niftiread('data/B2.nii'),90);
B2mask = imrotate(niftiread('data/B2mask.nii'),90);
B3 = imrotate(niftiread('data/B3.nii'),90);
B3mask = imrotate(niftiread('data/B3mask.nii'),90);

C1 = imrotate(niftiread('data/C1.nii'),90);
C1mask = imrotate(niftiread('data/C1mask.nii'),90);
C2 = imrotate(niftiread('data/C2.nii'),90);
C2mask = imrotate(niftiread('data/C2mask.nii'),90);
C3 = imrotate(niftiread('data/C3.nii'),90);
C3mask = imrotate(niftiread('data/C3mask.nii'),90);

D1 = imrotate(niftiread('data/D1.nii'),90);
D1mask = imrotate(niftiread('data/D1mask.nii'),90);
D2 = imrotate(niftiread('data/D2.nii'),90);
D2mask = imrotate(niftiread('data/D2mask.nii'),90);
D3 = imrotate(niftiread('data/D3.nii'),90);
D3mask = imrotate(niftiread('data/D3mask.nii'),90);

E1 = imrotate(niftiread('data/E1.nii'),90);

E2mask = imrotate(niftiread('data/E2mask.nii'),90);
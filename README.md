# normalization_project
This folder includes a Matlab program that aims at developing an automatic method for normalising diffusion MRI with the contralateral brain region based on its symmetry properties. 

# Motivation
The obstruction of an artery in the brain can cause an ischemic stroke. When this happens, clincians use diffusion magnetic resonance imaging (MRI) to find which area has been affected. Compared to the symetric hemisphere, the lesion area will appear in hyperintensity.

Our project is to use the symetrical nature of the brain to reveal automatically the lesion area, by first standardizing the images. Therefore, it would be possible to compare the wounds between different patients. 

# Code workflow
The code is contained in the file main.m. However, it is necessary to compile the file im.m and change the MATLAB path accordingly beforehand. 
## The file im.m
This file is merely a catalog for managing all the images and save them in the coding environment. It uses the niftiread method, mandatory as the files are binary images, thus impossible to manage using directly the imread method.

## The main.m file
The code is built strictly following the questions of the subject. Nonetheless, all the steps are detailled below.
### Orienting the brain 
The data used is acquired from real life RMI scans, it is thus impossible to obtain reproducible perfectly horizontal or vertical brain images. A method had to be written in order to adapt. After creating a binary mask with th ad-hoc method, we calculated a bonding ellipse of the brain using the built in regionprops method. The image is then rotated in order to align ellipse major axis and vertical axis. 
Even though this method is a good approximation for getting the brain oriented properly, it is not as good for detecting the brain fissure : the shapes of the brains are too diverse, the ellipse bounds the brain but does not really take into account its symmetry. 

### Detecting the longitudinal axis of symmetry of the brain

As said in the introduction, the goal of this project is to normalize the image of the wounded hemisphere of the brain in order to detect the lesion. To do so, one must first find a way to part the hemispheres properly. 

#### The bounding box

We created a bounding box around the brain image thanks to regionprops and drew a vertical line cutting through the middle of it, for this line should approximate the axis of symmetry of the brain. Even though results show that this approximation is better than the previous one, there is still plenty of room for improvement in terms of fitting brain images that would not be perfectly symmetric or aligned. 

#### Detecting the fissure by differenciating intensity profiles

The best method was to extract horizontal intensity profiles, differenciate them and extract the position of the middle point between the maximum and the minimum of the derivative. This point corresponds to the middle of the darker area in the intensity profile, in other words, the fissure.
We don't expect this series of point to draw a straight line on the image, so the longitudinal fissure is then approximated using a linear regression. We then use it to rotate and shift the brain in order to get it centered and as vertical as possible for the next step. 
To go further, a 3D partition would be possible by stacking horizontal images (slices or brain if you will) and adding a loop to the method. We would thus obtain a cutting plane. 

### Partition and normalization

#### Partition
Once the image is centered and rotated, we use a method to detect the ipsilateral and contralateral hemispheres. First, the image is filtered by its binary mask in order to cancel any noise or artifacts created by previous preprocessing or natively in the image. Then, ce create two images cutting through the medium vertical axis and compute the average intensity of both hemispheres. The ipsilateral should have a higher mean. A symmetrical of the contralateral hemisphere is then created for the normalization (Hsymcontra). 

#### Normalization

In order to determine the consistance of our work, we wrote a method in order to rate the superposition of Hipsi and Hsymcontra. Arbitrarily, we can consider a correct superposition with a similarity of 75%.
Then, the ipsilateral hemisphere is normalized by a simple substraction of the Hsymcontra image first and then by Hsymcontra with the application of a Gaussian blur. This option allows to enhance the contrast and to detect more easily the region affected by ischemic stroke. 

# Methods 

## binary_mask
This methods takes an image and an intensity threshold as inputs and outputs a binary mask with pixels activated if they had an intensity grater than the threshold. 
## get_fissure
This method takes an image, a bounding box and a size as an input. It then extracts an intensity profile of the given size horizontally in the threshold, differenctiate it in order to identify the point of the fissure at this vertical coordinate. The method returns a vector or positions for the fissure in the bounding box and the image with the pixels of the fissure in full intensity.
## partition
This method takes an image as an input and returns the Hipsi, Hcontra and Hsymcontra. It splits the image in two following the medium vertical axis and determine which sub image is which by computing the average intensity. 
## similarity
This method takes two binary masks as inputs and outputs the proportion of common pixels between them.
## normalization_hem
This method takes Hipsi and Hsymcontra as inputs and outputs a normalized Hipsi by subtraction of the Hsymcontra. 
# Tests

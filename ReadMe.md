# Underwater Image Color Corrector

This repository contains MATLAB scripts that correct the color of underwater images, designed to restore true-to-life colors and improve visual clarity. Due to light absorption and scattering, underwater images often suffer from color distortion, with colors such as red and orange diminishing as depth increases. This project addresses these challenges by implementing efficient algorithms to enhance color accuracy and restore the natural vibrancy of underwater scenes.

Authors: Aaron Yangello (ayangello@gmail.com), Singyan Yuen (yuens7@students.rowan.edu)
	*NOTE: This project was created using MATLAB R2017b with the image processing toolbox (https://www.mathworks.com/products/image-processing-toolbox.html)

To run this project, follow the steps detailed below:
	1. Open Underwater_Demo.m
	2. Change the 'projectPath' variable in the "House Keeping" section to match the 'Project' folder in which the 'Scripts' and 'InputRaw' folders exist.
	3. Run the "House Keeping section (Note that this must be done before proceding to steps 4 or 5).
	4. To see the results of this algorithm on all of the images in the 'InputRaw' folder, run the first section, titled "Multiple Image Demo"
		a. This process should take about 30 seconds to 1 min.
		b. The result of this process should be 11 image comparisons in 3 different figures.
	5. To see the results of just one image, simply run the section titled "One Image at a Time" 
		a. This process should take only 5 to 10 seconds
		b. The result of this process should be 7 figures, explained below
			i.   Red Channel Compensation Comparison: The intermediate steps in the White Balancing Process
			ii.  Gamma Corrected Weight Maps: The Laplacian, Saliency, and Saturation weight maps used to derive the weight map used for the fusion of the Gamma Corrected input
			iii. Sharpened Weight Maps: The Laplacian, Saliency, and Saturation weight maps used to derive the weight map used for the fusion of the Sharpened input
			iv.  Gaussian and Laplacian Pyramid Levels: The levels of decomposition of the gaussian and laplacian pyramids for each weight map and input image used in the fusion process
			v.   Multi-Scale Fusion: The intermediate steps in the Multi-Scale Fusion Process.
			vi.  Image Progression: A high level comparison of the raw input image, white balanced image, and final output image
			vii. Matlab vs. Ancuti et al.: A visual comparison between the suggested Matlab white balancing process and the one described by Ancuti et al.
		c. To avoid the intermediate step figures (i.e. i-v), set the third parameter in both the Underwater_WhiteBalance and Underwater_MultiScaleFusion functions to false.
		d. To change the input image, perform the following
			i.   Change the imread parameter to that of the image name you wish to see (examples can be found in the 'InputRaw' folder).
			ii.  For accurate Matlab vs. Ancuti et al. comparison, use imtool to find a pixel that should be white, and set the x and y variable values to that of the pixel.
	6. To run the entire script, simply click run.
Chess Vision: Chess Position Recogition using Computer Vision Techniques and a CNN
==================================================================================
**Authors:** Toby Frick and William Chapin

We implement several computer vision techniques in MatLab to recognize the postion of a chess board given only an RGB image of that board. 
Final Report.pdf is a paper that we wrote that explains the development process in more depth. If you'd like to use our system yourself, see instructions below.

# References:

This Project was developed in collaboration with William Chapin under the guidance of Professor Jerod Weinman in Grinnell College's CSC-262 Computer Vision Class.
Inspiration for this project and the training dataset for our CNN comes from Andrew Underwood's project [here](https://towardsdatascience.com/board-game-image-recognition-using-neural-networks-116fc876dafa).

Math inspiring our image homography implementation by David Kriegman [here](https://cseweb.ucsd.edu//classes/wi07/cse252a/homography_estimation/homography_estimation.pdf).

# How to Run:

All images work on our system to varying degrees of success and you can use these images yourself if you want to use our project, but don't have any chess board images yourself.

**To run chess.m script:**

 All files aside from the pdf must be in the same directory for the script to work. 
 The script which uses all other files and functions (except the pdf of course) is 
 named chess.m. Run this file to generate the statistics regarding all of our test
 images.


**To run the script on an image of your choice:**

**Note:** This system requires specifically oriented images. If you want to use your own images, try to use a chess board and set that look as similar as possible to the ones seen in the sample images and place the board on a dark surface. Black surfaces work best.

 1. load your image to the matlab workspace using the imread() function.

 2. use this image as input to the getHomography function like so and set a
 threshhold depending on the darkness of the background of your image (for
 best results, use a black background and a threshold value of .4).

 3. Use these outputs and your image as inputs to the getImgSlices function
 like so.

 4. For the last step, you must load in the pretrained neural network like so
 and use it as input for the classifySlices function.
 
 **In Code:**
 
 img = imread(YOUR IMAGE FILE PATH HERE);
 
 [H, means, stds] = getHomography(img, .4);
 
 slices = getImgSlices(img, H, means, stds);
   
 load('network.mat');
 
 classifiedBoard = classifySlices(slices, trained_network1);

 You now have a classified chess board corresponding to the board you used
 as input!
 
 **Thank you for looking into our project! We're very proud of what we've accomplished and hope you enjoy it too.**

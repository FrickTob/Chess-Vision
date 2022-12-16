
% Instructions for how to run script:

% All files aside from the pdf must be in the same directory for the script to work. 
% The script which uses all other files and functions (except the pdf of course) is 
% named chess.m. Run this file to generate the statistics regarding all of our test
% images.
%

% To run the script on an image of your choice, do the following:

% load your image to the matlab workspace using the imread() function like
% so

% img = imread(YOUR IMAGE FILE PATH HERE);

% use this image as input to the getHomography function like so and set a
% threshhold depending on the darkness of the background of your image (for
% best results, use a black background and a threshold value of .4).

% [H, means, stds] = getHomography(img, .4);

% Use these outputs and your image as inputs to the getImgSlices function
% like so

% slices = getImgSlices(img, H, means, stds);

% For the last step, you must load in the pretrained neural network like so
% and use it as input for the classifySlices function

% load('network.mat');
% classifiedBoard = classifySlices(slices, trained_network1);

% You now have a classified chess board corresponding to the board you used
% as input.
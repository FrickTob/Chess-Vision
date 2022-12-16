% This script is used to generate statistics regarding the efficacy of our
% Chess Board Position Identification Process

% Generate Stats for Given Boards

% Load Board
for k = 1:7
board = imread(strcat('board',int2str(k),'.jpeg'));

% Calculate Board Homography with black background (threshold = .4)
[H, means, stds] = getHomography(board, .4);

% Extract Board Slices
[slices] = getImgSlices(board, H, means, stds);

% Load cnn and classify slices
load('network.mat');
[classGrid] = classifySlices(slices, trainedNetwork_1);
boards(:,:,k) = classGrid;
end
close all
load('trueBoards.mat');
diffGB = (boards == truths);

avgGB = mean(diffGB(:));
avgEachSquareGB = mean(diffGB, 3);
avgEachRowGB = mean(diffGB,2);
avgEachRowGB = mean(avgEachRowGB,3);
types = {'bk', 'bq', 'br', 'bb', 'bn', 'bp', 'empty', 'wk', 'wq', 'wr', 'wb', 'wn', 'wp'};
% types = categorical(types);

avgEachTypeGB = zeros(13, 1);
FPEachType = zeros(13, 1);

for i = 1:13
    hold = find(truths == types{i});
    avgEachTypeGB(i) = mean(diffGB(hold), 'all');
    hold = find(boards == types{i});
    FPEachTypeGB(i) = 1 - mean(diffGB(hold), 'all');
end

% Generate Stats for Images of Boards Taken Ourselves

% Load Board
for k = 1:5
board = imread(strcat('ourBoard',int2str(k),'.jpg'));

% Calculate Board Homography with brown background (threshold = .6)
[H, means, stds] = getHomography(board, .6);

% Extract Board Slices
[slices] = getImgSlices(board, H, means, stds);

% Load cnn and classify slices
load('network.mat');
[classGrid] = classifySlices(slices, trainedNetwork_1);
ourBoards(:,:,k) = classGrid;
end
close all
load('ourTruths.mat');
diffOB = (ourBoards == ourTruths);

avgOB = mean(diffOB(:));
avgEachSquareOB = mean(diffOB, 3);
avgEachRowOB = mean(diffOB,2);
avgEachRowOB = mean(avgEachRowOB,3);
types = {'bk', 'bq', 'br', 'bb', 'bn', 'bp', 'empty', 'wk', 'wq', 'wr', 'wb', 'wn', 'wp'};
% types = categorical(types);

avgEachType = zeros(13, 1);
FPEachType = zeros(13, 1);

for i = 1:13
    hold = find(ourTruths == types{i});
    avgEachTypeOB(i) = mean(diffOB(hold), 'all');
    hold = find(ourBoards == types{i});
    FPEachTypeOB(i) = 1 - mean(diffOB(hold), 'all');
end
FPEachTypeOB = FPEachTypeOB';

% Generate Stats from Two Different Camera Orientations

% Load Board
for k = 1:2
board = imread(strcat('topView',int2str(k),'.jpg'));

% Calculate Board Homography with brown background (threshold = .6)
[H, means, stds] = getHomography(board, .6);

% Extract Board Slices
[slices] = getImgSlices(board, H, means, stds);

% Load cnn and classify slices
load('network.mat');
[classGrid] = classifySlices(slices, trainedNetwork_1);
ourStarts(:,:,k) = classGrid;
end
close all
trueStarts(:,:,1) = ourTruths(:,:,1);
trueStarts(:,:,2) = ourTruths(:,:,1);
diffTV = (ourStarts == trueStarts);

avgLowAngle = mean(diffTV(:,:,1), 'all');
avgHiAngle = mean(diffTV(:,:,2), 'all');

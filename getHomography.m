function [H, means, stds] = getHomography(chessBoard, threshold)
% Produces - getHomography generates a homography matrix and the necessary 
% means and standard deviations in order to whiten data in getImgSlices
% Purpose - First Step in Chess Board Positon Identification. Used to 
% generate the inputs for getImgSlices
% Preconditions - an RGB image of a chessBoard taken from the perspective 
% of the player of the white pieces on a dark background with all four 
% corners of the chess board clearly visible.  Typical Threshhold is .4
% NOTE: Threshhold must be adjusted for use on images without a black background
% Postconditions - if the image does not satisfy necessary consitions, H will be unusable for use in getImgSlices function.

% Convert board to logical for better filter responses
colorBoard = chessBoard;
chessBoard = im2double(im2gray(chessBoard));
dataBoard = chessBoard;
dataBoard(dataBoard >= threshold) = 1;
dataBoard(dataBoard < threshold) = 0;

% Create Mental Board (Displayed in Fig 1)
bw = [zeros(16), ones(16)];
wb = [ones(16), zeros(16)];
bwrow = [bw, bw, bw, bw];
wbrow = [wb,wb,wb,wb];
mentalBoard = [wbrow;bwrow;wbrow;bwrow;wbrow;bwrow;wbrow;bwrow];
border = zeros(128,1);
border = border +.5;
mentalBoard = [border, mentalBoard, border];
border = zeros(1, 130);
border = border + .5;
mentalBoard = [border;mentalBoard;border];

% Create Corner Filters (Displayed in Fig 2)
bottomLeftFilter = [ones(32), zeros(32);
                ones(32), ones(32)];
bottomLeftFilter = 2 * bottomLeftFilter - 1;

topRightFilter = [ones(16), ones(16);
                    zeros(16), ones(16)];
topRightFilter = 2 * topRightFilter - 1;

bottomRightFilter = ones(33);
bottomRightFilter(1:17, 16:18) = 0;
bottomRightFilter(16:18, 1:17) = 0;
bottomRightFilter = 2 * bottomRightFilter - 1;

topLeftFilter = ones(33);
topLeftFilter(17:end, 16:18) = 0;
topLeftFilter(16:18,17:end) = 0;
topLeftFilter= 2 * topLeftFilter - 1;

% Detect bottom left corner of board
cornerDetection = filter2(bottomLeftFilter, dataBoard);
cornerDetection(cornerDetection < .95*max(cornerDetection(:))) = 0;
cornerDetection(cornerDetection > 0) = 1;
[row, col] = find(cornerDetection);
bottomLeftPoint = [col(1), row(1)];

% Detect top right corner of board
cornerDetection = filter2(topRightFilter, dataBoard);
cornerDetection(cornerDetection < .95*max(cornerDetection(:))) = 0;
cornerDetection(cornerDetection > 0) = 1;
[row, col] = find(cornerDetection);
colMinusRow = col - row;
[~, topRightPointIndex] = max(colMinusRow);
topRightPoint = [col(topRightPointIndex), row(topRightPointIndex)];

% Detect top left corner of board
cornerDetection = filter2(topLeftFilter, dataBoard);
cornerDetection(cornerDetection < .95*max(cornerDetection(:))) = 0;
cornerDetection(cornerDetection > 0) = 1;
[row, col] = find(cornerDetection);
colPlusRow = col + row;
[~, topLeftPointIndex] = min(colPlusRow);
topLeftPoint = [col(topLeftPointIndex), row(topLeftPointIndex)];

% Detect bottom right corner of board
cornerDetection = filter2(bottomRightFilter, dataBoard);
cornerDetection(cornerDetection < .95*max(cornerDetection(:))) = 0;
cornerDetection(cornerDetection > 0) = 1;
[row, col] = find(cornerDetection);
colPlusRow = col + row;
[~, bottomRightPointIndex] = max(colPlusRow);
bottomRightPoint = [col(bottomRightPointIndex), row(bottomRightPointIndex)];

% Organize corner points in mental board and board image
mentalxCoords = [2,129,2,129];
mentalyCoords = [2,2,129,129];
boardxCoords = [topLeftPoint(1), topRightPoint(1), bottomLeftPoint(1), bottomRightPoint(1)];
boardyCoords = [topLeftPoint(2), topRightPoint(2), bottomLeftPoint(2), bottomRightPoint(2)];
% Show input corners on mental board
figure;
imshow(mentalBoard);
hold on;
plot(mentalxCoords, mentalyCoords, 'r+', 'linewidth', 2);
hold off;
% Show Identified Corners (Displayed in Fig 3 using board1.jpeg)
figure;
imshow(colorBoard);
hold on;
plot(boardxCoords, boardyCoords, 'r+', 'linewidth', 2);
hold off;

% Create and whiten data to generate H
dataMatrix = [mentalxCoords;mentalyCoords;boardxCoords;boardyCoords];
means = mean(dataMatrix,2);
wData = dataMatrix - means;
stds = std(wData, 0, 2);
wData = wData ./ stds;

% Generate a_x and a_y to create A
zeroCol = zeros(4,1);
oneCol = ones(4,1);
%          x1     ,    y1      ,   1   ,     0  ,  0     ,    0   ,     x1      *    x2       ,    y1        *  x2       ,      x2   
a_x = [wData(1,:)', wData(2,:)', oneCol, zeroCol, zeroCol, zeroCol, -1 * wData(1,:)' .* wData(3,:)', -1 * wData(2,:)' .* wData(3,:)',  -1 * wData(3,:)'];
%         0   ,     0  ,    0   ,   x1       ,   y1       ,  1    ,  x1          .*    y2          y1        .*   y2      ,    y2
a_y = [zeroCol, zeroCol, zeroCol, wData(1,:)', wData(2,:)', oneCol, -1 * wData(1,:)' .* wData(4,:)', -1 * wData(2,:)' .* wData(4,:)', -1 * wData(4,:)'];

% Form A
j = 1;
for k = 1:2:8
    A(k,:) = a_x(j, :);
    A(k+1,:) = a_y(j,:);
    j = j + 1;
end

% Find H
[~, ~, V] = svd(A);
h = V(:,end);
H = reshape(h, 3, 3);

end


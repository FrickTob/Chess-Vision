function [myCells] = getImgSlices(img, H, means, stds)
% Produces - generates a 64 element cell of image slices cropped at each 
% square in the chess board img
% Purpose - used to extract images representing chess squares for 
% classification in classifySlices
% Preconditions - img must be the same image used to generate H, means and 
% stds in getHomography
% Postconditions -if img is not the same as the image used to generate H, 
% myCells will be unusable

% Convert rgb image to gray double and generate homography matrix
chessBoard = im2double(rgb2gray(img));

% Generate points representing a square in the mental board
smallSquare = [50, 50, 66, 66;50, 66, 66, 50;1, 1, 1, 1];
inputPoints = smallSquare;
inputPoints1 = inputPoints;

% Generate all corner points in the mental board
allPoints = zeros(9, 9, 2);
for i = 0:8
    y = 2+i*16;
    for j = 0:8
       x = 2+j*16;
       allPoints(i+1, j+1, :) = [x, y];
    end
end
%  Use H to find all corners in img and extract each square
%  format is (row, column, component)
AllSlices = zeros(8, 8, 500, 500, 3);
myCells = cell(64, 1);
grayBoard = im2gray(chessBoard);
for a = 0:7
    for b = 0:7
        extractedSquare = allPoints(a+1:a+2, b+1:b+2, :);
        xSlice = extractedSquare(:,:, 1);
        ySlice = extractedSquare(:,:, 2);
%         xSlice(:,1) = xSlice(:,1) + 1; % + quarter square border
%         xSlice(:,2) = xSlice(:,2) - 1; % + quarter square border

        ySlice(1, :) = ySlice(1, :) - 8; % + square border
        ySlice(2, :) = ySlice(2, :) + 2; % + half square border

        inputPoints = [xSlice(:)'; ySlice(:)'; 1, 1, 1, 1]; % Make this square the in

        % Whiten inputs to prepare to send through H.
        inputPoints(1:2,:) = inputPoints(1:2,:) - means(1:2);
        inputPoints(1:2,:) = inputPoints(1:2,:) ./ stds(1:2);

        % Send through H
        outputPoints = H * inputPoints;

        % Normalize inhomogenous coords (divide x and y by z as we chose z = 1)
        outputPoints = outputPoints ./ outputPoints(3,:);

        % Reverse Whitening
        outputPoints(1:2,:) = outputPoints(1:2,:) .* stds(3:4);
        outputPoints(1:2,:) = outputPoints(1:2,:) + means(3:4);

        %Convert output to useable indices, aka in bound integers
        minOut = min(outputPoints, [], 2);
        minOut = floor(minOut);
        maxOut = max(outputPoints, [], 2);
        maxOut = floor(maxOut);
        minOut(minOut<1) = 1;
        maxOut(maxOut<1) = 1;
        minOut(1) = min(minOut(1), size(chessBoard, 2));
        minOut(2) = min(minOut(2), size(chessBoard, 1));
        maxOut(1) = min(maxOut(1), size(chessBoard, 2));
        maxOut(2) = min(maxOut(2), size(chessBoard, 1));

        %Save Image Region
        difOut = maxOut-minOut;
        imageSlice = zeros(difOut(1), difOut(2), 3);
        imageSlice = img(minOut(2):maxOut(2), minOut(1):maxOut(1), :);
        myCells{(a*8) + (b+1)} = imageSlice;
        AllSlices(a+1, b+1, 1:size(imageSlice, 1), 1:size(imageSlice, 2), 1:3) = imageSlice;
    end
end

% % Whiten inputs to prepare to send through H.
% inputPoints1(1:2,:) = inputPoints1(1:2,:) - means(1:2);
% inputPoints1(1:2,:) = inputPoints1(1:2,:) ./ stds(1:2);
% 
% % Send through H
% outputPoints = H * inputPoints1;
% 
% % Normalize inhomogenous coords (divide x and y by z as we chose z = 1)
% outputPoints = outputPoints ./ outputPoints(3,:);
% 
% % Reverse Whitening
% outputPoints(1:2,:) = outputPoints(1:2,:) .* stds(3:4);
% outputPoints(1:2,:) = outputPoints(1:2,:) + means(3:4);
% 
% 
% % Plot Results (Generates Fig 4)
% pause(.1);
% figure, imshow(mentalBoard), hold on;
% plot(inputPoints1(1,1), inputPoints1(2,1), 'm+');
% plot(inputPoints1(1,2), inputPoints1(2,2), 'c+');
% plot(inputPoints1(1,3), inputPoints1(2,3), 'y+');
% plot(inputPoints1(1,4), inputPoints1(2,4), 'g+');
% hold off;
% % saveas(1, 'InputTruth.jpg');
% pause(.1);
% figure, imshow(chessBoard), hold on;
% plot(outputPoints(1,1), outputPoints(2,1), 'm+', 'LineWidth', 2);
% plot(outputPoints(1,2), outputPoints(2,2), 'c+', 'LineWidth', 2);
% plot(outputPoints(1,3), outputPoints(2,3), 'y+', 'LineWidth', 2);
% plot(outputPoints(1,4), outputPoints(2,4), 'g+', 'LineWidth', 2);
% hold off;
% saveas(2, 'OutputEstimated.jpg');
end

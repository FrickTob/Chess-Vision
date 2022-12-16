function [classGrid] = classifySlices(slices, net)
% Produces - Produces an 8x8 grid of image classifications corresponding to
% the squares of the chessBoard used to generate slices
% Purpose - This function is the last step in chess position identification
% which outputs the identified position
% Preconditions - net must be a CNN trained to identify chess pieces we use 
% our own trained network for the accompanying script
% Postconditions - net is not sufficiently trained or slices is not 
% obtained from a valid use of getImgSlices, results will be unusable

% Display The Network
%figure;
%plot(net);

for k = 1:64
    currImg = slices{k};
   sliceVec(:,:,:,k) = imresize(currImg, [227 227]);
end
   classes = classify(net, sliceVec);
   classGrid = reshape(classes, [8 8])';
end


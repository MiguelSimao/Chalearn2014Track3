function output = funReduceToArms( self )
%REDUCETOARMS This function reduces the nodes to the elbow and arm nodes.
%The shoulder joint position is also subtracted from the arm's joints.
%
% LEFT SIDE:
% ShoulderLeft = 5
% ElbowLeft = 6
% WristLeft = 7
% HandLeft = 8
%
% RIGHT SIDE:
% ShoulderRight = 9;
% 10
% 11
% 12

input = self.outputNodes;

leftPos = input(:,5);
rightPos = input(:,9);

leftPos = repmat(leftPos,1,3);
rightPos = repmat(rightPos,1,3);

input(:,[6 7 8]) = cellfun(@minus,input(:,[6 7 8]),leftPos,'UniformOutput',false);
input(:,[10 11 12]) = cellfun(@minus,input(:,[10 11 12]),rightPos,'UniformOutput',false);

input(:,[1:5 9 13:size(input,2)]) = cellfun(@(x)times(x,0),input(:,[1:5 9 13:size(input,2)]),'UniformOutput',false);

output = input;
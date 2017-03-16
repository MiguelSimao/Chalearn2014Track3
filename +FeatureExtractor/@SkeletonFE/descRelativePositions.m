function output = descRelativePositions( self )
%FUNRELATIVEPOSITIONS Calculates RELATIVE POSITIONS of a set of nodes.
%   Calculates the relative positions between joins according to what was
%   proposed in (Luvizon, 2017) in PR Letters.
%
%   INPUTS:
%       - self: SkeletonFE object
%   OUTPUTS:
%       - output: transformed skeleton nodes
%
% 
% Here is the order of joints returned by Kinect for Windows
%     HipCenter = 1;
%     Spine = 2;
%     ShoulderCenter = 3;
%     Head = 4;
%     ShoulderLeft = 5;
%     ElbowLeft = 6;
%     WristLeft = 7;
%     HandLeft = 8;
%     ShoulderRight = 9;
%     ElbowRight = 10;
%     WristRight = 11;
%     HandRight = 12;
%     HipLeft = 13;
%     KneeLeft = 14;
%     AnkleLeft = 15;
%     FootLeft = 16; 
%     HipRight = 17;
%     KneeRight = 18;
%     AnkleRight = 19;
%     FootRight = 20;
%
% (Luvizon, 2017) proposes the following relative positions:
%
% |    Subgroup of joints (i)   | Relative to (k)
% | Head, l. hand, and r. hand  |  Spine
% | Head, l. hand, and l. foot  |  R. hip
% | Head, r. hand, and r. foot  |  L. hip
% | L. hand and r. hand         |  Head
%
% |    Subgroup of joints (i)   | Relative to (k)
% | 4,  8, 12                   |   2
% | 4,  8, 16                   |  17
% | 4, 12, 20                   |  13
% | 8, 12                       |   4
%
% Equation (2):
% w(i,k) = p(i) - p(k)
%

inputNodes = self.outputNodes;

w = [ 4  2;
      8  2;
     12  2;
      4 17;
      8 17;
     16 17;
      4 13;
     12 13;
     20 12;
      8  4;
     12  4];


output = cell(size(inputNodes,1),size(w,1));

for i=1:size(w,1)
    % output{:,i} = P(i) - P(k);
    output(:,i) = cellfun(@minus,inputNodes(:,w(i,1)),inputNodes(:,w(i,2)),'UniformOutput',false);
end
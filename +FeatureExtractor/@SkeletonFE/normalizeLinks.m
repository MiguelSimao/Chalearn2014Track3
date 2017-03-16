function output = normalizeLinks( self )
%NORMALIZELINKS Summary of this function goes here
%   Detailed explanation goes here

SkeletonConnectionMap  =   [[1  2];  %Spine
                            [2  3];
                            [3  4];
                            [3  5];  %Left Hand
                            [5  6];
                            [6  7];
                            [7  8];
                            [3  9];  %Right Hand
                            [9  10];
                            [10 11];
                            [11 12];
                            [1  17]; %Right Leg
                            [17 18];
                            [18 19];
                            [19 20];
                            [1  13]; %Left Leg
                            [13 14];
                            [14 15];
                            [15 16]];



input = self.outputNodes;
meanLinkLen = self.meanLinkLen;

% We only want to normalize the upperbody links.
meanLinkLenAll = ones(size(SkeletonConnectionMap,1),1);
meanLinkLenAll([1:12 16]) = meanLinkLen;

for i=1:size(input,1)
   % for each timestep
    for j=1:size(SkeletonConnectionMap,1)
        %for each connection
        i1 = SkeletonConnectionMap(j,1); % p(i-1)
        i2 = SkeletonConnectionMap(j,2); % p(i)
        v = minus(input{i,i2},input{i,i1});

        input{i,i2} = input{i,i1} + v / norm(v) * meanLinkLenAll(j); 
        input{i,i2}(isnan(input{i,i2})) = 0;
    end
end
output = input;
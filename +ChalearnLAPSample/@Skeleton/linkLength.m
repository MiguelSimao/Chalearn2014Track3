function output = linkLength( self )
%LINKLENGTH Summary of this function goes here
%   Detailed explanation goes here
L = length(self(1).SkeletonConnectionMap);
N = length(self);

pts = zeros(L,6,N);
for j=1:N
for i=1:L
    pts(i,1:3,j) = self.getWorldCoordinates.(self.SkeletonConnectionMap{i,1});
    pts(i,4:6,j) = self.getWorldCoordinates.(self.SkeletonConnectionMap{i,2});
end
end

output = pts(:,1:3) - pts(:,4:6);
output = sqrt( sum(output .^ 2,2) );

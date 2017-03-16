function vec = descPositions( nodeData, selectedNodes )
%DESCPOSITIONS Simply extracts a subset of nodes. Also concatenates
%selectedNodes in one single vector.

% nodeData is a N x M cell array
% selectedNodes is a m x 1 double array (m subset of M)

nodeData = nodeData(:,selectedNodes);

vec = cell2mat(nodeData);
vec = mat2cell(vec,ones(size(vec,1),1),size(vec,2));
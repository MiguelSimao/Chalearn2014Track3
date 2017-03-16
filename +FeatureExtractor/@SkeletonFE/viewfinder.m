function coef = viewfinder( self )
%VIEWFINDER Summary of this function goes here
%   Detailed explanation goes here

nodes = self.skeletonNodes;

% make each row of the cell array into a single cell:
tsCells = self.skel2cell(nodes);

tsCells = cell2mat(tsCells);

coef = pca(tsCells,'Centered','off');
coef = {coef};
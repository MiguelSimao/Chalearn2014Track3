function Y = getCentreTorso(self)
% This function should output a structure with only the nodes
% concerning the trunk of the body.

ssInd = ismember(self.nodesList,self.torsoNodes);
%ss = self.skeletonNodes(:,ssInd);
ss = self.outputNodes(:,ssInd);

Nts = length(ss); %number of timesteps

ss = cellfun(@transpose,ss,'UniformOutput',false);
% each cell is now a vertical vector
ss = cell2mat(ss);
% concatenated values from every cell. each 3 rows is a point
ss = mat2cell(ss,repmat(3,Nts,1),size(ss,2));
% one column cell, each row is a timestep
ss = cellfun(@transpose,ss,'UniformOutput',false);
% each cell has now points as row
Y = cellfun(@(x)self.weightedCentroid(x,[2 1 1 2 2 1 1]),ss,'UniformOutput',false);

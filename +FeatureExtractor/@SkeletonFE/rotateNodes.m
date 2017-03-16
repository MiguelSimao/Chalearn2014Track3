function output = rotateNodes( self )
%ROTATENODES Summary of this function goes here
%   Detailed explanation goes here

% Some function definitions:
ts2mat = @(C)cell2mat(C');
fitFcn = @(X)FeatureExtractor.common.fitPlane(X);

inputNodes = self.outputNodes;

% Nodes to be fitted are only the centre nodes!!!
fitNodes = inputNodes(:,ismember(self.nodesList,self.torsoNodes));

% make each row of the cell array into a single cell:
tsCells = self.skel2cell(fitNodes);

% calculate fit
fitStruct = cellfun(fitFcn,tsCells);

% get fit coefs
fitCell = struct2cell(fitStruct)';
coefs = fitCell(:,2);
%scores = fitCell(:,3);


% make each row of the cell array into a single cell:
allRowCells = mat2cell(inputNodes,ones(size(inputNodes,1),1),size(inputNodes,2));
% get nodes for each timestep as cell:
alltsCells = cellfun(ts2mat,allRowCells,'UniformOutput',false);
% y = x/w'
scores = cellfun(@mrdivide,alltsCells,coefs,'UniformOutput',false);

%rotatedNodes = cellfun(@(x,y)mtimes(x(:,1:2),y(:,1:2)'),scores,coefs,'UniformOutput',false);
rotatedNodes = cellfun(@(x,y)mrdivide(x(:,1:3),y(:,1:3)'),scores,coefs,'UniformOutput',false);
%rotatedNodes = cellfun(@(x,y)mrdivide(x,y'),alltsCells,coefs,'UniformOutput',false);

output = self.cell2skel(rotatedNodes);
function coefs = getTorsoNormal( self )
%GETTORSONORMAL Summary of this function goes here
%   Detailed explanation goes here

% Some function definitions:
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

%normal = cellfun(@(x)x(:,1)',coefs,'UniformOutput',false);
function pixelCoordinates = world2pixel( self )
%WORLD2PIXEL Summary of this function goes here
%   Detailed explanation goes here

% Node positions over time (cell array):
nodes = self.outputNodes;

% Get projection coeficients:
%coefs = self.viewfinderCoef;
coefs = {[0 0 1; 0 1 0; 1 0 0]};
coefs = repmat(coefs,size(nodes));

% updated score: y = x / w'
score = cellfun(@mrdivide,nodes,coefs,'UniformOutput',false);
q_proj = cellfun(@(x)x(:,2:3),score,'UniformOutput',false);

% Projection operation:
q_proj = cellfun(@(x)mtimes(x,[0 -1;1 0]),q_proj,'UniformOutput',false);

%pixelCoordinates = cellfun(@(x,p)floor((x - p)/3*512)+255,q_proj,p,'UniformOutput',false);
pixelCoordinates = cellfun(@(x)floor((x)/3*512)+255,q_proj,'UniformOutput',false);
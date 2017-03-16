function output = skel2cell( skelNodes )
%SKEL2CELL Summary of this function goes here
%   This function is used to transform a timestep cell of the skeleton data
%   into the regular structure of a timestep-node cell. This is mostly used
%   for intra-timestep transformations.
%
%   Input:
%    - output: QxN cell
%   Output:
%    - tsNodes: Qx1 cell, Q is a Nx3 double-array
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Some function definitions:
ts2mat = @(C)cell2mat(C');

% Get input size:
[Q,N] = size(skelNodes);

% make each row of the cell array into a single cell:
rowCells = mat2cell(skelNodes,ones(Q,1),N);

% get nodes for each timestep as cell:
output = cellfun(ts2mat,rowCells,'UniformOutput',false);

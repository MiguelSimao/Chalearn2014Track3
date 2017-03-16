function output = cell2skel( tsNodes )
%CELL2SKEL
%   This function is used to transform a timestep cell of the skeleton data
%   into the regular structure of a timestep-node cell.
%   Input:
%    - tsNodes: Qx1 cell, Q is a Nx3 double-array
%   Output:
%    - output: QxN cell

N = size(tsNodes{1},1);
m = size(tsNodes{1},2);
Q = size(tsNodes,1);
tsNodes = cellfun(@transpose,tsNodes,'UniformOutput',false);


a = cell2mat(tsNodes);

output = mat2cell(a,m * ones(Q,1),ones(N,1));
output = cellfun(@transpose,output,'UniformOutput',false);
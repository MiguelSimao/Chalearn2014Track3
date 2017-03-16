function xyzCoords= skel2vec( cellin )
%SKEL2VEC 
%   Turns a skeleton cell from a SkeletonFE object into a vector to feed a
%   regular Skeleton object.

xyzCoords = cellfun(@(x)[x zeros(1,6)],cellin,'UniformOutput',false);

xyzCoords = cell2mat(xyzCoords);

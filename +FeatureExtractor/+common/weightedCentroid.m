function y = weightedCentroid(X,w)
% weightedCentroid calculates the weighted centroid of N
% points. A weight vector should be provided, otherwise the
% function reverts to a simple centroid.

% Input verification
if nargin<2
    w = ones(size(X,1),1);
else
    assert(isvector(w),...
        'Input weights must be a vector');
    if size(w,2)~=1
        w = w'; end
    assert(length(X)==length(w),...
        'The number of weights should be equal to the number of points');
end
% Calculate centroid
y = w' * X /sum(w);

function output = fitPlane(X)
% fitPlane applies the PCA method to fit a plane to a set of points
% (TLS algorithm). Based on:
% https://www.mathworks.com/help/stats/examples/fitting-an-orthogonal-regression-using-principal-components-analysis.html
%
% Requires: X with rows as observations.
% Make sure that X is centered.


% Data checks
assert(size(X,2)==3,...
    ['You need to provide points with 3 dimensions. You gave <' num2str(size(X,2)) '>.']);
assert(size(X,1)>=3,...
    ['You need to provide at least 3 points to fit a plane. You gave <' num2str(size(X,1)) '>.']);

% Obtain eigenvectors and vectors
[coeff,score,roots] = pca(X,'Centered','off');

% Fit quality
pctExplained = roots' ./ sum(roots);
fitQuality = sum(pctExplained(1:2));

% Point projection (3D points fitted to 2D plane, output in 3D)
projectedPoints = score(:,1:2) * coeff(:,1:2)';

% Output structure
output.projectedPoints = projectedPoints;
output.coeff = coeff;
output.scores = score;
output.fitQuality = fitQuality;
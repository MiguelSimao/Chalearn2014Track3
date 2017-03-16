% Script created to overcome the shortcomings of the later
% (aGetDescriptors.m) code. It would only load samples with ".zip" files.
% At this moment, we have all samples and they are all unzipped in
% 'samplePath'.
%
% Coimbra, February 22, 2017
% Miguel Simão
%
import ChalearnLAPSample.GestureSample
import ChalearnLAPSample.Skeleton


samplePath = 'D:\Users\Simao\LocalDatasets\Chalearn';

% Samples can be found in the D structure:
D = dir([samplePath filesep 'Sample*']);
D = D([D.isdir]);

N = length(D); % total number of samples

P = cell(N,1);
Q = P;
t = tic;
%% loop
for i=1:N
   
    fprintf('Loading sample %i/%i ... ',i,N);
    
    % Build sample path:
    S = [D(i).folder filesep D(i).name];
    % Load GestureSample object:
    S = GestureSample(S,0);
    
    % Construct FeatureExtractor.SkeletonFE object:
    S = FeatureExtractor.SkeletonFE(S);
    S.extractionFcns =   {'doNothing'};
    S.selectedOutputNodes = 1:20;
    
    % Apply preprocessing steps to FE class:
    apply(S);
    % Get descriptors:
    P{i} = cat(1,S.descriptors.positions);
    Q{i} = S.sampleObj.getTargets;

    seconds = toc(t)/i * (N-i);
    fprintf('Done. Time remaining: %i:%is\n',floor(seconds/60),floor(rem(seconds,60)));
end

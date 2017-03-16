
import ChalearnLAPSample.GestureSample
import ChalearnLAPSample.Skeleton

if isunix
    samplePath = '/media/simao/Users/Simao/LocalDatasets/Chalearn';
else
    samplePath = 'D:\Users\Simao\LocalDatasets\Chalearn';
end

% if isempty(getenv('DRIVE_PATH'))
%     error('You don''t have a link to the root folder. Please check your environment variables.'); end

% Samples can be found in the D structure:
DIR = dir([samplePath filesep 'Sample*.zip']);
fprintf('There are %i zipped samples to read.\n',length(DIR));

dirpath = @(X,i)[X(i).folder filesep X(i).name];

s = [];
sampleRange = 1:940;
%sampleLim = 470;%470;
%%
% Extract sample data if needed:
for i = 1:length(DIR)
    fprintf('Extracting sample %i/%i...',i,sampleRange(end));
    s = [s; GestureSample(feval(dirpath,DIR,i),0)];
    fprintf(' Done.\n');
end
clear sampleLim dirpath samplePath


%%
% Construct FeatureExtractor objects:
fprintf('Constructing extraction objects...\n');
FEN = FeatureExtractor.SkeletonFE(s);

fprintf('DONE!\n');

% Apply FE functions:
fprintf('Applying feature extraction functions. This will take a few minutes.\n');

for i=1:length(s)
    fprintf('Sample %i/%i...',i,length(s));
    apply(FEN(i));
    fprintf(' Done.\n');
end

% Getting descriptors:
P = cell(length(FEN),1);
Q = P;
for i=1:length(FEN)
    P{i} = vertcat(FEN(i).getDescriptors.positions);
    Q{i} = FEN(i).sampleObj.getTargets;
end

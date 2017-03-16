function output = movAverage( self )
%MOVAVERAGE Summary of this function goes here
%   In this function we want to apply a moving average filter to the
%   positions of the nodes. But we do not want to apply a centred window,
%   since we should not have a access to future timesteps, so the current
%   timestep is always updated with the previous 

% PARAMETERS:
if isempty(self.movAverageWin)
    window = 4; % 4 frames = 200ms
else
    window = self.movAverageWin;
end


% Get data
input = self.outputNodes;
output = input;


% Group timesteps
% If there are not enough frames available
for i = 1:window-1
    
    a = input(1:i,:);
    output(i,:) = self.skel2cell(a')';
    
end
% Regular case
for i = window:size(input,1)
    
    a = input(i-window+1:i,:);
    output(i,:) = self.skel2cell(a')';
    
end

output = cellfun(@FeatureExtractor.common.weightedCentroid,output,'UniformOutput',false);

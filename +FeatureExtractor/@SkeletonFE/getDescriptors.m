function descriptors = getDescriptors( self )
%GETDESCRIPTORS This function is used to obtain descriptor vectors for
% the nodes.
%   Detailed explanation goes here

if ~self.extractionFcnsApplied
    warning('You did not apply any feature extraction functions. Using raw data.');
end

% select nodes for descriptors
selectedNodes = self.selectedOutputNodes;

% possible descriptors:
fields = {'positions','velocities','accelerations','relativePositions'};
      
input = self.outputNodes;

pos = self.descPositions(input,selectedNodes);
vel = cell(size(input,1),1); % not implemented
ace = cell(size(input,1),1); % not implemented
relPos = descRelativePositions(self);
relPos = self.descPositions(relPos,1:size(relPos,2)); % this function had originally other purpose but it can be used here as well.

c = [pos vel ace relPos];

descriptors = cell2struct(c,fields,2);
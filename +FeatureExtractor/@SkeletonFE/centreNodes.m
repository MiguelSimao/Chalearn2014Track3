function output = centreNodes( self )
%CENTERNODES This func

input = self.outputNodes;
centres = self.torsoCentre;

centres = repmat(centres,1,size(input,2));

output = cellfun(@(x,y){x-y},input,centres);
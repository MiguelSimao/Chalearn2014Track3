classdef SkeletonFE < handle
    % SKELETONFE Class to compose feature extraction functions from a
    % Microsoft Kinect sensor.
    % At this point it only accepts as input a
    % 'ChalearnLAPSample.GestureSample' object.
    % 
    % INPUTS:
    % - 1 'ChalearnLAPSample.GestureSample' object
    % 
    % USAGE:
    % - Run (for visualization):
    %   loaddatawithFE
    %   apply(FE);
    %   y = FE.skelObj;
    %   for i=1:1851 imshow(y(i).toImage(512,512,[1 1 1])); end
    %
    
    % Here is the order of joints returned by Kinect for Windows
    %     HipCenter = 1;
    %     Spine = 2;
    %     ShoulderCenter = 3;
    %     Head = 4;
    %     ShoulderLeft = 5;
    %     ElbowLeft = 6;
    %     WristLeft = 7;
    %     HandLeft = 8;
    %     ShoulderRight = 9;
    %     ElbowRight = 10;
    %     WristRight = 11;
    %     HandRight = 12;
    %     HipLeft = 13;
    %     KneeLeft = 14;
    %     AnkleLeft = 15;
    %     FootLeft = 16; 
    %     HipRight = 17;
    %     KneeRight = 18;
    %     AnkleRight = 19;
    %     FootRight = 20;
    
    properties
        sampleObj %handle to sample object
        skeletonNodes %original skeleton data
        outputNodes
        pixelCoordinates
        skelObj
        
        %list of functions
        extractionFcns =   {'doNothing',...
                            'centreNodes',...
                            'rotateNodes',...
                            'normalizeLinks',...
                            'movAverage'}
                        
        extractionFcnsApplied = false
        
        torsoNodes =       {'ShoulderCenter',...
                            'ShoulderLeft',...
                            'ShoulderRight',...
                            'Spine',...
                            'HipCenter',...
                            'HipLeft',...
                            'HipRight'}
        selectedOutputNodes = [6:8 10:12];
        nodesList
        meanLinkLen
        movAverageWin
        
    end
    properties (Dependent)
        % Parameters for processing steps
        torsoCentre
        torsoNormal
        viewfinderCoef
        
        % Gesture descriptors
        descriptors
    end
    
    methods
% Contructor
        function self = SkeletonFE(varargin)
            if nargin == 0; return; end
            
            sampleObj = varargin{1};
            assert(isa(sampleObj,'ChalearnLAPSample.GestureSample'),...
                'Please provide a ChalearnLAPSample.GestureSample argument.');
            
            N = length(sampleObj);
            
            self(N,1) = FeatureExtractor.SkeletonFE;
            tic;
            if N <= 1
                for i=1:N
                    self(i).sampleObj = sampleObj(i);
                    skeletonNodes = sampleObj(i).getAllNodeCoordinates;
                    self(i).nodesList = fieldnames(skeletonNodes);
                    self(i).skeletonNodes = struct2cell(skeletonNodes)';
                    self(i).outputNodes = skeletonNodes;
                    %fprintf('Loaded sample %i.\n',i);
                end
            else
                parfor i=1:N
                    self(i).sampleObj = sampleObj(i);
                    skeletonNodes = sampleObj(i).getAllNodeCoordinates;
                    self(i).nodesList = fieldnames(skeletonNodes);
                    self(i).skeletonNodes = struct2cell(skeletonNodes)';
                    self(i).outputNodes = self(i).skeletonNodes;
                    %fprintf('Loaded sample %i.\n',i);
                end
            end
            %toc;
            
            
        end
        
% Get functions
        function Y = get.torsoCentre(self); Y = getCentreTorso(self); end
        function Y = get.torsoNormal(self); Y = getTorsoNormal(self); end
        function Y = get.pixelCoordinates(self); Y = world2pixel(self); end
        function out = get.skelObj(self)
            pixelXY = self.pixelCoordinates;
            worldXYZ = self.outputNodes;
            y = cellfun(@(wdXYZ,pxXY)[wdXYZ zeros(1,4) pxXY],worldXYZ,pixelXY,'UniformOutput',false);
            y = cell2mat(y);
            out = ChalearnLAPSample.Skeleton(y);
        end
        function out = get.viewfinderCoef(self); out = viewfinder(self); end
        function out = get.meanLinkLen(self)
            if isempty(self.meanLinkLen)
                t = load('meanLinkLength1_470.mat');
                out = t.meanLinkLen;
            else
                out = self.meanLinkLen;
            end
        end
% Descriptor methods:
        function out = get.descriptors(self);  out = getDescriptors(self); end
        y = descRelativePositions(self);
% Set methods
        function set.extractionFcns(self,value)
            self.extractionFcnsApplied = false;
            self.extractionFcns = value;
        end
% Feature extraction methods
        function apply(self)
            self.outputNodes = self.skeletonNodes;
            for i=1:length(self.extractionFcns)
                %disp(['Applying ''' self.extractionFcns{i} '''...']);
                self.outputNodes = eval(sprintf('%s(self);',self.extractionFcns{i}));
            end
            self.extractionFcnsApplied = true;
        end
        function Y = doNothing(self); Y = self.outputNodes; end
        y = centreNodes(self);
        y = rotateNodes(self);
        y = funReduceToArms(self);
        y = funRelativePositions(self);
        

    end
    methods (Static)
        function Y = weightedCentroid(varargin)
            switch nargin
                case 1
                    Y = FeatureExtractor.common.weightedCentroid(varargin{1});
                case 2
                    Y = FeatureExtractor.common.weightedCentroid(varargin{1},varargin{2});
                otherwise
                    error('Wrong number of inputs.');
            end
        end
        varargout = fitPlane(x1);
        y = cell2skel(x);
        y = skel2cell(x);
        y = skel2vec(x);
        y = descPositions(nodeData,selectedNodes);
    end
    
end


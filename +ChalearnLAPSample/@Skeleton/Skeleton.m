classdef Skeleton
    %SKELETON Class that represents the skeleton information
    %   define a class to encode skeleton data
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
    %     FotoRight = 20;
    
    properties
        joins
        nodeDef =  {'HipCenter',...         %1
                    'Spine',...             %2;
                    'ShoulderCenter',...    %3;
                    'Head',...              %4;
                    'ShoulderLeft',...      %5;
                    'ElbowLeft',...         %6;
                    'WristLeft',...         %7;
                    'HandLeft',...          %8;
                    'ShoulderRight',...     %9;
                    'ElbowRight',...        %10;
                    'WristRight',...        %11;
                    'HandRight',...         %12;
                    'HipLeft',...           %13;
                    'KneeLeft',...          %14;
                    'AnkleLeft',...         %15;
                    'FootLeft',...          %16; 
                    'HipRight',...          %17;
                    'KneeRight',...         %18;
                    'AnkleRight',...        %19;
                    'FotoRight'}            %20;
        
        SkeletonConnectionMap  =   [{'HipCenter' 'Spine'};...              %[[1  2];  %Spine
                                    {'Spine' 'ShoulderCenter'};...          %[2  3];
                                    {'ShoulderCenter' 'Head'};...           %[3  4];
                                    {'ShoulderCenter' 'ShoulderLeft'};...   %[3  5];  %Left Hand
                                    {'ShoulderLeft' 'ElbowLeft'};...        %[5  6];
                                    {'ElbowLeft' 'WristLeft'};...           %[6  7];
                                    {'WristLeft' 'HandLeft'};...            %[7  8];
                                    {'ShoulderCenter' 'ShoulderRight'};...  %[3  9];  %Right Hand
                                    {'ShoulderRight' 'ElbowRight'};...      %[9  10];
                                    {'ElbowRight' 'WristRight'};...         %[10 11];
                                    {'WristRight' 'HandRight'};....         %[11 12];
                                    {'HipCenter' 'HipRight'}; ...           %[1  17]; %Right Leg
%                                   {'HipRight' 'KneeRight'};...            %[17 18];
%                                   {'KneeRight' 'AnkleRight'};...          %[18 19];
%                                   {'AnkleRight' 'FootRight'};...          %[19 20];
                                    {'HipCenter' 'HipLeft'}; ...            %[1  13]; %Left Leg
%                                   {'HipLeft' 'KneeLeft'};...              %[13 14];
%                                   {'KneeLeft' 'AnkleLeft'};...            %[14 15];
%                                   {'AnkleLeft' 'FootLeft'}];              %[15 16]];
                                    {}]
    end
    
    methods
        function self = Skeleton(data)
            if nargin == 0
                return; end
            
            N = size(data,1);
             
            n = ones(N,1);
            m = 9 * ones(length(self.nodeDef),1);
            
            joins = mat2cell(data,n,m);
            joins = cell2struct(joins,self.nodeDef,2);
            
            self(N,1) = ChalearnLAPSample.Skeleton;
            for i=1:N
                self(i).joins = joins(i);
            end
            
        end
        function data = getAllData(self)
            % Return a structure with all the information for each skeleton node
            data = self.joins;
        end
        function skel = getWorldCoordinates(self)
            % Get World coordinates for each skeleton node
            skel = struct;
            keys = fieldnames(self.joins);
            for i=1:numel(keys)
                skel.(keys{i}) = self.joins.(keys{i})(1:3);
            end
        end
        function skel = getJoinCoordinates(self)
            % Get orientations of all skeleton nodes
            skel = struct;
            keys = fieldnames(self.joins);
            for i=1:numel(keys)
                skel.(keys{i}) = self.joins.(keys{i})(4:7);
            end
        end
        function skel = getPixelCoordinates(self)
            % Get Pixel coordinates for each skeleton node
            skel = struct;
            keys = fieldnames(self.joins);
            for i=1:numel(keys)
                skel.(keys{i}) = self.joins.(keys{i})(8:9);
            end
        end
        function im = toImage(self,width,height,bgColor)
            bgColor = reshape(bgColor,1,1,3);
            im = ones(height,width) .* bgColor;
            pts = zeros(length(self.SkeletonConnectionMap),4);
            for i=1:length(self.SkeletonConnectionMap)
                pts(i,1:2) = self.getPixelCoordinates.(self.SkeletonConnectionMap{i,1});
                pts(i,3:4) = self.getPixelCoordinates.(self.SkeletonConnectionMap{i,2});
            end
            im = insertShape(im,'Line',pts,'LineWidth',6,'Color','blue');
            circ = [pts(:,1:2);pts(:,3:4)];
            circ = [circ repmat(5,size(circ,1),1)]; %set marker RADIUS inside repmat
            im = insertShape(im,'FilledCircle',circ,'Color','red','Opacity',1);
            im = uint8(im*255);
        end
        y = linkLength(self);
    end
    
end
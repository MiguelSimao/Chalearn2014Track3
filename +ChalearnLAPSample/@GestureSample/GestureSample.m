classdef GestureSample < handle
    %GESTURESAMPLE Class that allows to access all the information for a
    %certain gesture database sample.
    %   define class to access gesture data samples
    %   21-nov-2016
    %   - changed class to handle class
    properties
        fullFile
        dataPath
        file
        seqID
        samplePath
        unzip
        videoFlag
        
        rgb
        depth
        user
        skeletons
        data
        labels
        
        
    end
    
    methods
        function self = GestureSample(fileName,arg2,arg3)
            %Constructor. Read the sample file and unzip it if it is
            %necessary. All the data is loaded.
            %sample=GestureSample('Sample0001.zip')
            %sample=GestureSample('Sample0001.zip',0) avoids loading video
            
%             if mod(nargin,2)~=1
%                 error('Please input a complete Property/Value pair.'); end
            
            if nargin == 2
                %arg2 is video flag
                self.videoFlag = arg2>0;
            else
                self.videoFlag = true;
            end
            
            % Check if is directory (unzipped file):
%             switch exist(fileName)
%                 case 0
%                     error (['File not found: '  fileName]);
%                 case 7
%                     % filename is a directory
%                 case 2
%                     % filename is a file
%                     [~,~,ext] = fileparts(fileName);
%                     
%             end
            % Check the given file
            if ~exist(fileName,'file')
                error (['File not found: '  fileName]); end
                                
        
            
            getval = @(x,i)char(x{i});
            % Prepare sample information
            self.fullFile = fileName;
            self.dataPath = getval(py.os.path.split(fileName),1);
            self.file     = getval(py.os.path.split(fileName),2);
            self.seqID    = getval(py.os.path.splitext(self.file),1);
            self.samplePath= [self.dataPath char(py.os.path.sep) self.seqID];
            
             % Unzip sample if it is necessary
            if py.os.path.isdir(self.samplePath)
                self.unzip = false;
            else
                self.unzip = true;
                unzip(self.fullFile,self.samplePath);
            end
            
            % Open video access for RGB information
            if self.videoFlag
                rgbVideoPath=[self.samplePath filesep self.seqID '_color.mp4'];
                if ~exist(rgbVideoPath,'file')
                    error('Invalid sample file. RGB data is not available'); end
                self.rgb = VideoReader(rgbVideoPath);
                depthVideoPath=[self.samplePath filesep self.seqID '_depth.mp4'];
                if ~exist(depthVideoPath,'file')
                    error('Invalid sample file. Depth data is not available'); end
                self.depth = VideoReader(depthVideoPath);
                userVideoPath=[self.samplePath filesep self.seqID '_user.mp4'];
                if ~exist(userVideoPath,'file')
                    error('Invalid sample file. User data is not available'); end
                self.user = VideoReader(userVideoPath);
            end
            
            % Read skeleton data
            skeletonPath = [self.samplePath filesep self.seqID '_skeleton.csv'];
            if ~exist(skeletonPath,'file')
                error('Invalid sample file. Skeleton data is not available'); end
            self.skeletons=csvread(skeletonPath);
            
            % Read sample data
            sampleDataPath=[self.samplePath filesep self.seqID '_data.csv'];
            if ~exist(sampleDataPath,'file')
                error('Invalid sample file. Sample data is not available'); end
            data = csvread(sampleDataPath);
            self.data.numFrames=data(1);
            self.data.fps=data(2);
            self.data.maxDepth=data(3);
            
            % Read labels data
            labelsPath=[self.samplePath filesep self.seqID '_labels.csv'];
            if ~exist(labelsPath,'file')
                warning('Labels are not available. Writing placeholder ground truth.');
                self.labels = [99 1 self.data.numFrames];
            else
                self.labels=csvread(labelsPath);
            end
            
            
        end
        function delete(self)
            % Destructor. If the object unziped the sample, it remove the temporal data
            if self.unzip
                self.clean; end
        end
        function clean(self)
            % Clean temporal unziped data
        end
        function frame = getFrame(~,video,frameNum)
            % Get a single frame from given video object
            % Check frame number
            % Get total number of frames
            numFrames = video.Duration * video.FrameRate;
            % Check the given file
            if frameNum<1 || frameNum>numFrames
                error(['Invalid frame number <' num2str(frameNum) '>. Valid frames are values between 1 and ' num2str(numFrames) '.']);
            end
            % Set the frame index
            video.CurrentTime = (frameNum-1)*1/video.FrameRate; 
            try
                frame = readFrame(video);
            catch
                error('Could not read the specified frame.');
            end
        end
        function frame = getRGB(self,frameNum)
            % Get the RGB color image for the given frame
            frame = self.getFrame(self.rgb,frameNum);
        end
        function depth = getDepth(self,frameNum)
            % Get the depth image for the given frame
            depth = self.getFrame(self.depth,frameNum);
            % Convert to grayscale
            depth = rgb2gray(depth);
            % Convert to depth values
            depth = single(depth) / 255 * self.data.maxDepth;
            depth = round(depth);
        end
        function user = getUser(self,frameNum)
            % Get the user segmentation image for the given frame
            user = self.getFrame(self.user,frameNum);
        end
        function skelO = getSkeleton(self,frameNum)
            % Get the skeleton information for a given frame. It returns a
            % Skeleton object.
            
            % Check frame number
            % Get total number of frames
            numFrames = length(self.skeletons);
            % Check the given file
            if frameNum<1 || frameNum>numFrames
                error(['Invalid frame number <' num2str(frameNum) '>. Valid frames are values between 1 and ' num2str(numFrames) '.']);
            end
            skelO = ChalearnLAPSample.Skeleton(self.skeletons(frameNum,:));
        end
        function pts = getNodeCoordinates(self,frameNum)
            % Get the skeleton node world coordinates for a given frame.
            
            % Check frame number
            % Get total number of frames
            numFrames = length(self.skeletons);
            % Check the given file
            if frameNum<1 || frameNum>numFrames
                error(['Invalid frame number <' num2str(frameNum) '>. Valid frames are values between 1 and ' num2str(numFrames) '.']);
            end
            skelO = ChalearnLAPSample.Skeleton(self.skeletons(frameNum,:));
            pts = skelO.getWorldCoordinates;
        end
        function ptsStruct = getAllNodeCoordinates(self)
            % Get the skeleton node world coordinates for a given frame.

            % Get total number of frames
            numFrames = length(self.skeletons);
            
            % Initialize
            ptsCell = cell(numFrames,1);
            
            for i=1:numFrames
                pts = self.getNodeCoordinates(i);
                ptsCell{i} = pts;
            end
            ptsStruct = [ptsCell{:}]';
        end
        function frame = getSkeletonImage(self,frameNum)
            % Create an image with the skeleton image for a given frame
            frame = self.getSkeleton(frameNum).toImage(640,480,[1 1 1]);
        end
        function comp = getComposedFrame(self,frameNum)
            % Get a composition of all the modalities for a given frame
            % get sample modalities
            rgb = self.getRGB(frameNum);
            depthValues = self.getDepth(frameNum);
            user = self.getUser(frameNum);
            skel = self.getSkeletonImage(frameNum);
            
            % Build depth image
            depth = depthValues * 255 / self.data.maxDepth;
            depth = uint8(round(depth));
            depth = ind2rgb(depth,jet(255));
            depth = uint8(depth*255);
            
            % Build final image
            compSize1=[max([size(rgb,1) size(depth,1)]) size(rgb,2) + size(depth(2))];
            compSize2=[max([size(user,1) size(skel,1)]) size(user,2) + size(skel(2))];
            comp = zeros(compSize1(1)+compSize2(1),max([compSize1(2) compSize2(2)]),3,'uint8');
            
            % Create composition
            comp(1:size(rgb,1),1:size(rgb,2),:) = rgb;
            comp(1:size(depth,1),size(rgb,2)+1:size(rgb,2)+size(depth,2),:) = depth;
            comp(compSize1(1)+1:compSize1(1)+size(user,1),1:size(user,2),:) = user;
            comp(compSize1(1)+1:compSize1(1)+size(skel,1),size(user,2)+1:size(user,2)+size(skel,2),:) = skel;
            imshow(comp,'Border','tight');
        end
        function lbls = getGestures(self)
            % Get the list of gesture for this sample. Each row is a
            % gesture, with the format (gestureID,startFrame,endFrame)
            lbls = self.labels;
        end
        function name = getGestureName(~,gestureID)
            % Get the gesture label from a given gesture ID
            names={'vattene','vieniqui','perfetto','furbo','cheduepalle','chevuoi','daccordo','seipazzo', ...
                   'combinato','freganiente','ok','cosatifarei','basta','prendere','noncenepiu','fame','tantotempo', ...
                   'buonissimo','messidaccordo','sonostufo'};
            % Check given file
            if gestureID < 1 || gestureID > 20
                error(['Invalid gesture ID <'  num2str(gestureID)  '>. Valid IDs are values between 1 and 20.']);
            end
            name = names{gestureID};
        end
        function V = getTargets(self)
            % Pre-allocate var, id==21 is rest (base)
            v = 21*ones(1,self.data.numFrames);
            
            for i=1:size(self.labels,1)  %max gestureID
                lbl = self.labels(i,:);    %id|start_frame|end_frame
                v(lbl(2):lbl(3)) = lbl(1);
            end
            V = full(ind2vec(v))';
        end
    end
    
end

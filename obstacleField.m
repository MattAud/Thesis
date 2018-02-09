%% Obstacle Field Class
% By Matt Audette
% Last Update: 20180120
% Remarks: This is a class that will take in individual obstacle type data
% structures and then store them as a "field"

% To Do:
% - add obstacle
%       -error if VarArgIn is not > 0
%       -error message if not obstacle type
% - set field size
%       -error if not an int
% - construct visibility plot
% - construct visibility array


classdef obstacleField
    properties %(SetAccess = private)
        %Name;             %stores the string of the field name
        Field;            %an array of obstacle objects 
        %FieldNames;       %an array of strings to store obstacle names
        NumObstacles = 0; %Number of obstacles stored in the array
        qinit;        %Has a start point been defined?
        qgoal;        %Has an end point been defined?
        fieldSize = 10; %Set the field size
        minFieldSize = 0; %the minimum x and y value to plot
        
    end %end properties
    
    methods
        %Constructor Method
        function of = obstacleField(varargin) %VarArgIn accepts var. # inputs
            %it is possible to create an empty obstaccle field and load it
            %later:
            if(nargin > 0)
                %load the first obstactle in:
                of.Field = varargin{1};
                of.NumObstacles = of.NumObstacles + 1;
                %of.FieldNames = VarNametoString(varargin{1})
                %load the rest, if there are some:
                if (nargin > 1)
                    for i = 2:nargin
                        of.Field = [of.Field, varargin{i}];
                        of.NumObstacles = of.NumObstacles + 1;
                        %of.FieldNames = [of.FieldNames, VarNametoString(varargin{i})]
                    end %for i = 2:nargin
                end %if (nargin > 1)
            end %if(nargin > 0)

            
        end %obstacleFeild

        %% Add an Obstacle to an existing field
        function of = addObstacle(of, varargin) %First state the field, then obstacles
            % if VarArgIn = 0, throw an error:
            
            %load the first VarArgIn:
            %first, check if the Field has obstacles already so that we
            %dont overwrite:
            if(of.NumObstacles > 0)
                disp('in the if loop!')
                of.Field = [of.Field, varargin{1}];
                of.NumObstacles = of.NumObstacles + 1;
                %of.FieldNames = VarNametoString(varargin{1})
            else %No previous obstacles, load in the first one
                disp('in the else loop')
                of.Field = varargin{1}
                of.NumObstacles = of.NumObstacles + 1;
                %of.FieldNames = [of.FieldNames, VarNametoString(varargin{1})]
            end

            %Load in the rest of VarArgIn:
            if(nargin > 2)
                for i = 2:length(varargin)%2:nargin
                    disp('in the for loop')
                    i
                    of.Field = [of.Field, varargin{i}]
                    of.NumObstacles = of.NumObstacles + 1;
                    %of.FieldNames = [of.FieldNames, VarNametoString(varargin{1})];
                end %for loop
            end %if varargin >1
            
        end %addObstacle
        
        %% create qinit
        function of = initPoint(of, point) %assume point is an [x,y] array
            of.qinit = point;

        end %initPoint
        
        %% create qgoal
        function of = goalPoint(of, point) %assume point is an [x,y] array
            of.qgoal = point;
      
        end %initPoint
        
        %% plot the field
        function plotField(of)
            figure
            hold on
            grid on
            title(['Plotted Obstacles and Points in Obstacle Field ' inputname(1)])
            xlim([of.minFieldSize, of.fieldSize]) 
            ylim([of.minFieldSize, of.fieldSize])
            % if qinit is defined:
            if(isempty(of.qinit) ~= true)
                plot(of.qinit(1), of.qinit(2), 'g*')
            end
            
            %if qgoal is defined:
            if(isempty(of.qgoal) ~= true)
                plot(of.qgoal(1), of.qgoal(2), 'r*')
            end
            
            %plot the obstacles:
            for i = 1:of.NumObstacles
                %Get the x points of the obstacle:
                xpoints = of.Field(i).Vertices(:,1);
                %Get the y points: 
                ypoints = of.Field(i).Vertices(:,2);
                %first connect the first and last point by reloading 
                %the first point into the last slot:
                xpoints = [xpoints', xpoints(1)];
                ypoints = [ypoints', ypoints(1)];
                
                %plot the obstacle:
                plot(xpoints, ypoints)
            end
            hold off  
        end %plotField
        
        %% set field size
        function of = setFieldSize(of, highNumber, lowNumber)
            %if it isn't an int, error message:
            of.fieldSize = highNumber;
            of.minFieldSize = lowNumber;
        end
        
        %% auto field size 
        % sets the field size based on the largest and smallest corrdinates
        function of = autoFieldSize(of)
            border = 2; %the buffer added around the max and min points
            maxHolderArray = [1];
            minHolderArray = [];
            
            for i = 1:of.NumObstacles
                %Get the max point of the obstacle:
                maxNum =  max(of.Field(i).Vertices);
                maxHolderArray = [maxHolderArray, maxNum];
                
                %get the min num:
                minNum = min(of.Field(i).Vertices);
                minHolderArray = [minHolderArray, minNum];
                
            end
            %grab the q points:
            maxNum = max(of.qinit, of.qgoal);
            maxHolderArray = [maxHolderArray, maxNum];
            minNum = min(of.qinit, of.qgoal);
            minHolderArray = [minHolderArray, minNum];
            
            maxNo = max(maxHolderArray);
            minNo = min(minHolderArray);
            of.fieldSize = maxNo + border;
            of.minFieldSize = minNo - border; 
        end
        
        %% construct visibility matrix
        function visibilityMatrix(of)
            %in a loop: load in the points of the obstacle:
            %get all the other points
            
            for i = 1:of.NumObstacles - 1
                %Get the x points of the obstacle:
                xpoint = of.Field(i+1).Vertices(i,1)
                %Get the y points: 
                ypoint = of.Field(i+1).Vertices(i,2)
                %first connect the first and last point by reloading 
                %the first point into the last slot:
%                 xpoints = [xpoints', xpoints(1)];
%                 ypoints = [ypoints', ypoints(1)];
                
            end
            
            %build PHI, phi, s, and t:
            
            %test for the intersect:
            
            %take the result of the 'intersect' and plug it into a martix:
            
            %return the matrix:
        end
        
        
        %% construct visibility graph
        
    end %end methods
    
end %classdef
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
% - Integrate the Waypoints subclass: qinit and qgoal specifically

classdef obstacleField
    properties 
        %Name;             %stores the string of the field name
        Field;            %an array of obstacle objects 
        %FieldNames;       %an array of strings to store obstacle names
        NumObstacles = 0; %Number of obstacles stored in the array
        qinit;        %Has a start point been defined?
        qgoal;        %Has an end point been defined?
        fieldSize = 10; %Set the field size
        minFieldSize = 0; %the minimum x and y value to plot
        
        PointIndex = []; %an array of all the points in the obstacle field
        VisibilityMatrix = []; %This is where we will store the visibility 
                               %array once we create it
        
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
      
        end %goalPoint
        
        %% plot the field
        function plotField(of)
            figure
            hold on
            grid on
            title(['Plotted Obstacles and Points in Obstacle Field ' inputname(1)])
            %xlim([of.minFieldSize, of.fieldSize]) 
            %ylim([of.minFieldSize, of.fieldSize])
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
        
        %% Construct the point index array
        %the point index array is a single array that will contain all the
        %points in each obstacle, the waypoints, and the qinit and goal. It
        %will be the primary way to index points in the visibility graph
        %and plot functions. 
        
        %The Index is a 3 dimensional array. Array 1 (:, :, 1) yeilds
        %the points. Array 2 yelds an nx2 array that is an index of which 
        %(obstacle #, point #) we are on. So calling of.PointIndex(1,:, 2)
        %will return [1,1] or "obstacle 1, point 1." of.PointIndex(2, : 2)
        %will return [1,2] of "obstacle 1, point 2."
        
        %To access a point index numer C, call the command 
        % obstacleField.PointIndex(C,:, 1) and it will return the point.

        %To do:
        % - work in waypoints
        % - find a way to return A1, B4, etc. versus just since points.
        function of = constructPointIndex(of)
            holderArray = []; %We'll fill this up with all the points
            temp = [];
            %starting with obstacle 1, loop through the array and load in
            %each point:
            for i = 1:of.NumObstacles
                %get the obstacle's vertices and store them in temp:
                temp = of.Field(i).Vertices;
                %This loads into the temp array's second array all of colum
                % 1: the obstacle number.
                temp(:, 1, 2) = i;
                
                %Now load into the second arry's colum 2 the point number:
                for j = 1:of.Field(i).NumVertices
                    temp(j, 2, 2) = j;
                end
                
                holderArray = [holderArray; temp];
            end
            
            %now that all the points are loaded, if qinit and goal exist,
            %load them as well:
            
            %All q points will be "obstacle numer 0."
            if(isempty(of.qinit) ~= true) %"If qInit is empty is false, it's been assigned"
                temp = of.qinit;
                %The second array is [0, 0], with init being point 0.
                temp(:, 1, 2) = 0;
                temp(:, 2, 2) = 0;
                holderArray = [holderArray; temp];
                %holderArray = [holderArray; of.qinit];
            end
            if(isempty(of.qgoal) ~= true) %"If qgoal is empty is false, it's been assigned"
                temp = of.qgoal;
                temp(:, 1, 2) = 0;
                temp(:, 2, 2) = 1;
                %The second array is [0, 1], with goal being point 1.
                holderArray = [holderArray; temp];
                %holderArray = [holderArray; of.qgoal];
            end
            
            %now that all the points are indexed, assign the holder array
            %to the PointIndexValue:
            of.PointIndex = holderArray;
        end
        
        %% Get point from Index:
        % This fuction works backwards from the point index array: it is
        % fed an index number and returns the point. This will be used to
        % map the completed visibility matrix to the points in the field.
        
        % To do:
        % - The if statement for the isempty does not update the obstacle
        % field's PointIndex. It DOES, however, return the correct value.
        function point = getPointFromIndex(of, index)
            %If the PointIndex array is empty, build one:
            if (isempty(of.PointIndex) == true)
                of = constructPointIndex(of);

            end
            
            point = of.PointIndex(index, :, 1);
        end
        
        %% Get Obstacle info from index:
        % This function will read in an index number and return the second
        % array in the point index, returning the [obstacle#, point#] 
        % To do:
        % - The if statement for the isempty does not update the obstacle
        % field's PointIndex. It DOES, however, return the correct value.
        function point = getObstacleFromIndex(of, index)
            %If the PointIndex array is empty, build one:
            if (isempty(of.PointIndex) == true)
                of = constructPointIndex(of);

            end
            
            point = of.PointIndex(index, :, 2);
        end
        
        %% construct visibility matrix
        function of = visibilityMatrix(of)
            disp('=========================================')
            disp('=========================================')
            disp('=========================================')


            %get a pointIndex for the obstacle field:
            of = constructPointIndex(of);

            %get number of obstacles:
            maxObstacleNo = of.NumObstacles
            %maxObstacleNo = max(testField1.PointIndex(:,1,2))
            lengthPointIndex = length(of.PointIndex)
            visibMatrix = 5*ones(lengthPointIndex);

            %Get a P:
            %counter 'r' is for "row number"
            for r = 1:length(of.PointIndex)
                disp('============ Get an a ============')
                %hit the diagonal:
                visibMatrix(r,r) = -1;

                a = getPointFromIndex(of, r)

                temporary = getObstacleFromIndex(of, r)
                thisObstacleNo = temporary(1)
                thisPointNo = temporary(2)

                % ---------- GOES HERE: Special case -----
                % Assuming that all the obstacles are convex, we can assume that ONYL 
                % the two adjasecnt points are connected. Point 1 connects to points 2
                % and 4, but nt to point 3, and so on. Assign those values here:

                %For each obstacle, get the indices of its points and store them in a
                %temporary holder array:
                r
                thisObstaclesPointIndices = find(of.PointIndex(:,1,2) == thisObstacleNo)
                minObstPoint = min(thisObstaclesPointIndices)
                maxObstPoint = max(thisObstaclesPointIndices)

                %Adjascent points: This only applies to obstacles. If the current
                %obstacle is 0 (meaning we are testing qInit and qGoal), skip this.
                if thisObstacleNo ~= 0
                    %For each point, connect the two adjasecnt points. Be sure to "wrap"
                    %the points: 1 connects to 2 & 4, 4 connects to 3 & 1.
                    if r == minObstPoint %This is the first point, wrap it around:
                        visibMatrix(r, r+1) = 1;
                        %make the rest zeros
                        visibMatrix(r, r+2:thisObstaclesPointIndices(end)) = 0;
                        %go back and make the last one 1
                        visibMatrix(r, maxObstPoint) = 1;
                    elseif r == maxObstPoint
                        visibMatrix(r,r) = -1;
                    else
                        visibMatrix(r,r+1) = 1;
                        %make the rest zeros:
                        visibMatrix(r, r+2:thisObstaclesPointIndices(end)) = 0;
                    end
                else 
                    visibMatrix(r,r) = -1;

                end

                %Another special case: the qInit and qGoal points. 
                % If they points exist in the array, as 'a' cycles through, they will
                % be checked against each point like every other point. 
                % BUT because they are last, they will not be checked against one
                % another.
                %If either qInit or qGoal is not yet defined, just fill the diagonal
                %and move on. If BOTH exist, we just need to check them against one
                %another.
                visibMatrix

                % ----------------------------------------
                %Get a b:
                % b comes from the first point in the next obstacle:
                %Find the index of the first obstacle labeled '2' in the second
                %idexArray. 
                if thisObstacleNo == maxObstacleNo
                    disp('We"ve reach the last obstacle. Search for q points.')
                    nextObstacleNo = 0
                else
                    nextObstacleNo = thisObstacleNo + 1
                end

                %bstart is the first point of the next obstacle in the PointIndex
                %array. If
                bstart = min( find(of.PointIndex(:,1,2) == nextObstacleNo))

                for bIndex = bstart:lengthPointIndex
                    disp('----- Geta b----')
                    a
                    b = getPointFromIndex(of, bIndex) 

                    %if the last point is 0, the only thing to check is for a straight
                    %line between qgoal and qinit. But this is the case for if qInit
                    %AND qGoal exist. If one or the other only exist, then this step is
                    %not needed. Exit the loop. 
                    if thisObstacleNo == 0 && (isempty(of.qinit) == true)  %if qinit IS empty
                        break %we are done. Exit the loop.    
                    end

                    if thisObstacleNo == 0 && (isempty(of.qgoal) == true)
                        break %we are done. Exit the loop.
                    end

                    if thisObstacleNo == 0 && (isempty(of.qinit) ~= true) && (isempty(of.qgoal) ~= true)
                        disp('+++++++++++++++++++++++++++++++++++++++++++++++++++++++')
                        if r == length(of.PointIndex) %this is the last point. Bounce.
                            disp('HERE')
                            r
                            break
                        else
                            disp('THERE')
                            r
                            aIndex = min(thisObstaclesPointIndices)
                            bIndex = max(thisObstaclesPointIndices)

                            a = getPointFromIndex(of, aIndex)
                            b = getPointFromIndex(of, bIndex)
                        end
                    end

                    %Now that we have P, we need to test it against every edge in the
                    %field. These will be our Qs.
                    %----------------------------------------------
                    for jj = 1:of.NumObstacles
                        disp('---- TOP of "for jj = 1:testField1.NumObstacles"')
                        jj
                        %Grab the x and y points of the j-th obstacle in the field:
                        xpoints = of.Field(jj).Vertices(:,1);
                        ypoints = of.Field(jj).Vertices(:,2);

                        %CYCLES through all points in an obstacle to make a Q matrix
                        for i = 1:length(xpoints)
                            disp('---- TOP of "for i = 1:length(xpoints)"')
                            if i == length(xpoints) %then i is the last number, load in the first point
            %                     Q = [xpoints(i), xpoints(1);
            %                         ypoints(i), ypoints(1)]
                                  c = [xpoints(i), ypoints(i)]
                                  d = [xpoints(1), ypoints(1)]
                            else
            %                     Q = [xpoints(i), xpoints(i+1);
            %                         ypoints(i), ypoints(i+1)]
                                  c = [xpoints(i), ypoints(i)]
                                  d = [xpoints(i+1), ypoints(i+1)]
                            end

                            %Now that we have a Q, test it for intesrection:
                            intersect = testIntersection(a,b,c,d);

                            %if at any point the intersect == 1, break out of THIS loop
                            %and get a new 'b'. Put the results down in the visibility
                            %matrix.
                            if intersect == 1
                                disp('Intersect is true, break out of the Q loop.')
                                visibMatrix(r,bIndex) = 0;
                                break %This break will break us out of getting a new Q.
                                      %We can stop that and get a new b at this point.
                                      %So we will exit out of this loop and hit this
                                      %phrase VVV right down there. THAT break will
                                      %kick us back up to getting a new b.
                            end

                        end %Getting Q, testing intersection
                        if intersect == 1
                            disp('Keep exiting, get a new b.')
                            %visibMatrix(r,bIndex) = 0
                            break
                        else %intersect == 0
                            visibMatrix(r,bIndex) = 1;
                        end
                    end %grab c and d, check intersection
                    %----------------------------------------------

                end %get a b


            end %Build P
            
            of.VisibilityMatrix = visibMatrix
        end
        
        

        
        %% Visibility Matrix Recall Function:
        % Input will be (obstField, row, column), and the return will be
        % three things: point 1 (row), point 2 (column)
        
        % To do:
        % Come up with a better name
        function points = recallPointsFromMatrix(of, row, col)
            %points = [];
            %first, if there isn't a visibility matrix, error:
            if (isempty(of.VisibilityMatrix) == true) 
                error('ERROR: Make a visibility matrix first.')
            end
            
            %If row > column, throw an error:
            %Would we just switch it instead?
            if (row > col) 
                error('ERROR: The returned points should be above the diagonal.')
            end
            
            %return the point from the point index:
            holder1 = getPointFromIndex(of, row);
            holder2 = getPointFromIndex(of, col);
            points = [holder1; holder2];
            
        end %recall points from matrix 
        
        %% construct visibility graph
        function plotVisibilityGraph(of)
            %if there's no visibility matrix, make one:
            if (isempty(of.VisibilityMatrix) == true)
                error('There is no Visilibity Matrix. Make one.')
                %of = visibilityMatrix(of);
            end
            
            %first, turn on the figure:
            %figure
            
            %build the plot for the obstacle field:
            plotField(of) %this will hold our figure, too
            hold on
            grid on
            title('Plot of the Visibility Graph')
            axis('equal')
            
            %Plot the connected connected obstacle points
            %by running through every point above the diagonal:
            
            % rows starts at 1. IOT avoid the diagonal:
            for rowCounter = 1:length(of.VisibilityMatrix)
                %column = rows + 1 for the start of the loop
                colCounterStart = rowCounter + 1;
                for colCounter = colCounterStart:length(of.VisibilityMatrix)
                    %if the index == 1, plot the line
                    if of.VisibilityMatrix(rowCounter, colCounter) == 1
                        %get the points:
                        pointHolder = recallPointsFromMatrix(of, rowCounter, colCounter);
                        
                        plot(pointHolder(:,1), pointHolder(:,2), 'k:')
                    end
                end %count the columns
            end %count the rows
            
            %if the index == 1, plot the line
            
            
        end %PlotVisibilityMap Function
        
        
    end %end methods
    
end %classdef
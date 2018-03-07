%% Obstacle Field Test Bed
% By Matt Audette
% Last Update: 20180121
% Remarks: This is a script that will be used to test the obstacle and
% obstacle field classes.

% Notes:
% - You still have to type 'emptyField = addObstacle(emptyField, obst1,
% obst2)' instead of 'addObstacle(emptyField, obst1, obst2)'
% ^^ I take that back, that works in the command window, but not in
% scripts.  

clc
clear all
close all
format compact

%% Create Obstacles:
disp(' ---------- Create three obstacles ------- ')
obstA = obstacle([2,1], [2,2], [3,2], [3,1]);
obstB = obstacle([6,6], [7,6], [7,7]);
obstC = obstacle([4,2], [5,2], [5,7], [4,7]);

%% Create the obstacle fields:
disp(' ----------Create Two Fields ------- ')
emptyField = obstacleField() %an empty test field
testField1 = obstacleField(obstA, obstB) %use the constructor and add 2 obstacles
%ensure that the NumObstacles goes up:

%Now test the addObstacle function and ensure that the counts are correct
%and do no overwrite one another:
disp(' ---------- Expand the Fields ------- ')

%Note: in this script, the call is:
% emptyField = addObstacle(emptyField, obst1, obst2)
%In the command window, it would be typed:
% addObstacle(emptyField, obst1, obst2)
%addObstacle(testField1, obst3)

emptyField = addObstacle(emptyField, obstA, obstB)
testField1 = addObstacle(testField1, obstC)

disp(' ---------- Set an Init Point ------- ')
testField1 = initPoint(testField1, [1,1])
% In the command window: initPoint(testField1, [1,1])

disp('----- Create a waypoint load it as a point ----')
qstart = Waypoint( [3,4], 0);
qend = Waypoint( [8,8] );
qend = setClass(qend, 1);
emptyField = initPoint(emptyField, qstart.Location)
emptyField = goalPoint(emptyField, qend.Location)
% In the command window: initPoint(testField1, [1,1])

disp(' ---------- Set a Goal Point ------- ')
testField1 = goalPoint(testField1, [8,7])
% In the command window: goalPoint(testField1, [8,7])

disp(' ---------- Plot the Field ------- ')
plotField(testField1)
% In the command window: goalPoint(testField1, [8,7])

%Test the function of the empty qinit and qgoal functions:
plotField(emptyField)

disp(' ---------- Test the Field Size Change ------- ')
emptyField = setFieldSize(emptyField, 15, 1)
plotField(emptyField)

disp(' --------- Auto Size Feature ----------')
emptyField = autoFieldSize(emptyField)
plotField(emptyField)

disp(' --------- Built Point Index Feature----------')
%the point index array is a single array that will contain all the
%points in each obstacle, the waypoints, and the qinit and goal. It
%will be the primary way to index points in the visibility graph
%and plot functions.

%To access a point index numer C, call the command
% obstacleField.PointIndex(C,:) and it will return the point.
testField1 = constructPointIndex(testField1)
disp(' Test calling a singe point by its index:')
testField1.PointIndex(3,:, 1) %where '3' is the index

disp(' --------- Get Point From Index Feature----------')
% This fuction works backwards from the point index array: it is
% fed an index number and returns the point. This will be used to
% map the completed visibility matrix to the points in the field.
pointTest = getPointFromIndex(testField1, 3) 

%This function will also check if the point index is empty, and if so,
%build a point index. Test this with emptyField:
pointTest2 = getPointFromIndex(emptyField, 3)

disp(' --------- Get Obstacle Info From Index Feature----------')
% This function gives an index number from the PointIndex and returns the
% second array's infor. It will be in the form of [obstacle#, point#].
% Test is out for the same two points as before:
obstacleTest = getObstacleFromIndex(testField1, 3)
obstacleTest2 = getObstacleFromIndex(emptyField, 3)

%% Build the visibility Matrix

index = min( find(testField1.PointIndex(:,1,2) == 2))
testOutPoint = getObstacleFromIndex(testField1, index)

%% Take two:
disp('=========================================')
disp('=========================================')
disp('=========================================')


%get a pointIndex for the obstacle field:
testField1 = constructPointIndex(testField1);

%get number of obstacles:
maxObstacleNo = testField1.NumObstacles
%maxObstacleNo = max(testField1.PointIndex(:,1,2))
lengthPointIndex = length(testField1.PointIndex)
visibMatrix = 5*ones(lengthPointIndex);

%Get a P:
%counter 'r' is for "row number"
for r = 1:length(testField1.PointIndex)
    disp('============ Get an a ============')
    %hit the diagonal:
    visibMatrix(r,r) = -1;
    
    a = getPointFromIndex(testField1, r)
    
    temporary = getObstacleFromIndex(testField1, r)
    thisObstacleNo = temporary(1)
    thisPointNo = temporary(2)
    
    % ---------- GOES HERE: Special case -----
    % Assuming that all the obstacles are convex, we can assume that ONYL 
    % the two adjasecnt points are connected. Point 1 connects to points 2
    % and 4, but nt to point 3, and so on. Assign those values here:
    
    %For each obstacle, get the indices of its points and store them in a
    %temporary holder array:
    r
    thisObstaclesPointIndices = find(testField1.PointIndex(:,1,2) == thisObstacleNo)
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
    bstart = min( find(testField1.PointIndex(:,1,2) == nextObstacleNo))
    
    for bIndex = bstart:lengthPointIndex
        disp('----- Geta b----')
        a
        b = getPointFromIndex(testField1, bIndex) 
        
        %if the last point is 0, the only thing to check is for a straight
        %line between qgoal and qinit. But this is the case for if qInit
        %AND qGoal exist. If one or the other only exist, then this step is
        %not needed. Exit the loop. 
        if thisObstacleNo == 0 && (isempty(testField1.qinit) == true)  %if qinit IS empty
            break %we are done. Exit the loop.    
        end
        
        if thisObstacleNo == 0 && (isempty(testField1.qgoal) == true)
            break %we are done. Exit the loop.
        end
        
        if thisObstacleNo == 0 && (isempty(testField1.qinit) ~= true) && (isempty(testField1.qgoal) ~= true)
            disp('+++++++++++++++++++++++++++++++++++++++++++++++++++++++')
            if r == length(testField1.PointIndex) %this is the last point. Bounce.
                disp('HERE')
                r
                break
            else
                disp('THERE')
                r
                aIndex = min(thisObstaclesPointIndices)
                bIndex = max(thisObstaclesPointIndices)
                
                a = getPointFromIndex(testField1, aIndex)
                b = getPointFromIndex(testField1, bIndex)
            end
        end
        
        %Now that we have P, we need to test it against every edge in the
        %field. These will be our Qs.
        %----------------------------------------------
        for jj = 1:testField1.NumObstacles
            disp('---- TOP of "for jj = 1:testField1.NumObstacles"')
            jj
            %Grab the x and y points of the j-th obstacle in the field:
            xpoints = testField1.Field(jj).Vertices(:,1);
            ypoints = testField1.Field(jj).Vertices(:,2);
            
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
                    visibMatrix(r,bIndex) = 0
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
                visibMatrix(r,bIndex) = 1
            end
        end %grab c and d, check intersection
        %----------------------------------------------
        
    end %get a b
    

end %Build P

disp('========================')
disp('Start working on the recall function:')
%The input will be (row, column):

%5 Get the visibility array:

%If there isn't a visibility array, create one:

%If row > column, throw an error:
    %Would we just switch it instead?

%return the point from the point index:

%

disp('Outline how we will plot the visibility array:")
%first call the plot function:

%cycle through the visibility array:

% rows starts at 1. IOT avoid the diagonal:
%column = rows + 1 for the start of the loop

%if the index == 1, plot it:



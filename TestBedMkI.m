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

%% Still in the works: Visibility Matrix:
disp(' ========= test =======')
visibilityMatrix(emptyField)

disp('This will cycle through an obstacle field and make a Q matrix for each point.')
for j = 1:testField1.NumObstacles
    j
    %Grab the x and y points of the j-th obstacle in the field:
    xpoints = testField1.Field(j).Vertices(:,1)
    ypoints = testField1.Field(j).Vertices(:,2)

    %CYCLES through all points in an obstacle to make a Q matrix
    for i = 1:length(xpoints) 
        if i == length(xpoints) %then i is the last number, load in the first point
            Q = [xpoints(i), xpoints(1); 
                 ypoints(i), ypoints(1)]
        else
            Q = [xpoints(i), xpoints(i+1); 
                 ypoints(i), ypoints(i+1)]
        end
        
        %THIS IS WHERE YOU CHECK FOR INTERSECTION
    end
end

% Get a number of points:
n = 0;
numEntities = 0;
for j = 1:testField1.NumObstacles
    j
    n = n + length(testField1.Field(j).Vertices)
end
numEntities = testField1.NumObstacles;
if(isempty(testField1.qinit) ~= true)
    n = n+1;
    numEntities = numEntities+1;
end
if(isempty(testField1.qgoal) ~= true)
    n = n+1;
    numEntities = numEntities+1;
end
n
numEntities
visibMatrix = zeros(n)
%Outer loop: 
% The outer loop will build the line P in the PHI matrix. P consists of two
% points, a and b. P = [ax, bx; ay, by]. Point a should be from the current
% obstacle (number k) and point b should be from the NEXT obstacle.
for k = 1:testField1.NumObstacles - 1 %needs to become numEntities
    k
    
%     %get the number of vertices in this obstacle:
%     vThis = length(testField1.Field(k).Vertices) 
%     %get the number of vertices in this obstacle:
%     vNext = length(testField1.Field(k+1).Vertices) 
    
    %Start with obstacle 1, vertex 1 and obstacle 2, vertex 1 for P:
    %% Problem- this will only do the first point in each obstacle
    Pcol1 = testField1.Field(k).Vertices(1,:)'; %point a, column form
    Pcol2 = testField1.Field(k+1).Vertices(1,:)'; %point b, column form
    P = [Pcol1, Pcol2]
    
    % Get a Q:
    %Q has points c and d. Q will cycle through ALL lines in the obstacle
    %field, INCLUDING other lines from current obstacle k. 
    
    %Point c will be the first point in the next obstacle k, point d will
    %be the second point in the obstacle.
    
    %After you cycle through all the point in this obstacke, you need to go
    %on to the next obstacle.
    
    %Number of points to test = number of overall points (n) - number of
    %points in current obstacle
    %% This is going to be a problem later- 
    disp('p should equal the number of points in the next obstacke.')
    p =  length(testField1.Field(k).Vertices) 
    %run through all the points in this obstacle:
    for i = 1:p % I think this is right: we want to start at the first vertice 
                % of the next obstacle and then move until the end of the
                % matrix n.
        if i == p %then i is the last number, load in the first point
            Qcol1 = testField1.Field(k).Vertices(i,:)'; 
            Qcol2 = testField1.Field(k).Vertices(1,:)'; %the first point
        else
            Qcol1 = testField1.Field(k).Vertices(i,:)';
            Qcol2 = testField1.Field(k).Vertices(i+1,:)';
        end
        Q = [Qcol1, Qcol2]
        
        %% Now that we have a Q, check for the intersection
        % in the mean time, just fill the matrix with a point to check for
        % thoroughness:
%         visibMatrix( , ) = 1;
        
    % Test it for intersection/clear
    % Get a new Q
    % When done with all Qs, exit this loop, get a new P and repeat
        
    end





    % Cycles through all the obstacles in a field:
    % for j = 1:testField1.NumObstacles
    %     testField1.Field(j).Vertices
    %     
end

%% Take two:
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
obstA = obstacle([2,1; 2,2; 3,2; 3,1]);
obstB = obstacle([6,6; 7,6; 7,7]);
obstC = obstacle([4,2; 5,2; 5,7; 4,7]);

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

%% test the Index feature

index = min( find(testField1.PointIndex(:,1,2) == 2))
testOutPoint = getObstacleFromIndex(testField1, index)

%% Build the visibility Matrix:
% Note: there is still a math problem in the visibility matrix:
testField1 = visibilityMatrix(testField1) %in the command prompt, use
    % visibilityMatrix(testFeild1)
%emptyField = visibilityMatrix(emptyField)


disp('========================')
disp('Start working on the recall function:')
%The input will be (row, column):

%Get the visibility array:

%If there isn't a visibility array, create one:

%If row > column, throw an error:
    %Would we just switch it instead?

%return the point from the point index:
points1 = recallPointsFromMatrix(testField1, 1, 4)
%This VV error message works.
%points2 = recallPointsFromMatrix(emptyField, 1, 4)


disp('Outline how we will plot the visibility array:')
%first call the plot function:

%cycle through the visibility array:

% rows starts at 1. IOT avoid the diagonal:
%column = rows + 1 for the start of the loop

%if the index == 1, plot it:

plotVisibilityGraph(testField1)
plotVisibilityGraph(emptyField)


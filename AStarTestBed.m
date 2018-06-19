%% A* Search Test Bed
% by Matt Audette
% last update: 20180530

% This is the test script for kicking the tires on my node/A* search object
% class.

%% To do:
% - Fix it so that the search stops when q == the goal. As of now, it
% stops the search when q SEES the goal.
% - Do something about that awful way we loaded that last node in to the
% closedList(). YOU ARE BETTER THAN THAT. 

% RUN THE SCRIPT TestBedMkI BEFORE HAND! 
% RUN THE SCRIPT GoogleEarthToolboxTest BEFORE HAND, TOO! 
% This script will read in the obstacleField objects from both.
% TestBedMkI
% GoogleEarthToolboxTest
% clc

% Build a test node:
node1 = node([1,2])

% Fill out the other properties:
% If you do this in the command line, it's just 'setIndex(node1, 1)'
node1 = setIndex(node1, 1)

node1 = setF(node1, 0); 
%an f of '0' indicates that it's the start point, so we should set the
%initFlag property to 1. And it is therefore NOT the goal node, so...
node1 = setInitFlag(node1, 1);
node1 = setGoalFlag(node1, 0);

% And fill out the rest of the properties in order to test them:
node1 = setG(node1, 0);
node1 = setH(node1, 20);
node1 = setNeighbors(node1, [2,3,4,5])
node1 = setCameFrom(node1, 7)



% This completes the node functions. Move into the A* Search Object

% A* Class:
disp('============================================================')
%Create an A* search object:
aStarTest = AStarSearch(testField1)

%Load of the node index:
aStarTest = pointsToNodes(aStarTest)

%Now do it with the GoogleMapsToolboxTest 
aStarFromKML = AStarSearch(testField2)
%aStarFromKML = pointsToNodes(aStarFromKML)

aStarTest = nodeIndextoCellArray(aStarTest)
%aStarFromKML = nodeIndextoCellArray(aStarFromKML)

%set the cost function flagL
aStarTest = setCostFlag(aStarTest, 0)
%aStarFromKML = setCostFlag(aStarFromKML, 1)

test = findOptimalPath(aStarTest)

% Testing the optimal path function:
aStarTest = findOptimalPath(aStarTest)
aStarFromKML = findOptimalPath(aStarFromKML)

%cell2mat(aStarTest.closedList(:, 2))
plotOptimalPath(aStarTest)
plotOptimalPath(aStarFromKML)

%% Test getting the coordinate list:
coordList = coordsFromOptimalPath(aStarFromKML.optimalPath)
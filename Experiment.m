%% Experiment File

% This script takes the three testBed scripts-TestBedMkI,
% GoogleEarthToolboxTest, and AStarTestBed, and concatonates all them into
% one script with the experiment.

% Instructions:
% Go Into GoogleEarth, pick a location, and create an obstacle field by
% drawing squares around visible obstacles. Save is as 'experimentObstacles.kml'

% Then pick a single point to be the initial position. Save it as
% "experimentInitPos.kml". Do the same with a goal pos, 
% save as "experimentGoalPos.kml"

% Then run this script.


% Matt Audette
% 20180618

clear all
clc

obstacleFieldName = 'experimentObstacles.kml'
initPointName = 'experimentInitPos.kml'
goalPointName = 'experimentGoalPos.kml'

%% Create the Obstacle field from the KML:
% initiate an empty field
demoField = obstacleField();
% load it with our obstacles
demoField = kmlToObstacleField(demoField, obstacleFieldName)

%% Load in the initial and goal points:
% And the start point:
demoField = kmlToInit(demoField, initPointName);

% And the goal point:
demoField = kmlToGoal(demoField, goalPointName);

%% Plot it:
plotField(demoField)

%% Build the Visibility Matrix:
demoField = visibilityMatrix(demoField)
plotVisibilityGraph(demoField)

%% Find and plot the Optimal Path:
%First, create an AStar Search Object:
aStarDemo = AStarSearch(demoField)
%Find and plot the optimal path:
aStarDemo = findOptimalPath(aStarDemo)
plotOptimalPath(aStarDemo)

%% Produce the optimal path:
coordinateList = coordsFromOptimalPath(aStarDemo.optimalPath)

%% Loop the Function:
for i = 1:size(coordinateList, 1)
    %Send the coordinate and waypoint # 
    %and wait for the robot to go to that point:
    potentialFieldToWaypoint( coordinateList(i, :), i)
    
end
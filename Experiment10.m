%% Experiment 10:

% By Matt Audette
% 20180723

% The goal of experiemnt 10 is the first long distance test of the rover.
% The initial point is the time capsule cover in the Spanagel courtyard and
% the goal point is the entry way to the machine shop in thw Watkin's
% Courtyard.

clear all
clc

obstacleFieldName = 'SimplifiedNPS.kml'
initPointName = 'NPSinit10.kml'
goalPointName = 'NPSgoal10.kml'

%% Create the Obstacle field from the KML:
% initiate an empty field
obstField = obstacleField();
% load it with our obstacles
obstField = kmlToObstacleField(obstField, obstacleFieldName)

%% Load in the initial and goal points:
% And the start point:
obstField = kmlToInit(obstField, initPointName);

% And the goal point:
obstField = kmlToGoal(obstField, goalPointName);

%% Plot it:
plotField(obstField)

%% Build the Visibility Matrix:
obstField = visibilityMatrix(obstField)
plotVisibilityGraph(obstField)

%% Find and plot the Optimal Path:
%First, create an AStar Search Object:
aStar = AStarSearch(obstField)
%Find and plot the optimal path:
aStar = findOptimalPath(aStar)
plotOptimalPath(aStar)

%% Produce the optimal path:
coordinateList = coordsFromOptimalPath(aStar.optimalPath)

save('Experiment10WS')

% filledOutCoordList = []           
% for i = 1: size(coordinateList, 1) - 1
%     thisPoint = [coordinateList(i, 1:2)]
%     nextPoint = [coordinateList(i+1, 1:2)]
%     
%     holder = fillOutPoints(thisPoint, nextPoint, interval)
%     
%     filledOutCoordList = [filledOutCoordList; holder]
%     
% end
% 
% figure(1)
% plot(filledOutCoordList(:, 2), filledOutCoordList(:, 1), 'r*', ...
%     coordinateList(:, 2), coordinateList(:,1), 'b*')
% grid on


save('Experiment10WS')

% load('Experiment10WS')

% % Loop the Function:
% for i = 1:size(coordinateList, 1)
%     %Send the coordinate and waypoint # 
%     %and wait for the robot to go to that point:
%     potentialFieldToWaypoint( coordinateList(i, :), i)
%     
% end




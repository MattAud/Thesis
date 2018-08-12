%% Experiment 13:

% By Matt Audette
% 20180811

% The goal of experiemnt 13 is to test ability to navigate around the
% obstacle in the soccer field at La Mesa

%artificialObstacle = 'ArtificialObstacle.kml';
obstacleFieldName = 'SoccerObst.kml';
initPointName = 'SoccerStart.kml';
goalPointName = 'SoccerGoal.kml';

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


save('Experiment13WS')

% load('Experiment13WS')

% % Loop the Function:
% for i = 1:size(coordinateList, 1)
%     %Send the coordinate and waypoint # 
%     %and wait for the robot to go to that point:
%     potentialFieldToWaypoint( coordinateList(i, :), i)
%     
% end


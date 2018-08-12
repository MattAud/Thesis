%% Experiment 14:

% By Matt Audette
% 20180811

% The goal of experiemnt 14 is Ex 13 with intermitten waypoints

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

%% Fill in the Waypoints
%interval was determined in the distanceFunction script:
interval = 5.389410894387732e-05
filledOutCoordList = []           
for i = 1: size(coordinateList, 1) - 1
    thisPoint = [coordinateList(i, 1:2)]
    nextPoint = [coordinateList(i+1, 1:2)]
    
    holder = fillOutPoints(thisPoint, nextPoint, interval)
    
    filledOutCoordList = [filledOutCoordList; holder]
    
end

figure(1)
plot(filledOutCoordList(:, 2), filledOutCoordList(:, 1), 'r*', ...
    coordinateList(:, 2), coordinateList(:,1), 'b*')
grid on
axis('equal')


save('Experiment14WS')

% load('Experiment14WS')

% % Loop the Function:
% for i = 1:size(filledOutCoordList, 1)
%     %Send the coordinate and waypoint # 
%     %and wait for the robot to go to that point:
%     potentialFieldToWaypoint( filledOutCoordList(i, :), i)
%     
% end


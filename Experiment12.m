%% Experiment 12:

% By Matt Audette
% 20180811

% The goal of experiemnt 12 is to test the straight line travel across the
% field

clear all
clc

initPointName = 'SoccerStart.kml';
goalPointName = 'SoccerGoal.kml';

% Get and print the start point:
[x,y,z] = read_kml(initPointName);
startCoords = [x,y]

% Get and print the goal point:
[x,y,z] = read_kml(goalPointName);
goalCoords = [x,y]

coordinateList = [startCoords; goalCoords]


save('Experiment12WS')

% load('Experiment12WS')

% % Loop the Function:
% for i = 1:size(coordinateList, 1)
%     %Send the coordinate and waypoint # 
%     %and wait for the robot to go to that point:
%     potentialFieldToWaypoint( coordinateList(i, :), i)
%     
% end

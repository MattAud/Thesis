%% Experiment 1:

% By Matt Audette
% 20180618

% The goal of experiemnt 1 is to test the ability of the P3At with Calvin's
% code implimented as a function to follow a series of waypoints. The
% waypoints are hard coded below.

coordinatList = [-121.875038,  36.595486, 1;
                 -121.875022,  36.595455, 2;
                 -121.874951,  36.595323, 3;
                 -121.874951,  36.595323, 4;
                 -121.874951,  36.595323, 5]
%% Loop the Function:
for i = 1:size(coordinateList, 1)
    %Send the coordinate and waypoint # 
    %and wait for the robot to go to that point:
    potentialFieldToWaypoint( coordinateList(i, :), i)
    
end
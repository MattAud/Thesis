%% Experiment 2:

% By Matt Audette
% 20180618

% The goal of experiemnt 2 is to test the ability of the P3At with Calvin's
% code implimented as a function to follow a series of waypoints. The
% waypoints are hard coded below.

% It expands on experiment 1 by sorting out the correct number of decimal
% places in the GPS coordinate.

format long


coordinateList = [  36.5952586795043,  -121.8752055358401, 0;
                    36.5951850550108,  -121.8749317803787, 0;
                    36.5952469350787,  -121.8748334451527, 0;
                    36.5954219577176,  -121.8750115295564, 0;
                    36.5952789297301,  -121.8752253576720, 0]
%% Loop the Function:
for i = 1:size(coordinateList, 1)
    %Send the coordinate and waypoint # 
    %and wait for the robot to go to that point:
    potentialFieldToWaypoint( coordinateList(i, :), i)
    
end
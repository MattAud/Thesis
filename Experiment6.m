%% Experiment 6:

% By Matt Audette
% 20180618

% The goal of experiemnt 6 is to test the fillOutPoints function in order
% to increase the reliability of the navigation algorith.

% The points put in are the exact same as Experiment 2 and will then be
% filled with intermittent points.

format long

%interval was determined in the distanceFunction script:
interval = 5.389410894387732e-05


coordinateList = [  36.5952586795043,  -121.8752055358401, 0;
                    36.5951850550108,  -121.8749317803787, 0;
                    36.5952469350787,  -121.8748334451527, 0;
                    36.5954219577176,  -121.8750115295564, 0;
                    36.5952789297301,  -121.8752253576720, 0]
filledOutCoordList = []           
for i = 1: size(coordinateList, 1) - 1
    thisPoint = [coordinateList(i, 1:2)]
    nextPoint = [coordinateList(i+1, 1:2)]
    
    holder = fillOutPoints(thisPoint, nextPoint, interval)
    
    filledOutCoordList = [filledOutCoordList; holder]
    
end

figure(1)
plot(filledOutCoordList(:, 2), filledOutCoordList(:, 1), 'b*', ...
    coordinateList(:, 2), coordinateList(:,1), 'g*')
grid on


save('Experiment6WS')

% load('Experiment6WS')
%% Loop the Function:
% for i = 1:size(filledOutCoordList, 1)
%     %Send the coordinate and waypoint # 
%     %and wait for the robot to go to that point:
%     potentialFieldToWaypoint( filledOutCoordList(i, :), i)
%     
% end
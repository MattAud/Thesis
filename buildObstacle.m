%% Obstacle Function
% By Matt Audette
% Last Update: 20180120
% Remarks: This function will take in points and classift them as an
% obstacle.

% Inputs will be paired x and y coordinates that are CLOCKWISE in order
% The function will read in a variable number of inputs (minimum of three)
% and then put the points into an X points and Y points array. 

% To Do:

function [output] = buildObstacle(varargin) %VarArgIn is the call for 
                                       %variable numbers of inputs
%show the number of arguments in:
disp(nargin);
disp(varargin);

disp(varargin{1});

holder = varargin{1};
holder(1);

% Check for atleast three input points:
% Check for atleast three input points:
            if (nargin < 3) error('Input must be at minimum three points.')
            end
                
% build an x and y array of the input points:
xpoints = [holder(1)];
ypoints = [holder(2)];
for i = 2:(nargin)  %for the number of inputs minus the first point
    i %display the counter just to make sure
    
    %update holder:
    holder = varargin{i};
    xpoints = [xpoints, holder(1)];
    ypoints = [ypoints, holder(2)];
    
end

%% Plot it:
%first connect the first and last point by reloading the first point into
%the last slot:
xpoints = [xpoints, xpoints(1)];
ypoints = [ypoints, ypoints(1)];

figure(1)
hold on
grid on
xlim([0, 10])
ylim([0, 10])
plot(xpoints, ypoints)
hold off


end
%%Obstacle Class
% By Matt Audette
% Last Update: 20180208
% Remarks: This is a class type that will be a single obstacle.

% To Do:
% 

classdef obstacle
    properties
        %What properties will go here?
        Vertices    %Stores the vertices of an obstacle
        NumVertices %Stores the number of vertices of an obstacle
        EdgeLines %Stores the edge lines point by point
        ObstacleNumber %Will be assigned by the Field Class.
        %pointAssignment % a 1x2 array that will store the obstacle number 
                       %(to be determined by the obstacle field, will be '0' 
                       %for now) and the point number. When called, it will
                       %return an [x,y] coordinate. For example, [0,1] will
                       %return the first point [2,1] in an obstacle.
    end
    methods %(Static)
        %constructor method
    function obst = obstacle(inputArray)
            holder = inputArray(1, :)
            xpoints = [holder(1)]
            ypoints = [holder(2)];    
            
            for i = 2:length(inputArray)  %for the number of inputs minus the first point
                %update holder:
                holder = inputArray(i, :);
                xpoints = [xpoints, holder(1)];
                ypoints = [ypoints, holder(2)];
            end
            
            %Set the obstacle's properties
            obst.Vertices = [xpoints; ypoints]';
            obst.NumVertices = length(xpoints);
        %end
        
%% This part was used before I implimented the Google Maps piece. 
% It worked for the matlab only portion quite well, but only the Matlab
% portion. It was too much work to rejigger it to take in the format being
% produced by the kmlToObstacle function, so I just reqrote the constructor
% method to take in arrays.


%         function obst = obstacle(varargin) %VarArgIn is the call for 
%                                        %variable numbers of inputs
%             % Check for atleast three input points:
%             if (nargin < 3) error('Input must be at minimum three points.')
%             end
%             % build an x and y array of the input points:
%             holder = varargin{1};
%             xpoints = [holder(1)];
%             ypoints = [holder(2)];
% 
%             
%             for i = 2:(nargin)  %for the number of inputs minus the first point
%                 %update holder:
%                 holder = varargin{i};
%                 xpoints = [xpoints, holder(1)];
%                 ypoints = [ypoints, holder(2)];
%             end
%             
%             %Set the obstacle's properties
%             obst.Vertices = [xpoints; ypoints]';
%             obst.NumVertices = length(xpoints);

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
        end %makeObstacle
        

    end
end
%% Obstacle Class
% By Matt Audette
% Last Update: 20180120
% Remarks: This is a class type that will be a single obstacle.

% To Do:
% - make a plot function? Of would that go into an obstacle array class?


classdef obstacle
    properties
        %What properties will go here?
        Vertices    %Stores the vertices of an obstacle
        NumVertices %Stores the number of vertices of an obstacle
        EdgeLines %Stores the edge lines point by point
    end
    methods (Static)
        %constructor method
        function obst = obstacle(varargin) %VarArgIn is the call for
        %function obst = makeObstacle(varargin) %VarArgIn is the call for 
                                       %variable numbers of inputs
            % Check for atleast three input points:
            if (nargin < 3) error('Input must be at minimum three points.')
            end
            % build an x and y array of the input points:
            holder = varargin{1};
            xpoints = [holder(1)];
            ypoints = [holder(2)];
            
%             %empty array to store the edges:
%             edges = [];
%             edgeHoler = [holder(1), holder(2)];
            
            for i = 2:(nargin)  %for the number of inputs minus the first point
                %update holder:
                holder = varargin{i};
                xpoints = [xpoints, holder(1)];
                ypoints = [ypoints, holder(2)];
                
%                 %put the current point into the edge holder array:
%                 edgeHolder(i) = [holder(1), holder(2)] 
                
            end
            
            %Set the obstacle's properties
            obst.Vertices = [xpoints; ypoints]';
            obst.NumVertices = length(xpoints);

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
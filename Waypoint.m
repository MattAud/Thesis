%% Waypoints Class
% By Matt Audette
% Last Update: 20180208
% Remarks: This is a class type that will be a point. It will be qinit,
% qgoal, as well as waypoints in the obstacle fields.


% To Do:
% - Name property?
% - how do I tell if it's an init or goal?
%   -If it a "class" property? 0 =init, 1 = goal, 2 = waypoint?
% - error for the input of the constructor not being an [x,y] array
% - Error messages for if the class input isn't 0,1, or 2
% - a "set class" function

classdef Waypoint
    properties
        Location %stores the single point
        PointNumber %will be set by the obstacle field class
        Class %assigns the point as a Qinit, Qgoal, or waypoint.
              % 0 = qinit, 1 = qgoal, 2 = waypoint
    end 
    
    methods
        %constructor method- takes in an [x,y] array and an option 0, 1, or
        %2 to set the class
        function point = Waypoint(varargin) 
            %Check that the input is an x, y set of coordinates
%             if (length(xyArray ~= 2) error('Input must be an [x,y] or [x;y] array.')
%             end
            
            %the first thing in will by the [x,y] coordinate.
            xyArray = varargin{1};

            %format the inputs- this allows the user to load [x,y] OR [x;y]
            %points as inputs.
            xpoint = xyArray(1);
            ypoint = xyArray(2);
            point.Location = [xpoint, ypoint];
            
                        %if there's a next thing, it'll be the class.
            if nargin == 2 
                point.Class = varargin{2}
            end
            
            %% Plot it:
%             figure(1)
%             hold on
%             grid on
%             xlim([0, 10]) 
%             ylim([0, 10])
%             plot(xpoint, ypoint, 'b*')
%             hold off
            
        end%constructor
        %set the class later
        function point = setClass(point, num)
            point.Class = num;
        end
    end %methods
    
end %classdef
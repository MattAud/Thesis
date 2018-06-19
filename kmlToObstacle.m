%% KML to Obstacle function
% Matt Audette
% 
% Reads in a .kml file and spits out in obstacle object. 
% Uses the read_kml function by _________ available on the Mathworks online
% app repository.

% To do:
% - Get the author's name:
% - Determine whether this will be an obstacle field or just obstacle objs

function obstacleOutput = kmlToObstacle(fileNameString)

    %% Read in the .kml file:
    % Store it in an array
    stoX, stoY, stoZ = read_kml(fileNameString)
    pointCounter = length(stoX)

    %% Sort the coordinates into obstacles:
    % The .kml file is just a series of points. If you look at the GPS
    % coordinates, the stored points repeat the first/last point, meaning the a
    % square bounding box will read points 1, 2, 3, 4, 1, then the next
    % coordinates. We will use that to identify where one obstacle begins and
    % the ends.
    temp = [];
    for i = 1:pointCounter
        temp = [temp, [stoX(i), stoY(i)]
            %if we chack the first coordinate against itself, it'll be
            %true. So skip the first element
            if length(temp) > 1
                find(temp == stoX(i)
            end
    end
    

    % Go through the storage array and sort the points into obstacles:
    
    %% Get rid of this:
    obstacleOutput = 1;

end


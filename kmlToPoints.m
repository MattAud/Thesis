%% KML to Point function
% Matt Audette
% 
% Reads in a .kml file and spits out in obstacle field. 
% Uses the read_kml function by _________ available on the Mathworks online
% app repository.

% To do:
% - Get the author's name:
% - Turn off all the outputs
% - Change the description

function oField = kmlToPoints(oField, fileNameString)
    %% Read in the .kml file:
    % Store it in an array
    [stoX, stoY, stoZ] = read_kml(fileNameString)
    pointCounter = length(stoX)

    %% Sort the coordinates into obstacles:
    % The .kml file is just a series of points. If you look at the GPS
    % coordinates, the stored points repeat the first/last point, meaning the a
    % square bounding box will read points 1, 2, 3, 4, 1, then the next
    % coordinates. We will use that to identify where one obstacle begins and
    % the ends.
    temp = [];
    for i = 1:pointCounter
        % We need to take the first coordinate to be loaded into the temporary
        % holder so that we can use it as a reference to look for the repeat
        % value. We'll call the variable "checker".
        if length(temp) == 0
            checker = stoX(i)
        end
        temp = [temp; [stoX(i), stoY(i)]];

        %if we check the first coordinate against itself, it'll be
        %true. So skip the first element.
        if length(temp) > 2
            %if the current value matches the checker reference value,
            %trim the last coordinate off (it's a repeat) and then clear the
            %temporary storage matrix.
            if stoX(i) == checker
                disp('FOUND A MATCH!')
                trimNumber = length(temp)-1;
                temp
                holder = temp(1:trimNumber, :)
                %The obstacleField class takes in obstacles,
                %so turn holder into an obstacle:
                holderObstacle = obstacle(holder);
                oField = addObstacle(oField, holderObstacle);
                temp = [];
            end
        end

    end

end
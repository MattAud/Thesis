%% KML to Goal function
% Matt Audette
% 
% Reads in a .kml file and spits out an obstacle field term of "end point"
% that can then be loaded into the Obstacle Field function. 
% Uses the read_kml function by _________ available on the Mathworks online
% app repository.

% To do:
% - Get the author's name:
% - Turn off all the outputs
% - Fix the Comments

function oField = kmlToGoal(oField, fileNameString)
    %% Read in the .kml file:
    % Store it in an array
    [stoX, stoY, stoZ] = read_kml(fileNameString)
    point = [stoX, stoY];
    
    % Load it:
    oField = goalPoint(oField, point);


end
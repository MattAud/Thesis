%% Matlab / Google Earth toolbox test kit:
% Using the two add ons on "read_kml" (a stand alone function)
% and the Google Earth Toolbox (a collection) to read and write .kml
% files for the Matlba code to write and Google Earth to open.

% Matt Audette
% 20180430

% clear all
% clc


%% Test Reading in a .kml file
% In my Matlab main folder, I have a .kml file that I saved.
% The read_kml produces an three matrices: [x, y, z] 

%[x, y, z] = read_kml('test_polygon.kml')

% Reading in from a specific file path
readInStr = 'C:\Users\audet\OneDrive\Documents\MATLAB\multi_point_test.kml';
[A,B,C] = read_kml(readInStr)

%% Test writing the .kml file:
% draw a point:
% doc ge_point
kmlStrTest = ge_point(-121.898008, 36.611903, 0);
fileNameStr = 'testKmlFile.kml';
ge_output(fileNameStr, kmlStrTest, 'name', 'test test?')

% draw a line:
%kmlStrTest2 = ge_plot([-121.898008, 36.611903, 0], [-121.91, 36.78, 0])
% The function reads [X coords], [Y coords]
kmlStrTest2 = ge_plot( [-121.898008, -121.91], [36.611903, 36.78] )
fileNameStr2 = 'testKmlFile2.kml';
ge_output(fileNameStr2, kmlStrTest2, 'name', 'This should be a line')

%% Test bed for the KML to obstacle function:

%% Read in the .kml file:
% Store it in an array
[stoX, stoY, stoZ] = read_kml(readInStr)
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
            testObstacle = obstacle(holder)
            temp = [];
        end
    end
    
end

%% Test out the kmlToObstacleField:
testField2 = obstacleField();
testField2 = kmlToObstacleField(testField2, readInStr)

% Load in the goal point:
goalString = 'EndPointTest.kml';
testField2 = kmlToGoal(testField2, goalString);

% And the start point:
initString = 'StartPointTest.kml';
testField2 = kmlToInit(testField2, initString);

%testField2 = autoFieldSize(testField2);
plotField(testField2)
testField2 = visibilityMatrix(testField2)
plotVisibilityGraph(testField2)




%% Look at a KML with points:
fileNameStr3 = 'testKmlWithPoints.kml';
[D,E,F] = read_kml(fileNameStr3);
G = [D,E]



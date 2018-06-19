%% Get waypoints from OptimalPath Cell Array


%% THIS FUNCTION HAS NOW BEEN ROLLED INTO THE A* SEARCH CLASS. 
% Takes the input of an optimal path cell array and puts it in to a [x,y]
% coordinate frame.

function coordList = coordsFromOptimalPath(optimalPathCellArray)
    coordList = cell2mat( optimalPathCellArray(:, 2) )
end
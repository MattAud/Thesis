%% A Star Search Class for a Visibility Matrix Function
% By Matt Audette
% Last updated 20180602
%
% Take in a visibility matrix that was previously created (example below,
% see my "obstacle class" as well) and returns a list of points that are
% the shortest path. 
%
% Inputs: Visibility matrix, 
% cost function flag: 1 for Euclidean distance, 2 for Haversin distance
% 
% To Do:
% - Finish description
% - Error for distance flag: haversine or straigh line distance
% - Add an error flag in the inputted obstacle field doesn't have a
% visibility martix
% - error message to nodeIndextoCellArray function if there's not a 
% - finish the findOptimalPath function

classdef AStarSearch
    properties
        VisibilityMatrix % stores the vis matrix of the input obst field
        nodeIndex % an index that will store the node objects from the vis
                   % matrix, ties in directly to the obst 
                   % field index calls, so that calling the indexNodes(1)
                   % of the AStarSearch will return the same point as the
                   % call pointFromIndex(2) of the obst field
        openList % Standard A* search
        closedList % standard A* search
        costFlag % Which cost function to use: 1= Euclidean, 2= Harversine
        optimalPath % What we are after
        
        obstacleField % Might as well just store the whole field here.
        nodeCellArray % See the explanation below as to why.
        
        %test:
        cellArray
        
    end
    
    methods
        % Constructor method: make an A* Search Function
        function astar = AStarSearch(obstField)
            %The visibility Matrix will 100% transfer:
            astar.VisibilityMatrix = obstField.VisibilityMatrix
            
            astar.obstacleField = obstField;
            
            %pointsToNodes();
        end
        
        function astar = pointsToNodes(astar)
            % Read in each point from the obstacle field into a node
            % object. Then load the node into the indexNodes.
            for i = 1:length(astar.obstacleField.PointIndex)
                holder = node(getPointFromIndex(astar.obstacleField, i));
                holder.index = i;
                
                % load in the initial F values, goal, and init flag:
                % the initial point is stored in the SECOND to last
                % position
                if i == length(astar.obstacleField.PointIndex) - 1
                    holder.initFlag = 1;
                    holder.goalFlag = 0;
                    holder.f = 0;
                    holder.g = 0;
                % the last point in the goal:
                elseif i == length(astar.obstacleField.PointIndex)
                    holder.goalFlag = 1;
                    holder.initFlag = 0;
                    holder.f = 999;
                % all other points have an f of infinity:
                else
                    holder.initFlag = 0;
                    holder.goalFlag = 0;
                    holder.f = 999;
                end

               % And build out the list of neighbors for each node:
               % Go throught he Visib Mat for each point, find all the ones
               % and then take the union of the two matrices. 
               
               %NOTE: this does NOT store the point, but the PointIndex of
               % from the obstacle field! To get the point, you'll have to
               % use the getPointFromIndex() obstacleField function.
               temp1 = find(astar.VisibilityMatrix(i, :) == 1);
               temp2 = find(astar.VisibilityMatrix(:, i) == 1);
               holder.neighbors = union(temp1, temp2);
               
               % Now that we've built out the node, add it to the nodeIndex
               astar.nodeIndex = [astar.nodeIndex; holder];
            end
        end %pointsToNodes
        
        % because I can't figure out how to perform a sort() function on a
        % custom class relaibly, but I can perform one no problem on a cell
        % array, I'm not going to fight it. Here's how to convert the node
        % index into a cell array.
        function astar = nodeIndextoCellArray(astar)
           % Add an error message if theres not a nodeIndex already
           for i = 1:length(astar.nodeIndex)
               node = astar.nodeIndex(i);
               holder = {node.index, node.location, node.f, node.g, node.h, ...
                         node.neighbors, node.cameFrom, node.goalFlag, node.initFlag};
               astar.nodeCellArray = [astar.nodeCellArray; holder];
               
           end
        end
        
%         function astar = cellArrayofNodes(astar)
%             for i = 1:length(astar.nodeIndex)
%                holder = astar.nodeIndex(i);
%                astar.cellArray{i} = holder;
%                
%            end
%         end
        
        %give the index number of the vis matrix/node array, get the node
        %object back
        function node = nodeFromIndex(astar, i)
            node = astar.nodeIndex(i);
            
        end
        
        %get a cell from the index:
        function cell = cellFromIndex(astar, i)
            cell = astar.nodeCellArray(i, :);
            
        end
        
%         function astar = updateCell(astar, idx, cellArrayIn)
%             astar.nodeCellArray(idx, :) = cellArrayIn;
%             
%         end
        
        %This function sets the A* searche's flag. 0 = euclidian, 1 =
        %haversine
        function astar = setCostFlag(astar, flag)
            % add error if int ~= 0 or 1
            astar.costFlag = flag;
        end

        
        function astar = findOptimalPath(astar)
%% FIRST we need to load in the pointsToNodes, nodeIndextoCellArray:
if isempty(astar.nodeIndex) == true
    disp('Converting points to nodes...')
    astar = pointsToNodes(astar)
end

if isempty(astar.nodeCellArray) == true
    disp('Building the cell array...')
    astar = nodeIndextoCellArray(astar)
end

if isempty(astar.costFlag) == true
    disp('No cost flag picked, default is haversine.')
    astar.costFlag = 1
end
%% NOW WE CAN BEGIN



foundIt = 0; %boolean flag 

%get the goal node so that we can calculate distance off of it:
for i = 1:length(astar.nodeIndex)
    if astar.nodeIndex(i).goalFlag == 1
        goalNode = astar.nodeIndex(i)
    end
    
end



% Flag tells the distance function if it is Euclidian distance ( flag == 0)
% or haversine distance (flag == 1)
flag = astar.costFlag;

%initialize the open list:
astar.openList = astar.nodeCellArray;
disp('This is a test node.')
w = astar.openList(2,:)
%While the open list is NOT empty:

while (isempty(astar.openList) == 0 && foundIt == 0)
    
    %sort the open list by lostest F value:
    %The F value is stored in the third column
    disp('+++ Top of the While Loop +++++++++++++++++++++++++++++++++++++')
    disp('sort the list:')
    astar.openList = sortrows(astar.openList, [3,1])

    %the first node is q:
    q = astar.openList(1, :)
    
    %all of q's successors have THEIR parent to to 'q'
    %in the cell array, neighbors are in column 6.
    neighborArray = q{6}
    
    %w{6}
    %get the "parent node" index:
    parentIndex = q{1}
    parentNode = astar.nodeIndex(parentIndex)
    % go through each point in the neighbor array and set their "came from"
    % function to q's index. This will be done in the NODE IDEX.
    for i = 1:length(neighborArray)
        disp('In the loop that updates child nodes to the q index')
        i
        %get the child node's index number from the neighbor array:
        childNode = astar.nodeIndex(neighborArray(i));
        childNode.cameFrom = parentNode.index
        %load it back into the nodeIndex:
        astar.nodeIndex(childNode.index) = childNode;
    end

    disp('Done changing the children nodes "came from" to q.')
    disp('for each successor of q, do the main A* sort algorithm:')
    %For each successor:
    for i = 1:length(neighborArray)
        disp('TOP OF THE FOR (LENGTH OF NEIGHBOR ARRAY)')
        i
        thisNode = astar.nodeIndex(neighborArray(i))
        %If the successor is the goal, STOP the search
        disp('Is this nodes goal flag 1?')
        thisNode.goalFlag
        if thisNode.goalFlag == 1
            disp('Found the goal! Stop here!')
            
            %This should probably change:
            foundIt = 1;
            break      
        else
            disp('This is not the goal.')
            disp('Is this node on the closedList()? If it is, no need to check it.')
            %check the closed list for thisNode. If it's there, no need to
            %consider it.
            onClosedListBool = 0;
            if(length(astar.closedList) > 0) %Have to do this, or on 
                %the first iteration length(aStarTest) = 0 and the loops
                %dont work.
                for i = 1:size(astar.closedList, 1)
                    disp('Compate to the closed list indices:')
                    if thisNode.index == astar.closedList{i,1} && onClosedListBool == 0
                        disp('Its on the closed list. Skip it.')
                        onClosedListBool = 1
                        break
                    else
                        disp('It is NOT ON THE CLOSED LIST.')
                        onClosedListBool = 0
                    end
                end
            end

            %IF it is on the closedList(), don't consider it.
            if(onClosedListBool == 1)
                disp('Since this node is part of our closed list, skip ot.')
            %ELSE: it must, therefore be on the open list.
            else
                disp('This node is NOT on the closed list')
                disp('Therefore, find the G, H, and F values:')
                %Therefore set the successor G, H, and F
                % G:
                %find the distance from the parent:
                distG = getDistance(thisNode.location, parentNode.location, flag)
                %thisNode.g = parentNode.f + distG;
                thisNode.g = q{3} + distG

                % H:
                distH = getDistance(thisNode.location, goalNode.location, flag)
                thisNode.h = distH;

                % F:
                thisNode.f = distH + distG + q{3}
                
                %DOES THIS NODE ALREADY HAVE A LOWER F?
                disp('Does this node already have a lower F? Search openList()')
                %find it's position on the openList():
                for i = 1:size(astar.openList, 1)
                    disp('Compare to the OPEN list indices:')
                    if thisNode.index == astar.openList{i,1}
                        disp('Found this point on the openList index')
                        openListIndex = i
                    end
                end
                %check it's openList().F value:
                disp('Compare the two nodes, make sure that they are the same.')
                astar.openList(openListIndex, :)
                thisNode
                currentFValue = cell2mat(astar.openList(openListIndex, 3) ) % F value is in the 3rd column.
                %IF the openList F is lower than thisNode's calculated F,
                %keep the LOWER (current) F:
                if currentFValue < thisNode.f
                    disp('The node currently has the lower F value. Dont change it.')
                %ELSE load the lower F into the openList() as well as
                %update the nodeIndex
                else
                    disp('This is a new, lower F value. Update the openList and nodeIndex!')
                    %update the nodeIndex:
                    disp(thisNode)
                    astar.nodeIndex(thisNode.index) = thisNode;
%                     disp('%%%%%%%%%%%%%%%%%%%%%% DOES THIS UPDATE?')
                    disp(astar.nodeIndex(thisNode.index))
                    

                    %update the openList():
                    astar.openList{openListIndex, 3} = thisNode.f;
                    astar.openList{openListIndex, 4} = thisNode.g;
                    astar.openList{openListIndex, 5} = thisNode.h;
                    astar.openList{openListIndex, 6} = thisNode.neighbors;
                    astar.openList{openListIndex, 7} = thisNode.cameFrom;
                    astar.openList{openListIndex, :}
                    % update the nodeCellArray:
                    holderCell = astar.openList{openListIndex, :}
%                     aStarFromKML = updateCell(aStarFromKML, thisNode.index, holderCell)
                end %currentFValue < thisNode.f


            end % if(onClosedListBool == 1)

        end % if thisNode.goalFlag == 1



     end %for i = 1:length(neighborArray)

     %put q on the closed list
     disp('put q on the closed list:')
     disp('**********************************************')
     %aStarTest.closedList = {aStarTest.closedList; q}
     newRow = size(astar.closedList, 1) + 1
     for i = 1:length(q)
         astar.closedList{newRow,i} = q{i};
     end
     
     % If we found the goal node up above (foundIt == 1), after we add q,
     % we can add the goal node to the end.
     if foundIt == 1
         lastRow = newRow+1;
         astar.closedList{lastRow,1} = goalNode.index;
         astar.closedList{lastRow,2} = goalNode.location;
         astar.closedList{lastRow,3} = goalNode.f;
         astar.closedList{lastRow,4} = goalNode.g;
         astar.closedList{lastRow,5} = goalNode.h;
         astar.closedList{lastRow,6} = goalNode.neighbors;
         %this changes, so that the goal's "came from" is from the last q.
%          
% 
         astar.closedList{lastRow,7} = thisNode.cameFrom;
         astar.closedList{lastRow,8} = goalNode.goalFlag;
         astar.closedList{lastRow,9} = goalNode.initFlag;
     end
     
     %remove q from the openList:
     disp('The CLOSED LIST is:')
     disp(astar.closedList)

     astar.openList(1,:) = []
     
     disp('The OPEN LIST is')
     disp(astar.openList)
   
end %WHILE
disp('-----------------------------')
disp('-----------------------------')
disp('-----------------------------')
disp('-----------------------------')


%Get the number of columns in the closedList:
closedListLength = size(astar.closedList, 1)
%from that last line, get the last node's index: THIS SHOULD BE THE GOAL
%NODE
closedListLastNodeIndex = astar.closedList(closedListLength, 1)
%^^ That returns a cell, convert it to a number.
closedListLastNodeIndex = cell2mat(closedListLastNodeIndex)
closedListLastNodeLocation = astar.closedList(closedListLength, 2)
closedListLastNodeLocation = cell2mat(closedListLastNodeLocation)

thisNodeIndex = closedListLastNodeIndex
thisNodeLocation = closedListLastNodeLocation
holderArray = []

w = astar.closedList(closedListLength, :)
%This bool will go high if thisNode's initFlag is 1, meaning that we have
%successfully orked backwards from the start.
initNodeBool = 0
optimalPathIndex = 1

%Until we work backwards to the start:
while initNodeBool == 0
    disp('===== top of the while loop')
    % Get this node's location, add it to the optimal path location index:
%     holder = [thisNodeIndex, thisNodeLocation]
%     holderArray = [holderArray; holder]
     newRow = size(astar.optimalPath, 1) + 1
     for i = 1:length(w)
         astar.optimalPath{newRow,i} = w{i};
     end
     
     % is this node the initial position? Check colum w{9}
     initFlag = w{9}
     if initFlag == 1 %it's the initial position, stop it!
         disp('It is the initial position')
         initNodeBool = 1
     else %it's not the initial position.
         disp('its not in initial position.')
         % get the "came from" in column 7:
         cameFromNode = w{7}
         % find THAT node in the closedList stack, make THAT node w.
         for i = 1:size(astar.closedList, 1) %for the # of rows in CL:
             disp('in the for loop')
             i
             %callint the first column on the closedList gets us a cell.
             %Get it and convert it to a number so that we can compare it's
             %value.
             index = cell2mat( astar.closedList(i,1) )
             if(cameFromNode == index)
                 %when these match, we found our "came from" index. Make
                 %that guy w.
                 disp('Found our "came from" index!')
                 disp(astar.closedList(i,:))
                 w = astar.closedList(i,:)
                 break
             end
             
             if i > 25
                 initNodeBool = 1
             end
             
         end % for
         
         
     end %if initFlag == 1
    
    
    
    %initNodeBool = 1
end

%This traces the optimal path from end-to-start. Flip it so that out
%coordinates go from start-to-finish:
astar.optimalPath = flipud(astar.optimalPath)
        end %findOptimalPath
        
        function plotOptimalPath(astar)
            plotVisibilityGraph(astar.obstacleField)
            hold on
            title('Plot of the Optimal Route')
            %The optimalPath that is stored is a bunch of nodes in cell
            %form. This is easy to troubleshoot, garbage to plot.
            %So, holder array is going to pluck the entire second column
            %from optimal path, then convert it to matrix form, and then
            %plot the results.
            holderArray = [];
            for i = 1:size(astar.optimalPath, 1) %for the # of rows
                holder = cell2mat( astar.optimalPath(i,2) );
                holderArray = [holderArray; holder];
            end
            plot(holderArray(:,1), holderArray(:,2), 'g')
%             plot(astar.optimalPath(:, 1), astar.optimalPath(:, 2), 'g')
        end
        
        function coordList = coordsFromOptimalPath(optimalPathCellArray)
            coordList = cell2mat( optimalPathCellArray(:, 2) );
        end
    end % methods
    
end
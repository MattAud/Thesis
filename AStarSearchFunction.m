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
% - Input flag: haversine or straigh line distance
% - 

function [shortestPath] = AStarSearchFunction(visibilityMatrix, costFlag)
{
    indexNodes = [];
    openList = [];
    closedList = [];
    
    % First, build up an index of nodes from the visibility matrix
    for i = 1:length(visibilityMatrix)
        holderNode = visibilityMatri
    
    end
    % Then, initialize the open list will all the nodes
    
    % While (the open list is not empty)
    
  
    % Dummy output:
    shortestPath = [ [1,1]; [2,1]; [3,4] ];
}
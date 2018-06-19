%% Node Class
% By Matt Audette
% Last Update: 20180530
% Remarks: This is a class that will construct Node objects for my A*
% Search Algorithm. It will take in a Visibility Matrix from my Obstacle 

% To Do:
% - Finish Description
% - Error messages if init/goal flags aren't 0 or 1

classdef node
    properties
        index % Will tie directly into the PointIndex of the obst field
        location % Will store the location- will be pulled from the ostac.
                 % field's PointIndex to Location function.
        f % standard f value for A*; f = g + h
        g % The g value
        h % The hueristic h
        neighbors % Will store nodes that are visible- will be pulled from
                  % 1's in the visibility matrix of the obstacle field obj.
        cameFrom % Will store what node it came from- will be chained to 
                 % produce the optimal path
        goalFlag % 1 if the goal, 0 if not
        initFlag % 1 if start point, 0 if not
    end
    
    methods 
        % constructor function: make a node
        function nd = node(XandYPointArray)
            nd.location = [XandYPointArray];
        end

        function nd = setIndex(nd, indx)
            nd.index = indx;
        end

        function nd = setF(nd, input)
            nd.f = input;
        end

        function nd = setG(nd, input)
            nd.g = input;
        end
        
        function nd = setH(nd, input)
            nd.h = input;
        end
        
        %saves the neighbor's indices in an array
        function nd = setNeighbors(nd, inputArray)
            nd.neighbors = [inputArray];
            % This was from when the input was (nd, varargin). 
            % It just didn't make sense since I'm producing the neighbors
            % in an array already.
%             nd.neighbors = [nd.neighbors, varargin{1}];
%             
%             % and if there's more, load them in:
%             if (nargin > 2)
%                 for i = 2:length(varargin)
%                     nd.neighbors = [nd.neighbors, varargin{i}];
%                 end
%             end       
        end
        
        %takes the INDEX of the point it came from and stores it.
        function nd = setCameFrom(nd, indx)
            nd.cameFrom = indx;
        end
        
        % Set to 1 if it's the start point, 0 if otherwise
        function nd = setInitFlag(nd, input)
            nd.initFlag = input;
        end
        
        % Set to 1 if it's the goal point, 0 if otherwise
        function nd = setGoalFlag(nd, input)
            nd.goalFlag = input;
        end
        
        %% Retrieval functions
        % to be added later, if need be
        

    end
    
    %% I'm trying to make it so you just type node.setF(input) and loads it.
    % No dice so far.
%     methods (Static)
%         
%     
%         function nd = setF(input)
%             nd.f = input;
%         end
% 
%         function setG(input)
%             nd.g = input;
%         end
%         
%     end

end
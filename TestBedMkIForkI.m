%% Still in the works: Visibility Matrix:
disp(' ========= test =======')
visibilityMatrix(emptyField)

%Assign the obstacles in a field obstacle numbers:
for j = 1:testField1.NumObstacles
    testField1.Field(j).ObstacleNumber = j
end

disp('This will cycle through an obstacle field and make a Q matrix for each point.')
for j = 1:testField1.NumObstacles
    j
    %Grab the x and y points of the j-th obstacle in the field:
    xpoints = testField1.Field(j).Vertices(:,1)
    ypoints = testField1.Field(j).Vertices(:,2)

    %CYCLES through all points in an obstacle to make a Q matrix
    for i = 1:length(xpoints) 
        if i == length(xpoints) %then i is the last number, load in the first point
            Q = [xpoints(i), xpoints(1); 
                 ypoints(i), ypoints(1)]
        else
            Q = [xpoints(i), xpoints(i+1); 
                 ypoints(i), ypoints(i+1)]
        end
        
        %THIS IS WHERE YOU CHECK FOR INTERSECTION
    end
end

% Get a number of points:
n = 0;
numEntities = 0;
for j = 1:testField1.NumObstacles
    j
    n = n + length(testField1.Field(j).Vertices)
end
numEntities = testField1.NumObstacles;
if(isempty(testField1.qinit) ~= true)
    n = n+1;
    numEntities = numEntities+1;
end
if(isempty(testField1.qgoal) ~= true)
    n = n+1;
    numEntities = numEntities+1;
end

%Counts points in the matrix: give it an obstacle number, and it counts the
%numer of points in all previous obstacles:
onum = 3;
pointCounter = 0;
for i = 1:onum-1
    pointCounter = pointCounter + testField1.Field(i).NumVertices
end



n
numEntities
visibMatrix = ones(n)
%Outer loop: 
% The outer loop will build the line P in the PHI matrix. P consists of two
% points, a and b. P = [ax, bx; ay, by]. Point a should be from the current
% obstacle (number k) and point b should be from the NEXT obstacle.
for k = 1:testField1.NumObstacles %- 1 %needs to become numEntities
    k
     
    if k < testField1.NumObstacles %you can't check the last obstacle
        %Start with obstacle 1, vertex 1 and obstacle 2, vertex 1 for P:
        %% Problem- this will only do the first point in each obstacle
        Pcol1 = testField1.Field(k).Vertices(1,:)'; %point a, column form
        Pcol2 = testField1.Field(k+1).Vertices(1,:)'; %point b, column form
        P = [Pcol1, Pcol2]
    end   
    % Get a Q:
    %Q has points c and d. Q will cycle through ALL lines in the obstacle
    %field, INCLUDING other lines from current obstacle k. 
    
    %Point c will be the first point in the next obstacle k, point d will
    %be the second point in the obstacle.
    
    %After you cycle through all the point in this obstacle, you need to go
    %on to the next obstacle.
    
    %Number of points to test = number of overall points (n) - number of
    %points in current obstacle
    %% This is going to be a problem later- 
    disp('p should equal the number of points in the next obstacle.')
    p =  length(testField1.Field(k).Vertices) 
    %run through all the points in this obstacle:
    for i = 1:p % I think this is right: we want to start at the first vertice 
                % of the next obstacle and then move until the end of the
                % matrix n.
        if i == p %then i is the last number, load in the first point
            Qcol1 = testField1.Field(k).Vertices(i,:)'; 
            Qcol2 = testField1.Field(k).Vertices(1,:)'; %the first point
        else
            Qcol1 = testField1.Field(k).Vertices(i,:)';
            Qcol2 = testField1.Field(k).Vertices(i+1,:)';
        end
        Q = [Qcol1, Qcol2]
        
        %% Now that we have a Q, check for the intersection
        intersect = testIntersection(P(:, 1), P(:, 2), Q(:, 1), Q(:, 2));
        
        %% If intersect is true at an point, break out of the loop.
        % Still got to do that.
        
        if(intersect == true)
            disp('more goes here')
        end

    % Test it for intersection/clear
    % Get a new Q
    % When done with all Qs, exit this loop, get a new P and repeat
        
    end
    
    
    
end

%% Take two:
disp('=========================================')
disp('=========================================')
disp('=========================================')
%Get a P:
%get a pointIndex for the obstacle field:
testField1 = constructPointIndex(testField1);

%counter 'r' is for "row number"
for r = 1:length(testField1.PointIndex)
    
    a = getPointFromIndex(testField1, r)
    % ---------- GOES HERE: Special case -----
    
    %% THis needs work:
        %do this in a for loop. 
        % for counter = numObstacles in a field,
        % k = counter
    %get the obstacle that we are on from a:
    if a <= testField1.Field(1).NumVertices
        k = 1 %the first 4 points are the first obstacle
    elseif a<= testField.Field(2).NumVertices
        k = 2
    else 
        k = 3
    end
    
    %get a 'b': the first point in the NEXT obstacle.
    if k < testField1.NumObstacles %This is becaouse k+1 will eventually 
                                   %leave the obstacle belt index.
        lengthOfNextObst = testField1.Field(k+1).NumVertices
    elseif k == testField1.NumObstacles
        lengthOfNextObst = testField1.Field(k).NumVertices
    end
    
    % Get a b:
    %j starts at the first point in the next obstacle
    for j = testField1.Field(k).NumVertices + 1 : length(testField1.PointIndex) %= 1:lengthOfNextObst
        disp('---- TOP of "for j = 1:lengthOfNextObst')
        j
        bIndex = j + testField1.Field(k).NumVertices %this is the getIndex value.
                    %It'll start at the first point of the SECOND obstacle,
                    %but it's going to keep cycling back to the fifth point
                    %unless I increment counter k to include obstacle 1 and
                    %2 when k = 2.
        b = getPointFromIndex(testField1, bIndex)
        
        %Now that we have P, we need to test it against every edge in the
        %field. These will be our Qs.
        %----------------------------------------------
        disp('we have a new b')
        for jj = 1:testField1.NumObstacles
            disp('---- TOP of "for jj = 1:testField1.NumObstacles"')
            jj
            %Grab the x and y points of the j-th obstacle in the field:
            xpoints = testField1.Field(jj).Vertices(:,1);
            ypoints = testField1.Field(jj).Vertices(:,2);
            
            %CYCLES through all points in an obstacle to make a Q matrix
            for i = 1:length(xpoints)
                disp('---- TOP of "for i = 1:length(xpoints)"')
                if i == length(xpoints) %then i is the last number, load in the first point
%                     Q = [xpoints(i), xpoints(1);
%                         ypoints(i), ypoints(1)]
                      c = [xpoints(i), ypoints(i)]
                      d = [xpoints(1), ypoints(1)]
                else
%                     Q = [xpoints(i), xpoints(i+1);
%                         ypoints(i), ypoints(i+1)]
                      c = [xpoints(i), ypoints(i)]
                      d = [xpoints(i+1), ypoints(i+1)]
                end
                
                %Now that we have a Q, test it for intesrection:
                intersect = testIntersection(a,b,c,d);
                
                %if at any point the intersect == 1, break out of THIS loop
                %and get a new 'b'. Put the results down in the visibility
                %matrix.
                if intersect == 1
                    disp('Intersect is true, break out of the Q loop.')
                    visibMatrix(r,bIndex) = 0
                    break %This break will break us out of getting a new Q.
                          %We can stop that and get a new b at this point.
                          %So we will exit out of this loop and hit this
                          %phrase VVV right down there. THAT break will
                          %kick us back up to getting a new b.
                end
                
            end %Getting Q, testing intersection
            if intersect == 1
                disp('Keep exiting, get a new b.')
                %visibMatrix(r,bIndex) = 0
                break
            end
        end
    end %get a 'b'
    
end %get P

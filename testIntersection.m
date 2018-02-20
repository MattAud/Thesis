%% Intersection
% By Matt Audette
% Last Update: 20180208
% Remarks: This function will take in two lines in the form of four [x,y]
% coordinates. It will then run through the intersection equations and
% return a boolean value of 0 for clear or 1 for intersection.

% Inputs will be four paired x and y coordinates: a, b, c, and d.
% Points a & b will form the first line and c & d the second
% Outputs will be a boolean- 1 for an intersection, 0 for not.

% To Do:
% -still that one case...

function intersectBool = testIntersection(a, b, c, d)

    %% Build PHI and phi:

    % PHI = | bx-ax    cx-dx |  phi = | cx-ax |
    %       | by-ay    cy-dy |        | cy-ay |

    % PHI = [ P(:,2) - P(:,1), Q(:,1)-Q(:,2) ]
    % phi = [ Q(:,1) - P(:,1)]
    PHI = [ b(1) - a(1), c(1) - d(1);
            b(2) - a(2), c(2) - d(2)];
    phi = [ c(1) - a(1);
            c(2) - a(2)];
    
    %% Calculate s & t, determine the case
    % PHI[s;t] = phi ; therefore [s;t] = inv(PHI)phi
    temp = inv(PHI)*phi;
    s = temp(1)
    t = temp(2)
    
    determinant = det(PHI);
    
    %The first filter is if the determinant of PHI. If it is != 0, then the
    %lines either cross or do not cross. If det(PHI) == 0, the lines are
    %parallel.
    if determinant ~= 0 
        % If s&t and both 0 <= x <= 1, then P and Q intersect:
        if ( s > 0 && s < 1 && t > 0 && t < 1)
            intersectBool = 1;
            disp('Hard edge crossing.');

        % if s or t are negative or greater than 1, then P and Q do not intersect:
        elseif( s < 0 || s > 1 || t < 0 || t > 1)
            intersectBool = 0;
            disp('No intersection');

        % Single point of contact cases:
        elseif( t == 1 || t ==0 || s == 1 || s == 0 )
            intersectBool = 0;
            disp('Single point on contact')

        else %catch all clause- 
            disp('Error- this case was not accounted for!')
            intersectBool = 5;

        end
    else %If det(PHI) != 0, the lines are parallel:
        disp('The lines are parallel.')
        %find the specific case for the lines:

        %If point c (and thus, d) are colinear with a and b, the line P
        %contains line Q

        %If the first column of PHI and the column of phi are on the same line,
        %the matrix will be singular (det = 0).
        %Create this matrix:
        stack = [PHI(:,1), phi];
        stackDet = det(stack);

        %% --------------- Attempt to fix the parallel, no overlap, but in line:
        % DOES NOT WORK:
    %     testPHI = [ P(:,2) - P(:,1), Q(:,1) ]
    %     testphi = [ Q(:,1) - P(:,1)]
    %     testtemp = inv(testPHI)*testphi;
    %     tests = testtemp(1)
    %     testt = testtemp(2)
        %------------

        %if temp's det = 0, the lines are Parallel with Infinite overlap
        if stackDet == 0
            disp('And the lines overlap at infinity points.')
            intersectBool = 1;
        %if temp's det ~= 0,  Parallel with NO OVERLAP, 
        %% Problem still: lines are parallel, so not intersect, but are in line. 
        else 
            disp('But the lines do not overlap.')
            intersectBool = 0;
        end
        
%         X = ['P is', P, ' Q is ', Q, ' intersect is ', intersect]
%         disp(X)

end
%% Line Segment Intersection Finder
% By Matt Audette
% Last Update: 20180116
% Remarks: Still need to do the parallel piece

clc
clear all
close all


%% Construct two line segments from the ends points:

% Line segment 1 is P(s). It consists of the start point a (ax, ay) and
% the end point b (bx, by).
a = [2;2]
b = [5;5]
P = [a,b]

% Line segment 2 is Q(t). It consists of the start point c (cx, cy) and
% the end point d (dx, dy).
c = [2;3]
d = [2;2]
Q = [c,d]

%% Plot it:
figure(1)
hold on
grid on
xlim([0, 10])
ylim([0, 10])
Px = P(1,:)
Py = P(2,:)
Qx = Q(1,:)
Qy = Q(2,:)
plot(Px, Py, Qx, Qy)
hold off




%% Calculate s & t:

% PHI = | bx-ax    cx-dx |  phi = | cx-ax |
%       | by-ay    cy-dy |        | cy-ay |
%
% PHI[s;t] = phi ; therefore [s;t] = inv(PHI)phi


PHI = [ P(:,2) - P(:,1), Q(:,1)-Q(:,2) ]
phi = [ Q(:,1) - P(:,1)]


temp = inv(PHI)*phi;
s = temp(1)
t = temp(2)

%% Determine cases for s & t:
% We will return a boolean "intersect" for the cases of s&t.

%find the determinate of PHI: if it is != 0, the lines are not //
determinant = det(PHI)

%% CASES

%The first filter is if the determinant of PHI. If it is != 0, then the
%lines either cross or do not cross. If det(PHI) == 0, the lines are
%parallel.
if determinant ~= 0 
    % If s&t and both 0 <= x <= 1, then P and Q intersect:
    if ( s >= 0 && s < 1 && t > 0 && t < 1)
        intersect = 1
        disp('Hard edge crossing.');

    % if s or t are negative or greater than 1, then P and Q do not intersect:
    elseif( s < 0 || s > 1 || t < 0 || t > 1)
        intersect = 0
        disp('No intersection');

    % Single point of contact cases:
    elseif( t == 1 || t ==0 || s == 1 )
        intersect = 1
        disp('Single point on contact')

    else %catch all clause- 
        disp('Error- this case was not accounted for!')
        intersect = 5

    end
else %If det(PHI) != 0, the lines are parallel:
    disp('The lines are parallel.')
    %find the specific case for the lines:
    
    %If point c (and thus, d) are colinear with a and b, the line P
    %contains line Q
    
    %If the first column of PHI and the column of phi are on the same line,
    %the matrix will be singular (det = 0).
    %Create this matrix:
    stack = [PHI(:,1), phi]
    stackDet = det(stack)
    
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
        intersect = 1
    %if temp's det ~= 0,  Parallel with NO OVERLAP, 
    %% Problem still: lines are parallel, so not intersect, but are in line. 
    else 
        disp('But the lines do not overlap.')
        intersect = 0
    end
    
end 


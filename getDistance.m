%% Find Distance with Flags
% By Matt Audette
% Last updated 20180605
%
% This is used in my A* search pattern
% I need it because during my cost function is calculated by distance
% betweem two nodes. My nodes will either need the Euclidian distance, or
% the arclength distance using the haversine formula. 
%
% Inputs: point1, point2, flag, 
% cost function flag: 1 for Euclidean distance, 2 for Haversin distance
% 
% To Do:
% - Finish description
% - Impliment the haversine  distance
% - 

function dist = getDistance(pt1, pt2, flag)
    switch flag
        case 0
            dist = sqrt( (pt2(1) - pt1(1))^2 + (pt2(2) - pt1(2))^2 );
        case 1
            lat1 = pt1(1);
            long1 = pt1(2);
            lat2 = pt2(1);
            long2 = pt2(2);
            % trig functions want radians:
            lat1r = lat1*pi/180;
            long1r = long1*pi/180;
            lat2r = lat2*pi/180;
            long2r = long2*pi/180;
            r = 6371; %raduis of the earth in meters
            a = sin( (lat2r-lat1r) / 2)^2 + cos(lat1r)*cos(lat2r)*sin( (long2r-long1r)/2 )^2;
            c = 2*atan2(sqrt(a), sqrt(1-a));
            dist = r*c;
        otherwise
            error('The flag must be either 0 for Euclidean or 1 for Harversine.')
    end
end
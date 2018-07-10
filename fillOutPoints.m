function pointArray = fillOutPoints(point1, point2, interval)

    % finding the point on a line a certain distance away ('interval') can
    % be done using vectors. For points p1 = [x1, y1], p2 = [x2, y2],
    % you can find a vector v = [x2-x1, y2-y1] and the normalized form of 
    % v (norm v = ||vector v|| = sqrt( (x2-x1)^2 + (y2-y1)^2 )
    % normalize vector v to give us vector u: u = v/||v||
    % your new point p3 = p1 + interval*u
    
    x1 = point1(1);
    y1 = point1(2);
    
    x2 = point2(1);
    y2 = point2(2);
    
    dist = sqrt( (x2-x1)^2 + (y2-y1)^2 );
    
    v1 = x2-x1;
    v2 = y2-y1;
    v = [v1, v2];
    vNorm = sqrt(v1^2 + v2^2);
    u = v/vNorm;
    
    %
    endIteration = fix(dist/interval);
    
    % dist/interval %Just checking to make sure it's right
    
    pointArray = [point1];
    
    for i = 1:endIteration
        newPoint = point1+interval*i*u;
        pointArray = [pointArray; newPoint];
    end
    
    pointArray = [pointArray; point2];
    
    %add the zero column:
    zeroCol = zeros( size(pointArray, 1) , 1);
    pointArray = [pointArray, zeroCol];
    
    figure(1)
    plot(pointArray(:, 1), pointArray(:, 2), 'b*')
    grid on
end
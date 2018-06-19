%% Potential Field to Waypoint Function
% Matt Audette

% This is a function based off of Calvin Hargadine's thesis script, 
% 'FILENAME.m'. The goal of this is to treat his code like a "black box"
% that mine gloms on to.

% His code initiates the robot and takes in a single waypoint from a user
% prompt. I'm going to make a change that the input comes from a pair of
% points passed from this function.

function potentialFieldToWaypoint( coordinates, goalnum )
%'coordinates' is the [x,y] values that will be the goal.

    % Pioneer 3-AT Localization and Navigation Script

    % Incorporating Potential Field algorithm for navigation and GPS/IMU
    % through Kalman Filter for localization

    %%%% ENSURE ROS MASTER NODE IS STARTED AND MATLAB NODE GENERATED PRIOR TO
    %%%% RUNNING THIS SCRIPT -- USE rosinit

    %% Setup and parameter initialization

    % Create global variables for use in communicating with ROS system
    global Pose
    global Laser
    global Goal
    global NavStatus
    global GPSFix

    % Create ROS publishers, subscribers, and service client
    poseSub = rossubscriber('/geonav_p3odom',@p3atPoseCallback)
    laserSub = rossubscriber('/scan',@p3atLaserCallback)
    cmdPub = rospublisher('/RosAria_Node/cmd_vel','geometry_msgs/Twist')
    goalPub = rospublisher('/nav/goal_odom','nav_msgs/Odometry')
    casePub = rospublisher('/current_case','std_msgs/String')
    goalSub = rossubscriber('/geonav_goalodom',@p3atGoalCallback)
    navstatusSub = rossubscriber('/nav/status',@p3atNavStatusCallback)
    fixSub = rossubscriber('/gps/fix',@p3atGPSFixCallback)
    client = rossvcclient('/reset_kf')

    % Pause for publisher/subscriber registration
    pause(2)

    % Create empty messages for publication
    caseMsg = rosmessage(casePub)
    cmdMsg = rosmessage(cmdPub)
    goalMsg = rosmessage(goalPub)

    % Get parameters and goal information the robot
    [param, sto_goals] = robotConfigReader_multigoal;

    % Ask user for desired goal number
    %goalnum = input('Enter desired WP number (from 1 to 10):');
    %current_goal = goal(goalnum,:);
    current_goal = coordinates;

    % Publish initial goal message for ROS system transform
    for k = 1:5
        goalMsg.Pose.Pose.Position.X = current_goal(1);
        goalMsg.Pose.Pose.Position.Y = current_goal(2);
        goalMsg.Pose.Pose.Orientation.X = 0;
        goalMsg.Pose.Pose.Orientation.Y = 0;
        goalMsg.Pose.Pose.Orientation.Z = 0;
        goalMsg.Pose.Pose.Orientation.W = 1;
        send(goalPub,goalMsg);
        pause(0.1)
    end

    % Get current NavStatus message
    navstatus = NavStatus.Data';

    % Ensure NavStatus is good (2) and if not, reset KF
    if navstatus(1) ~= 2
        call(client)
    else
    end

    % Define parameters for navigation algorithm
    K1 = param(3);              % forward velocity gain
    K2 = param(2);              % turning velocity gain
    maxvel = 3;                 % maximum velocity of robot
    laser_max = 20;             % robot laser view horizon
    goaldist = 0.5;             % distance metric for reaching goal
    goali = 1;                  % current goal index
    xi = param(5);              % attractive force gain
    eta = param(4);             % repulsive force gain
    d = param(1);               % distance above which robot velocity is constant
    rho0 = param(6);            % offset from obstacle to ignore repulsive term
    c = 1;                      % initial case variable
    navrun = 0;                 % navigation fix status variable

    % Define parameters for wall-following algorithm
    angK = 1;                   % turning velocity gain for WF algorithm
    linK = 1;                   % forward velocity gain for WF algorithm
    g_dist = [];                % initialize goal distance
    g_dist0 = [];               % initialize initial goal distance
    Dcount = 0;                 % goal distance counter
    N_Buffer = 20;              % number of measurements used to average repulsive force
    Frep_Buffer = zeros(N_Buffer,1);    % initialize repulsive force buffer

    % Output velocity filter parameters
    Kfilterold = 0.6;           % percentage of old velocity used
    Kfilternew = 0.4;           % percentage of new velocity used
    LinearVel_old = 0.0;        % initialize linear velocity
    AngularVel_old = 0.0;       % initialize angular velocity

    %% Potential Field Algorithm

    while 1                     % Infinite loop until goal is reached
        % publish goal coordinates
        goalMsg.Pose.Pose.Position.X = current_goal(2);
        goalMsg.Pose.Pose.Position.Y = current_goal(1);
        goalMsg.Pose.Pose.Orientation.X = 0;
        goalMsg.Pose.Pose.Orientation.Y = 0;
        goalMsg.Pose.Pose.Orientation.Z = 0;
        goalMsg.Pose.Pose.Orientation.W = 1;
        send(goalPub,goalMsg);

        % get the laser ranges
        laser_range = Laser.Ranges;

        % angular resolution vector
        laser_angle = (Laser.AngleMin:Laser.AngleIncrement:Laser.AngleMax)';

        % get goal coordinates in XY world frame
        q_goal = [Goal.Pose.Pose.Position.X, Goal.Pose.Pose.Position.Y];

        % get current GPS fix
        gpsfix = [GPSFix.Status.Service,GPSFix.Status.Status]

        % get current nav status
        navstatus = NavStatus.Data'

        % if good nav status, set nav status variable
        if navstatus(1) == 2
            navrun = 1;
        else
        end

        % if bad nav status with previous good fix and good GPS fix, reset KF
        if navstatus(1) == 3 && navrun == 1 && gpsfix(2) == 30
            call(client)
            navrun = 0;
        else
        end

        % switch/case for algorithm decision logic
        switch c
            case 1              % Potential Field Algorithm
                fprintf('Potential Field\n')
                caseMsg.Data = 'Potential Field';   % publish current case to ROS
                send(casePub,caseMsg)

                % get X, Y and Theta
                pose = Pose.Pose.Pose;
                quat = pose.Orientation;
                angles = quat2eul([quat.W quat.X quat.Y quat.Z]);
                yaw = angles(1);
                x = pose.Position.X;
                y = pose.Position.Y;
                th = yaw;

                fprintf('X: %f, Y: %f, Theta: %f \n',x,y,th);

                % call the attractive force function
                wp_x = q_goal(goali,1);
                wp_y = q_goal(goali,2);
                [dist, angvel, linvel] = attforcepot(x,y,th,wp_x,wp_y);

                % evaluate what to do next based on the distance to the waypoint.
                if (dist <= goaldist)
                    % if you have reached the goal
                    if (goali < size(q_goal,1))
                        % if there are multiple goals
                        disp('Going to next waypoint!');
                        goali = goali+1;
                    else
                        % if there is a single goal
                        fprintf('WP #%d at x: %f, y: %f, Distance: %f\n',goalnum,wp_x,wp_y,dist);
                        cmdMsg.Linear.X = 0.0;
                        cmdMsg.Angular.Z = 0.0;
                        fprintf('Publishing cmd_vel with lin. vel: %f, ang. vel.: %f\n', ...
                            0.0,0.0);
                        send(cmdPub,cmdMsg);
                        disp('Done!')
                        break;      % exit while loop as final goal is reached
                    end
                else
                    % goal not yet reached
                    fprintf('WP #%d at x: %f, y: %f, Distance: %f\n',goalnum,wp_x,wp_y,dist);
                    if (dist <= d)
                        goalvelx = linvel;
                        goalvelw = angvel;
                    else
                        goalvelx = maxvel;
                        goalvelw = angvel;
                    end
                end

                pause(0.1)          % pause for ROS system

                Frept = [0;0];      % initialize repulsive force

                for i = 1:1032
                    if laser_range(i) <= laser_max
                        % object position in the laser i coordinate in meters
                        p_laser = [laser_range(i) 0 0 1]';
                        Xobj = cos(laser_angle(i))*p_laser(1);
                        Yobj = sin(laser_angle(i))*p_laser(1);
                        rho = sqrt(Xobj^2+Yobj^2);
                        if rho < rho0
                            Frep = eta*(1/p_laser(1)-1/rho0)*(1/(p_laser(1)^2))*[-cos(laser_angle(i)) -sin(laser_angle(i))]';
                        else
                            Frep = [0;0];
                        end
                        Frept = Frept+Frep;
                    else
                    end
                end

                Frep_Buffer = [Frept(2); Frep_Buffer(2:N_Buffer-1)];
                MeanBuffer = mean(Frep_Buffer);

                % calculate total force and build velocity terms
                Fatt = [goalvelx;goalvelw];
                Ftot = xi*Fatt + eta*Frept;
                fprintf('\n\nNorm of Ftot: %f\n',norm(Ftot));
                LinearVel = K1*Ftot(1);
                AngularVel = K2*Ftot(2);

                % determine which case to enter next
                if min(laser_range) < 0.5
                    c = 3;
                elseif norm(Ftot) < 0.5 && dist > 1
                    c = 2;
                    g_dist0 = dist;
                    g_dist = dist;
                else
                    c = 1;
                end

            case 2              % Wall-Following Algorithm
                fprintf('\nWall Following\n\n')
                caseMsg.Data = 'Wall Following';    % publish current case to ROS
                send(casePub,caseMsg)

                % get X, Y and Theta
                pose = Pose.Pose.Pose;
                quat = pose.Orientation;
                angles = quat2eul([quat.W quat.X quat.Y quat.Z]);
                yaw = angles(1);
                x = pose.Position.X;
                y = pose.Position.Y;
                th = yaw;

                fprintf('X: %f, Y: %f, Theta: %f \n',x,y,th);

                % call the attractive force function
                wp_x = q_goal(goali,1);
                wp_y = q_goal(goali,2);
                [dist, angvel, linvel] = attforcepot(x,y,th,wp_x,wp_y);
                pause(0.1)

                % if closer to the goal than last time, increment DD
                if dist < g_dist
                    Dcount = Dcount + 1
                else
                end

                g_dist = dist;

                Frept = [0;0];      % initialize repulsive force

                for i = 1:1032
                    if laser_range(i) <= laser_max
                        % object position in the laser i coordinate in meters
                        p_laser = [laser_range(i) 0 0 1]';
                        Xobj = cos(laser_angle(i))*p_laser(1);
                        Yobj = sin(laser_angle(i))*p_laser(1);
                        rho = sqrt(Xobj^2+Yobj^2);
                        if rho < rho0
                            Frep = eta*(1/p_laser(1)-1/rho0)*(1/(p_laser(1)^2))*[-cos(laser_angle(i)) -sin(laser_angle(i))]';
                        else
                            Frep = [0;0];
                        end
                        Frept = Frept+Frep;
                    else
                    end
                end

                % determine angle to the repulsive force vector
                objang = atan2(Frept(2),Frept(1));
                if objang < 0
                    objang = objang + 2*pi;
                else
                end

                objangdeg = objang*180/pi

                % determine which way to turn and keep repulsive force vector
                % perpendicular with robot heading
                if MeanBuffer > 0
                    if objangdeg >= 100
                        angvel = angK*0.4;
                        linvel = linK*0.05;
                    elseif objangdeg < 80
                        angvel = -angK*0.4;
                        linvel = linK*0.05;
                    else
                        angvel = 0.0;
                        linvel = 0.3;
                    end
                elseif MeanBuffer < 0
                    if objangdeg < 260
                        angvel = -angK*0.4;
                        linvel = linK*0.05;
                    elseif objangdeg > 280
                        angvel = angK*0.4;
                        linvel = linK*0.05;
                    else
                        angvel = 0.0;
                        linvel = 0.3;
                    end
                end

                % develop output velocities
                LinearVel = linvel;
                AngularVel = angvel;

                % determine which case to enter next
                if min(laser_range) < 0.5
                    c = 4;
                elseif Dcount == 70
                    c = 1;
                    g_dist = [];
                    Dcount = 0;
                    Frep_Buffer = zeros(N_Buffer,1);
                else
                    c = 2;
                end

            case 3              % Emergency Avoidance Algorithm (From Potential Field)
                ii = 0;
                while ii < 5
                    % stop immediately for 5 seconds
                    fprintf('Emergency Avoidance\n')
                    caseMsg.Data = 'Emergency Avoidance (PF)';
                    send(casePub,caseMsg)
                    % populate the message
                    fprintf('WP #%d at x: %f, y: %f, Distance: %f\n',goalnum,wp_x,wp_y,dist);
                    cmdMsg.Linear.X = 0.0;
                    cmdMsg.Angular.Z = 0.0;
                    % publish message
                    fprintf('Publishing cmd_vel with lin. vel: %f, ang. vel.: %f\n', ...
                        0.0,0.0);
                    send(cmdPub,cmdMsg);
                    pause(0.2)
                    ii = ii + 0.2;
                end
                jj = 0;
                while jj < 4
                    % backup for 4 seconds to make enough room to maneuver
                    % around obstacle
                    caseMsg.Data = 'Emergency Avoidance (PF)';
                    send(casePub,caseMsg)
                    fprintf('WP #%d at x: %f, y: %f, Distance: %f\n',goalnum,wp_x,wp_y,dist);
                    cmdMsg.Linear.X = -0.2;
                    cmdMsg.Angular.Z = 0.0;
                    % publish
                    fprintf('Publishing cmd_vel with lin. vel: %f, ang. vel.: %f\n', ...
                        0.0,0.0);
                    send(cmdPub,cmdMsg);
                    pause(0.2);
                    jj = jj + 0.2;
                end

                % get the laser ranges
                laser_range = Laser.Ranges;

                % determine if obstacle is out of minimum range parameter
                if min(laser_range) < 0.5
                    c = 3;
                else
                    c = 1;
                end

            case 4              % Emergency Avoidance Algorithm (From Wall Following)
                ii = 0;
                while ii < 5
                    % stop immediately for 5 seconds
                    fprintf('Emergency Avoidance\n')
                    caseMsg.Data = 'Emergency Avoidance (WF)';
                    send(casePub,caseMsg)
                    % populate the twist message
                    fprintf('WP #%d at x: %f, y: %f, Distance: %f\n',goalnum,wp_x,wp_y,dist);
                    cmdMsg.Linear.X = 0.0;
                    cmdMsg.Angular.Z = 0.0;
                    % publish
                    fprintf('Publishing cmd_vel with lin. vel: %f, ang. vel.: %f\n', ...
                        0.0,0.0);
                    send(cmdPub,cmdMsg);
                    pause(0.2)
                    ii = ii + 0.2;
                end
                jj = 0;
                while jj < 4
                    % backup for 4 seconds to make enough room to maneuver
                    % around obstacle
                    caseMsg.Data = 'Emergency Avoidance (WF)';
                    send(casePub,caseMsg)
                    fprintf('WP #%d at x: %f, y: %f, Distance: %f\n',goalnum,wp_x,wp_y,dist);
                    cmdMsg.Linear.X = -0.2;
                    cmdMsg.Angular.Z = 0.0;
                    % publish
                    fprintf('Publishing cmd_vel with lin. vel: %f, ang. vel.: %f\n', ...
                        0.0,0.0);
                    send(cmdPub,cmdMsg);
                    pause(0.2);
                    jj = jj + 0.2;
                end

                % get the laser ranges
                laser_range = Laser.Ranges;

                % determine if obstacle is out of minimum range parameter
                if min(laser_range) < 0.5
                    c = 3;
                else
                    c = 2;
                end

            otherwise
        end

        % build filtered output velocity parameters
        cmdMsg.Linear.X = Kfilternew*LinearVel + Kfilterold*LinearVel_old;
        cmdMsg.Angular.Z = Kfilternew*AngularVel + Kfilterold*AngularVel_old;

        % publish on cmd_vel topic
        fprintf('Publishing cmd_vel with lin. vel: %f, ang. vel.: %f\n', ...
            cmdMsg.Linear.X,cmdMsg.Angular.Z);
        send(cmdPub,cmdMsg);

        LinearVel_old = cmdMsg.Linear.X;
        AngularVel_old = cmdMsg.Angular.Z;

    end



end
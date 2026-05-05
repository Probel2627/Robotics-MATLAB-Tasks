clear; clc; close all;

% 1. Connection to RoboDK
try
    RDK = Robolink;
    % Leave empty as requested; RoboDK will use the first available robot
    robot = RDK.Item('', RDK.ITEM_TYPE_ROBOT);
    
    if ~robot.Valid()
        error('No robot found in RoboDK! Please load ABB IRB 4400.');
    end
    disp('RoboDK: Connection established');
catch
    error('RoboDK error: ensure the application is running.');
end

% 2. Joystick connection
try
    joy = vrjoystick(1);
    disp('Joystick: Connected');
catch
    error('Joystick: Not found.');
end

% Initial joints configuration
q = [0, 0, 0, 0, 0, 0]; 
speed = 1.5; 

% Terminal Instructions (Xbox)
fprintf('\n=====================================================\n');
fprintf('ABB IRB 4400 CONTROL (Xbox Controller):\n');
fprintf('  L-Stick (Axes 1, 2) -> Joints 1, 2\n');
fprintf('  R-Stick (Axes 4, 5) -> Joints 3, 4\n');
fprintf('  LB/RB (Buttons 5, 6) -> Joint 5\n');
fprintf('  Button 3 (X) / Button 4 (Y) -> Joint 6\n');
fprintf('  Button 2 (B)         -> HOME POSITION (Reset)\n');
fprintf('  Button 1 (A)         -> EXIT PROGRAM\n');
fprintf('=====================================================\n');

figure('Name', 'ABB IRB 4400 Digital Twin', 'Color', [0.1 0.1 0.1]);

while true
    axes_data = read(joy);
    btns      = button(joy);
    
    % EXIT (Button A)
    if btns(1), break; end 
    
    % HOME POSITION (Button B)
    if btns(2)
        q = [0, 0, 0, 0, 0, 0];
        fprintf('Returning to Home position...\n');
    end
    
    % Axis movement logic
    if abs(axes_data(1)) > 0.15, q(1) = q(1) + axes_data(1) * speed; end
    if abs(axes_data(2)) > 0.15, q(2) = q(2) + axes_data(2) * speed; end
    if abs(axes_data(4)) > 0.15, q(3) = q(3) + axes_data(4) * speed; end
    if abs(axes_data(5)) > 0.15, q(4) = q(4) + axes_data(5) * speed; end
    
    % Wrist controls
    if btns(5), q(5) = q(5) - speed; end
    if btns(6), q(5) = q(5) + speed; end
    if btns(3), q(6) = q(6) - speed; end % Button X
    if btns(4), q(6) = q(6) + speed; end % Button Y

    % Synchronous update of MATLAB and RoboDK
    [T_flange, ~] = ABB_IRB4400(q(1), q(2), q(3), q(4), q(5), q(6));
    robot.setJoints(q); 
    
    drawnow;
    pause(0.01);
end

close(joy);
disp('Program terminated.');
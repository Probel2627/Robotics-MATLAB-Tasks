clear; clc; close all;

try
    RDK = Robolink;
    robot = RDK.Item('UR3', RDK.ITEM_TYPE_ROBOT);
    
    if ~robot.Valid()
        error('Robot "UR3" not found! Check the name in RoboDK tree.');
    end
    disp('RoboDK: Connection established (UR3)');
catch
    error('RoboDK error: ensure RoboDK is running and the robot is added.');
end

try
    joy = vrjoystick(1);
    disp('Joystick: Connected');
catch
    error('Joystick: Not found.');
end

q = [0, -90, -90, -90, 90, 0]; 
is_frozen = false;
deadzone  = 0.15;
speed     = 1.5; 

disp('=====================================================');
disp('UR3 DIGITAL TWIN CONTROL (NO TOOL):');
disp('  L-Stick (Axes 1, 2) -> Joints 1, 2');
disp('  R-Stick (Axes 4, 5) -> Joints 3, 4');
disp('  Buttons 5, 6 (LB/RB) -> Joint 5');
disp('  Buttons 3, 4 -> Joint 6');
disp('  Start (8) -> HOME | Button 10 -> FREEZE');
disp('=====================================================');

figure('Name', 'UR3 Digital Twin Control', 'Color', [0.1 0.1 0.1]);

while true
    axes_data = read(joy);
    btns      = button(joy);
    
    if btns(1), break; end 
    
    if btns(8) 
        q = [0, -90, -90, -90, 90, 0]; 
        disp('Status: Returning to Home position');
        pause(0.2);
    end
    
    if btns(10)
        is_frozen = ~is_frozen;
        if is_frozen, disp('Status: Frozen'); else, disp('Status: Active'); end
        pause(0.3);
    end
    
    if ~is_frozen
        if abs(axes_data(1)) > deadzone, q(1) = q(1) + axes_data(1) * speed; end
        if abs(axes_data(2)) > deadzone, q(2) = q(2) + axes_data(2) * speed; end
        if abs(axes_data(4)) > deadzone, q(3) = q(3) + axes_data(4) * speed; end
        if abs(axes_data(5)) > deadzone, q(4) = q(4) + axes_data(5) * speed; end
        
        if btns(5), q(5) = q(5) - speed; end
        if btns(6), q(5) = q(5) + speed; end
        if btns(3), q(6) = q(6) - speed; end
        if btns(4), q(6) = q(6) + speed; end 
    end
    
    cla;
    % Capture both outputs to avoid "Unrecognized variable" error
    [T_flange, T_tcp] = UR3(q(1), q(2), q(3), q(4), q(5), q(6));
    
    robot.setJoints(q); 
    
    clc;
    fprintf('--- UR3 STATUS ---\n');
    fprintf('Joints [deg]: [%.1f, %.1f, %.1f, %.1f, %.1f, %.1f]\n', q);
    % Since the tool is removed, TCP now represents the Flange position
    fprintf('Flange Pos [m]: X: %.3f, Y: %.3f, Z: %.3f\n', T_flange(1,4), T_flange(2,4), T_flange(3,4));
    
    drawnow;
    pause(0.01);
end

close(joy);
disp('Program terminated.');
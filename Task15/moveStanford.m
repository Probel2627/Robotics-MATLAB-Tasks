% --- STANFORD ARM FULL 6-DOF CONTROLLER ---
% Controls:
% Stick X/Y:     Base (Theta 1) & Shoulder (Theta 2)
% Stick R-Axis:  Reach Extension (d3)
% Buttons 5/6:   Wrist Roll (Theta 4)
% Buttons 3/4:   Wrist Pitch (Theta 5)
% Buttons 7/8:   Wrist Twist (Theta 6)
% Button 1 (A):  EXIT
% Button 2 (B):  HOME RESET

% Horizontal home position
HOME_Q = [0, 0, 500, 0, 0, 0]; 
q = HOME_Q;
speed = 3; % Speed for rotation
p_speed = 15; % Speed for prismatic joint

try
    joy = vrjoystick(1);
    fprintf('\n==========================================\n');
    fprintf('   FULL 6-AXIS STANFORD ARM CONTROL      \n');
    fprintf('==========================================\n');
    fprintf('  - [A] Button 1: Exit\n');
    fprintf('  - [B] Button 2: Home Reset\n');
    fprintf('  - Major Joints: Stick Axes 1, 2, 4\n');
    fprintf('  - Wrist Joints: Buttons 3-8\n');
    fprintf('==========================================\n');
catch
    error('Controller Error: Check your joystick connection.');
end

h_fig = figure('Name', 'Stanford Arm - Full 6 DOF', 'Color', [0.1 0.1 0.1]);

while ishandle(h_fig)
    joy_axes = read(joy);
    joy_btns = button(joy);
    
    % --- System Controls ---
    if joy_btns(1), break; end % Exit[cite: 4]
    if joy_btns(2), q = HOME_Q; disp('System Reset to Home'); end % Home[cite: 4]
    
    % --- Major Axes (Sticks) ---
    q(1) = q(1) + joy_axes(1) * speed; % Base
    q(2) = q(2) - joy_axes(2) * speed; % Shoulder Tilt
    q(3) = q(3) - joy_axes(4) * p_speed; % Extension (Prismatic)[cite: 4]
    
    % --- Wrist Axes (Buttons) ---
    % Theta 4 (Roll)
    if joy_btns(5), q(4) = q(4) - speed; end
    if joy_btns(6), q(4) = q(4) + speed; end
    
    % Theta 5 (Pitch)
    if joy_btns(3), q(5) = q(5) - speed; end
    if joy_btns(4), q(5) = q(5) + speed; end
    
    % Theta 6 (Twist)
    if joy_btns(7), q(6) = q(6) - speed; end
    if joy_btns(8), q(6) = q(6) + speed; end

    % Constraints for d3 (min 200, max 1100)
    q(3) = max(200, min(q(3), 1100));

    % Rendering
    cla;
    stanford(q);
    
    drawnow;
    pause(0.01);
end
fprintf('Control terminated.\n');
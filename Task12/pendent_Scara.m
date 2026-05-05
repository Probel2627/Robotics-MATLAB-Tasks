clear; clc; close all;

% --- Параметры робота ---
L1 = 0.425; 
L2 = 0.375; 
theta1 = 0;   
theta2 = 0;   
d3     = 0.1; 
theta4 = 0;   

% --- Настройки управления ---
speed_theta = 0.05; 
speed_d3    = 0.01; 
deadzone    = 0.15; 
is_frozen   = false; 

try
    joy = vrjoystick(1);
    disp('Teach Pendant Connected');
catch
    error('Joystick not found. Check connection.');
end

fig = figure('Name', 'SCARA Teach Pendant - Task 12', 'NumberTitle', 'off');
fig.Position = [100, 100, 800, 600];

disp('===============================================');
disp('TEACH PENDANT CONTROLS:');
disp('  Left Stick      -> Joints 1 & 2');
disp('  Right Stick     -> Joint 3 (Up/Down) & Joint 4');
disp('  Button 5 (LB)   -> FREEZE/UNFREEZE Motion');
disp('  Button 8 (Start)-> RESET to HOME (0,0,0,0)');
disp('  Button 1 (A)    -> EXIT');
disp('===============================================');

is_running = true;
while is_running

    axes_data = read(joy);
    buttons   = button(joy);
    
    if buttons(1) == 1
        disp('Program Terminated');
        is_running = false;
        continue;
    end
    
    if buttons(5) == 1
        is_frozen = ~is_frozen;
        if is_frozen
            disp('MOTION FROZEN (Safety Lock On)');
        else
            disp('MOTION ACTIVE (Safety Lock Off)');
        end
        pause(0.3);
    end
   
    if buttons(8) == 1
        theta1 = 0; theta2 = 0; d3 = 0.1; theta4 = 0;
        disp('Resetting to Home Position...');
        pause(0.2);
    end
   
    if ~is_frozen
        
        for i = 1:length(axes_data)
            if abs(axes_data(i)) < deadzone
                axes_data(i) = 0;
            end
        end
       
        theta1 = theta1 + axes_data(1) * speed_theta;
        theta2 = theta2 + axes_data(2) * speed_theta;
        
        d3 = d3 + axes_data(5) * speed_d3; 
        if d3 < 0; d3 = 0; end
        if d3 > 0.3; d3 = 0.3; end
        
        theta4 = theta4 + axes_data(4) * speed_theta;
    end
    
    Scara(theta1, theta2, d3, theta4, L1, L2);
    
    drawnow; 
    pause(0.02); 
end

close(joy);
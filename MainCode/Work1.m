close all; clear; clc;

figure;
view(3);
limit = 20;
xlim([-limit, limit]); ylim([-limit, limit]); zlim([-limit, limit]);
grid on; hold on;
xlabel('X'); ylabel('Y'); zlabel('Z');
title('Task 8: Incremental Velocity Control (Xbox Controller)');

my_box = create_mobile_frame(); 

%Connecting joystick, by pressing B exit from manipulation
joy = sim3d.io.Joystick();

while ishandle(my_box)
    
    % Reading data from joystick
    [axes_data, buttons, ~] = read(joy);
    stick_X = axes_data(1); 
    delta = 0;

    if stick_X > -0.15 && stick_X < 0.15
        delta = 0;
        
    % MovingRight
    elseif stick_X >= 0.15 && stick_X < 0.5
        delta = 0.5;  % Slow
    elseif stick_X >= 0.5 && stick_X < 0.9
        delta = 1.0;  % Mid
    elseif stick_X >= 0.9
        delta = 2.0;  % Fast
        
    %MovingLeft
    elseif stick_X <= -0.15 && stick_X > -0.5
        delta = -0.5; % Slow
    elseif stick_X <= -0.5 && stick_X > -0.9
        delta = -1.0; % Mid
    elseif stick_X <= -0.9
        delta = -2.0; % Fast
    end
    
    if delta ~= 0
        % Moving by axis where 'delta' is writed here ↓
        T_step = makehgtform('translate', [delta, 0, 0]);
        
        % Updating view, multiplying on left cause we are moving by XYZ axis
        my_box.Matrix = T_step * my_box.Matrix; 
    end

    %Button Exit
    if buttons(2) == 1 
        disp('Exit from manipulation by joystick');
        close all; clear; clc;
        break;
    end
    
    drawnow;
    pause(0.05); 
end
clear; clc; close all;

try
    joy = vrjoystick(1);
catch
    error('Gamepad not found');
end

figure('Name', 'Task 8: Velocity Control', 'NumberTitle', 'off', 'Color', 'w');
view(135, 30);
grid on; hold on;
axis([-30 30 -30 30 -30 30]);
xlabel('X'); ylabel('Y'); zlabel('Z');

Lines;

mobile_obj = create_mobile_frame();

x_pos = 0;
y_pos = 0;
z_pos = 0;

while true
    [axes_data, buttons, ~] = read(joy);
    
    if buttons(2) == 1
        disp('Control terminated');
        break;
    end
    
    joyX = -axes_data(1);
    joyY = axes_data(2); 
    joyZ = -axes_data(5); 

    if joyX > 0.8
        dX = 1.0;
    elseif joyX > 0.4
        dX = 0.5;
    elseif joyX > 0.15
        dX = 0.1;
    elseif joyX < -0.8
        dX = -1.0;
    elseif joyX < -0.4
        dX = -0.5;
    elseif joyX < -0.15
        dX = -0.1;
    else
        dX = 0;
    end

    if joyY > 0.8
        dY = 1.0;
    elseif joyY > 0.4
        dY = 0.5;
    elseif joyY > 0.15
        dY = 0.1;
    elseif joyY < -0.8
        dY = -1.0;
    elseif joyY < -0.4
        dY = -0.5;
    elseif joyY < -0.15
        dY = -0.1;
    else
        dY = 0;
    end

    if joyZ > 0.8
        dZ = 1.0;
    elseif joyZ > 0.4
        dZ = 0.5;
    elseif joyZ > 0.15
        dZ = 0.1;
    elseif joyZ < -0.8
        dZ = -1.0;
    elseif joyZ < -0.4
        dZ = -0.5;
    elseif joyZ < -0.15
        dZ = -0.1;
    else
        dZ = 0;
    end

    x_pos = x_pos + dX;
    y_pos = y_pos + dY;
    z_pos = z_pos + dZ;

    T_trans = makehgtform('translate', [x_pos, y_pos, z_pos]);

    T_scale = makehgtform('scale', 3);

    mobile_obj.Matrix = T_trans * T_scale;
    
    drawnow;
    pause(0.02);
end
clear; clc; close all;

L1 = 0.425; 
L2 = 0.375; 

theta1 = 0;   
theta2 = 0;   
d3     = 0.1; 
theta4 = 0;   

speed_theta = 0.05; 
speed_d3    = 0.01; 

try
    joy = vrjoystick(1);
    disp('✅ Joystick connected');
catch
    error('❌ Check connection and try again');
end

% Создаем окно графика (немного увеличим его для красоты)
fig = figure('Name', 'SCARA Task11', 'NumberTitle', 'off');
fig.Position = [100, 100, 800, 600];

disp('===================================');
disp('Movement:');
disp('  Left joystick -> joint1 (t1) / joint2 (t2)');
disp('  Right joystick -> joint4 (t4) / joint3 (d3)');
disp('  Button A to exit');
disp('===================================');

is_running = true;

while is_running
   
    axes_data = read(joy);
    buttons   = button(joy);
    
    if buttons(1) == 1
        disp('Exit');
        is_running = false;
        continue;
    end
   
    deadzone = 0.15;
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
    
    Scara(theta1, theta2, d3, theta4, L1, L2);
    
    drawnow; 
    
    pause(0.02); 
end

close(joy);

clear; clc; close all;

try
    joy = sim3d.io.Joystick(); 
catch
    joy = vrjoystick(1); % Запасной вариант для разных версий
end

figure('Color', 'w', 'Name', 'Task 10: PPP & RPP Control');
view(135, 30); grid on; hold on;
axis([-20 20 -20 20 -5 20]);
xlabel('X'); ylabel('Y'); zlabel('Z');

% Создаем оси ОДИН РАЗ и не удаляем их
f1 = create_mobile_frame(); f2 = create_mobile_frame();
f3 = create_mobile_frame(); f4 = create_mobile_frame();
all_frames = [f1 f2 f3 f4];

d1 = 0; d2 = 0; d3 = 0; theta1 = 0;
mode = 1; 

while true
    [axes_data, buttons, ~] = read(joy);
    
    % Переключаем режим без полной очистки окна (убрали cla)
    if buttons(1) == 1, mode = 1; end 
    if buttons(2) == 1, mode = 2; end 
    if buttons(8) == 1, break; end         

    valX = -axes_data(1);
    valY = -axes_data(2);
    valZ = -axes_data(5);

    % Мертвая зона
    if abs(valX) < 0.15, valX = 0; end
    if abs(valY) < 0.15, valY = 0; end
    if abs(valZ) < 0.15, valZ = 0; end

    % Удаляем только старые линии (кости робота), не трогая оси
    delete(findobj(gca, 'Type', 'line'));

    if mode == 1
        d1 = d1 + valX * 0.5;
        d2 = d2 + valY * 0.5;
        d3 = d3 + valZ * 0.5;
        PPP(d1, d2, d3, all_frames);
    else
        theta1 = theta1 + valX * 2;
        d2 = d2 + valY * 0.5;
        d3 = d3 + valZ * 0.5;
        RPP(theta1, d2, d3, all_frames);
    end

    drawnow;
    pause(0.02);
end
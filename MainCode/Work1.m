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
        
    % 2. Движение ВПЕРЕД (Вправо по стику)
    elseif stick_X >= 0.15 && stick_X < 0.5
        delta = 0.5;  % 1-я скорость (Медленно)
    elseif stick_X >= 0.5 && stick_X < 0.9
        delta = 1.0;  % 2-я скорость (Средне)
    elseif stick_X >= 0.9
        delta = 2.0;  % 3-я скорость (Быстро)
        
    % 3. Движение НАЗАД (Влево по стику)
    elseif stick_X <= -0.15 && stick_X > -0.5
        delta = -0.5; % 1-я скорость (Медленно назад)
    elseif stick_X <= -0.5 && stick_X > -0.9
        delta = -1.0; % 2-я скорость (Средне назад)
    elseif stick_X <= -0.9
        delta = -2.0; % 3-я скорость (Быстро назад)
    end
    
    % --- ПРИМЕНЕНИЕ СКОРОСТИ (Accumulation) ---
    if delta ~= 0
        % Создаем матрицу сдвига на величину delta по оси X
        T_step = makehgtform('translate', [delta, 0, 0]);
        
        % Инкрементное обновление: x_new = x_old + delta
        % Умножаем СЛЕВА для движения по глобальной оси X
        my_box.Matrix = T_step * my_box.Matrix; 
    end
    
    % Выход из программы по кнопке
    if buttons(2) == 1 
        disp('Exit from manipulation by joystick');
        break;
    end
    
    % Обновляем графику и задаем частоту кадров (стабильный цикл)
    drawnow;
    pause(0.05); 
end
close all; clear; clc;

% --- 1. ПОДКЛЮЧЕНИЕ К ROBODK ---
disp('Подключение к RoboDK...');
RDK = Robolink();
robot = RDK.Item('', RDK.ITEM_TYPE_ROBOT);

if ~robot.Valid()
    error('Робот не найден! Добавь робота в сцену RoboDK.');
end
disp(['Робот подключен: ', robot.Name()]);

% --- 2. НАСТРОЙКА ГРАФИКИ В MATLAB ---
% Создаем 3D окно для отображения
figure('Name', 'Live TCP Tracker', 'Color', 'w');
view(3); grid on; hold on;
% Роботы большие (в миллиметрах), поэтому ставим лимиты графика по 1 метру
axis([-800 800 -800 800 -200 800]); 
xlabel('X (мм)'); ylabel('Y (мм)'); zlabel('Z (мм)');
title('Синхронизация инструмента (TCP) робота и MATLAB');

% ИСПОЛЬЗУЕМ ТВОЮ ФУНКЦИЮ из прошлых задач!
% Создаем подвижные оси координат в MATLAB
tcp_frame = create_mobile_frame(); 

% --- 3. ПОДКЛЮЧЕНИЕ ГЕЙМПАДА ---
try
    joy = sim3d.io.Joystick(); 
catch
    joy = vrjoystick(1);
end

disp('--- УПРАВЛЕНИЕ ---');
disp('Левый стик (X/Y) -> Суставы 1 и 2');
disp('Правый стик (X/Y) -> Суставы 4 (кисть) и 3 (вверх-вниз)');
disp('Кнопка B -> Выход');

speed_j1 = 2.0; 
speed_j2 = 2.0; 
speed_j3 = 5.0; % мм
speed_j4 = 4.0; 
dead_zone = 0.15;

% --- 4. ГЛАВНЫЙ ЦИКЛ ---
while true
    [axes_data, buttons, ~] = read(joy);
    
    if buttons(2) == 1
        disp('Управление завершено.');
        break;
    end
    
    current_jnts = robot.Joints();
    new_jnts = current_jnts;
    
    % Левый стик: Оси 1 (горизонталь) и 2 (вертикаль)
    if abs(axes_data(1)) > dead_zone
        new_jnts(1) = new_jnts(1) + axes_data(1) * speed_j1;
    end
    if abs(axes_data(2)) > dead_zone
        new_jnts(2) = new_jnts(2) - axes_data(2) * speed_j2; 
    end
    
    % ПРАВЫЙ СТИК: ИСПРАВЛЕННЫЕ ОСИ (4 и 5)
    % Ось 5: Вертикаль правого стика (Joint 3)
    if abs(axes_data(5)) > dead_zone
        new_jnts(3) = new_jnts(3) - axes_data(5) * speed_j3;
    end
    
    % Ось 4: Горизонталь правого стика (Joint 4)
    if abs(axes_data(4)) > dead_zone
        new_jnts(4) = new_jnts(4) + axes_data(4) * speed_j4;
    end
    
    % 1. Двигаем физического робота в RoboDK
    robot.setJoints(new_jnts);
    
    % --- СИНХРОНИЗАЦИЯ С MATLAB ---
    % 2. Спрашиваем у робота его новую матрицу позиции 4x4
    T_current = robot.Pose(); 
    
    % 3. Вставляем эту матрицу напрямую в твой визуальный фрейм!
    tcp_frame.Matrix = T_current;
    
    % Обновляем картинку
    drawnow;
    pause(0.02); 
end
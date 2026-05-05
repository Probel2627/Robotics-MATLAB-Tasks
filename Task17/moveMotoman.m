clear; clc; close all;

% 1. Связь с RoboDK
try
    RDK = Robolink;
    robot = RDK.Item('', RDK.ITEM_TYPE_ROBOT);
    
    if ~robot.Valid()
        error('Robot not found in RoboDK! Please load Motoman SIA20D.');
    end
    disp('RoboDK: Connection established');
catch
    error('Robolink error: check if RoboDK is running.');
end

% 2. Связь с джойстиком
try
    joy = vrjoystick(1);
    disp('Joystick: Connected');
catch
    error('Joystick: Not found.');
end

% Установка НОВОЙ Home позиции: theta4 = 90
q = [0, 0, 0, 90, 0, 0, 0]; 
speed = 4; 

% Инструкции в терминале
fprintf('\n=====================================================\n');
fprintf('MOTOMAN SIA20D (7-DOF) CONTROL:\n');
fprintf('  NEW Home Position: [0, 0, 0, 90, 0, 0, 0]\n');
fprintf('  L-Stick (Axes 1, 2) -> Joints 1, 2\n');
fprintf('  R-Stick (Axes 4, 5) -> Joints 3, 4\n');
fprintf('  LB / RB (Btns 5, 6) -> Joint 5\n');
fprintf('  Btn X / Btn Y (3,4) -> Joint 6\n');
fprintf('  Button 2 (B)         -> RESET TO NEW HOME (q4=90)\n');
fprintf('  Button 1 (A)         -> EXIT\n');
fprintf('=====================================================\n');

figure('Name', 'Motoman SIA20D Digital Twin', 'Color', [0.1 0.1 0.1]);

while true
    axes_data = read(joy);
    btns      = button(joy);
    
    if btns(1), break; end % Выход (A)
    
    % Кнопка HOME (B) - теперь возвращает в q4 = 90
    if btns(2)
        q = [0, 0, 0, 90, 0, 0, 0];
        fprintf('Resetting to Custom Home Position (theta4 = 90)\n');
    end
    
    % Управление осями (Стики)
    if abs(axes_data(1)) > 0.15, q(1) = q(1) + axes_data(1) * speed; end
    if abs(axes_data(2)) > 0.15, q(2) = q(2) + axes_data(2) * speed; end
    if abs(axes_data(4)) > 0.15, q(3) = q(3) + axes_data(4) * speed; end
    if abs(axes_data(5)) > 0.15, q(4) = q(4) + axes_data(5) * speed; end
    
    % Кнопки управления запястьем
    if btns(5), q(5) = q(5) - speed; end
    if btns(6), q(5) = q(5) + speed; end
    if btns(3), q(6) = q(6) - speed; end 
    if btns(4), q(6) = q(6) + speed; end

    % Обновление MATLAB и RoboDK одновременно
    [T_flange, ~] = motoman_SIA(q(1), q(2), q(3), q(4), q(5), q(6), q(7));
    robot.setJoints(q); 
    
    drawnow;
    pause(0.01);
end

close(joy);
disp('Program closed.');
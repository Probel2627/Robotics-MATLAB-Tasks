clear; clc; close all;

% 1. ПОДКЛЮЧЕНИЕ К ROBODK
try
    RDK = Robolink;
    waist = RDK.Item('Turntable', RDK.ITEM_TYPE_ROBOT);
    armL  = RDK.Item('Left SDA10F', RDK.ITEM_TYPE_ROBOT);
    armR  = RDK.Item('Right SDA10F', RDK.ITEM_TYPE_ROBOT);
    
    if ~armL.Valid() || ~armR.Valid() || ~waist.Valid()
        error('Проверьте имена в RoboDK: Turntable, Left SDA10F, Right SDA10F');
    end
    disp('RoboDK: Связь установлена.');
catch
    error('RoboDK: Ошибка подключения.');
end

% 2. ПОДКЛЮЧЕНИЕ ДЖОЙСТИКА
try
    joy = vrjoystick(1);
    disp('Joystick: Готов.');
catch
    error('Joystick: Не найден.');
end

% 3. HOME POSITION (из RoboDK)
HOME_QW = 0;
HOME_QL = [90, 90, -90, -130, 0, -60, 90]; 
HOME_QR = [90, -90, -90, -130, 0, -60, 90]; 

q_w = HOME_QW; qL = HOME_QL; qR = HOME_QR;
speed = 2.5; 
mode = 0; % ТЕПЕРЬ: 0 - ПРАВАЯ (Red), 1 - ЛЕВАЯ (Blue)
last_btn10 = 0;

fprintf('\n=====================================================\n');
fprintf('SDA10F: УПРАВЛЕНИЕ С ТЫЛОВОЙ КАМЕРОЙ (view [-45 25]):\n');
fprintf('  Режим 0 (Старт)  -> ПРАВАЯ РУКА (Red)\n');
fprintf('  Режим 1 (Toggle) -> ЛЕВАЯ РУКА (Blue)\n');
fprintf('  Кнопка 10 (Start)-> Переключение режима\n');
fprintf('  Кнопка 2 (B)     -> Сброс в HOME\n');
fprintf('=====================================================\n');

figure('Name', 'SDA10F Rear View Twin', 'Color', [0.1 0.1 0.1]);

while true
    axes_data = read(joy);
    btns      = button(joy);
    if btns(1), break; end 
    
    % Сброс в Home
    if btns(2)
        q_w = HOME_QW; qL = HOME_QL; qR = HOME_QR;
        waist.setJoints(q_w); armL.setJoints(qL); armR.setJoints(qR);
    end
    
    % Переключение режима
    if btns(10) && last_btn10 == 0
        mode = 1 - mode;
        if mode == 0, disp('Active: RIGHT ARM (Red)'); else, disp('Active: LEFT ARM (Blue)'); end
    end
    last_btn10 = btns(10);

    % Вращение талии (LT/RT)
    if btns(7), q_w = q_w - speed; waist.setJoints(q_w); end
    if btns(8), q_w = q_w + speed; waist.setJoints(q_w); end

    % УПРАВЛЕНИЕ СУСТАВАМИ
    if mode == 0 % ПРАВАЯ (Red)
        if abs(axes_data(1)) > 0.15, qR(1) = qR(1) + axes_data(1) * speed; end
        if abs(axes_data(2)) > 0.15, qR(2) = qR(2) + axes_data(2) * speed; end
        if abs(axes_data(4)) > 0.15, qR(3) = qR(3) + axes_data(4) * speed; end
        if abs(axes_data(5)) > 0.15, qR(4) = qR(4) + axes_data(5) * speed; end
        if btns(5), qR(5) = qR(5) - speed; end
        if btns(6), qR(5) = qR(5) + speed; end
        if btns(3), qR(6) = qR(6) - speed; end 
        if btns(4), qR(6) = qR(6) + speed; end
        armR.setJoints(qR);
    else         % ЛЕВАЯ (Blue)
        if abs(axes_data(1)) > 0.15, qL(1) = qL(1) + axes_data(1) * speed; end
        if abs(axes_data(2)) > 0.15, qL(2) = qL(2) + axes_data(2) * speed; end
        if abs(axes_data(4)) > 0.15, qL(3) = qL(3) + axes_data(4) * speed; end
        if abs(axes_data(5)) > 0.15, qL(4) = qL(4) + axes_data(5) * speed; end
        if btns(5), qL(5) = qL(5) - speed; end
        if btns(6), qL(5) = qL(5) + speed; end
        if btns(3), qL(6) = qL(6) - speed; end 
        if btns(4), qL(6) = qL(6) + speed; end
        armL.setJoints(qL);
    end

    % Отрисовка
    motoman_SDA(q_w, qL, qR);
    drawnow;
    pause(0.01);
end
close(joy);
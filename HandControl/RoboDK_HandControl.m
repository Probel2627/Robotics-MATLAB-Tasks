close all; clear; clc;

% --- 1. ЗАГРУЗКА ПИТОН-МОДУЛЯ ---
disp('Инициализация нейросети MediaPipe...');

% Добавляем текущую папку MATLAB в системный путь Питона
P = py.sys.path;
if count(P, pwd) == 0
    insert(P, int32(0), pwd);
end

% Теперь пытаемся загрузить модуль и выводим НАСТОЯЩУЮ ошибку, если она есть
try
    mod = py.importlib.import_module('hand_tracker');
    py.importlib.reload(mod); % Перезагружаем на случай, если меняли код
    tracker = py.hand_tracker.Tracker(); % Запускаем камеру в Питоне
catch ME
    disp('Настоящая ошибка Питона:');
    disp(ME.message); % Вот тут мы увидим, на что реально ругается Питон!
    error('Остановка скрипта.');
end

% --- 2. ПОДКЛЮЧЕНИЕ К ROBODK ---
disp('Подключение к RoboDK...');
RDK = Robolink();
robot = RDK.Item('', RDK.ITEM_TYPE_ROBOT);
if ~robot.Valid()
    error('Робот не найден! Добавь робота в сцену RoboDK.');
end
current_jnts = robot.Joints();

disp('--- СИСТЕМА ГОТОВА ---');
disp('Покажи в камеру ладонь. Робот будет следить за УКАЗАТЕЛЬНЫМ ПАЛЬЦЕМ.');
disp('Для остановки нажми Ctrl+C в Command Window.');

% --- 3. ГЛАВНЫЙ ЦИКЛ ---
while true
    % Спрашиваем у Питона координаты пальца
    % Возвращается список (Cell Array), где {1} - это X, а {2} - это Y
    coords = tracker.get_finger_position();
    cx = double(coords{1});
    cy = double(coords{2});
    
    % Если палец найден (cx не равно -1)
    if cx ~= -1
        % MediaPipe выдает координаты от 0 до 1. Переводим их в движения робота!
        % Движение Влево/Вправо (Joint 1): от -90 до +90 градусов
        target_j1 = -((cx - 0.5) * 180); 
        
        % Движение Вверх/Вниз (Joint 3): от 0 до 150 мм
        target_j3 = cy * 150; 
        
        % Плавное следование (коэффициент 0.15)
        current_jnts(1) = current_jnts(1) + (target_j1 - current_jnts(1)) * 0.15;
        current_jnts(3) = current_jnts(3) + (target_j3 - current_jnts(3)) * 0.15;
        
        % Отправляем команду роботу
        robot.setJoints(current_jnts);
    end
    
    pause(0.01); % Даем время системе на обновление
end
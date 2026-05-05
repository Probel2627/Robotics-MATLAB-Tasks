% Скрипт связи MATLAB и RoboDK (Диагностическая версия)
clear; clc; close all;

% ==========================================
% 1. ВВОД ГРАДУСОВ (Спиши их с панели RoboDK)
% ==========================================
t1_deg = 0;
t2_deg = -90;
t3_deg = -90;
t4_deg = 0;
t5_deg = 90;
t6_deg = 0;

% Перевод в радианы для нашей функции
t1 = deg2rad(t1_deg); t2 = deg2rad(t2_deg); t3 = deg2rad(t3_deg); 
t4 = deg2rad(t4_deg); t5 = deg2rad(t5_deg); t6 = deg2rad(t6_deg);

% ==========================================
% 2. ОТРИСОВКА В MATLAB
% ==========================================
disp('⏳ Шаг 1: Отрисовка в MATLAB...');
figure('Name', 'Модель в MATLAB', 'NumberTitle', 'off');
try
    [Flange, TCP] = UR3(t1, t2, t3, t4, t5, t6);
    disp('✅ MATLAB: График успешно построен!');
catch ME
    disp('❌ ОШИБКА в файле UR3.m (График не построен):');
    disp(ME.message);
    return; % Останавливаем скрипт
end

% ==========================================
% 3. СВЯЗЬ С ROBODK
% ==========================================
disp('⏳ Шаг 2: Подключение к RoboDK...');
try
    RDK = Robolink;
    
    % ИЩЕМ РОБОТА ПО ИМЕНИ
    robot = RDK.Item('UR3', RDK.ITEM_TYPE_ROBOT);
    
    if ~robot.Valid()
        disp('❌ ОШИБКА: Робот "UR3" не найден в дереве!');
        disp('Убедись, что в дереве RoboDK (слева) робот называется ровно "UR3" (без пробелов).');
        return;
    end
    disp('✅ RoboDK: Подключение установлено, робот найден!');
    
    % ОТПРАВКА ДАННЫХ
    joints_to_send = [t1_deg, t2_deg, t3_deg, t4_deg, t5_deg, t6_deg];
    disp(['⏳ Отправляем углы: [', num2str(joints_to_send), ']']);
    
    % Команда движения
    robot.MoveJ(joints_to_send);
    disp('🎉 УСПЕХ: Робот в RoboDK должен был пошевелиться!');
    
catch ME
    disp('❌ ОШИБКА СВЯЗИ с RoboDK API:');
    disp(ME.message);
end
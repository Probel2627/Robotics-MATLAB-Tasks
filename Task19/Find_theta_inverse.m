clear; clc;
disp('======================================================');
disp(' ИНИЦИАЛИЗАЦИЯ: Подготовка математики UR5');
disp('======================================================');

% 1. Объявляем символьные переменные для углов
syms t1 t2 t3 t4 t5 t6 real

% 2. Вписываем УЖЕ ВЫЧИСЛЕННЫЕ числовые уравнения (Прямая Кинематика)
% Здесь длины звеньев уже подставлены и сокращены
nx = (sin(t1)*sin(t5) + cos(t1)*cos(t5)*cos(t2 + t3 + t4))*cos(t6) - sin(t6)*sin(t2 + t3 + t4)*cos(t1);
ny = (sin(t1)*cos(t5)*cos(t2 + t3 + t4) - sin(t5)*cos(t1))*cos(t6) - sin(t1)*sin(t6)*sin(t2 + t3 + t4);
nz = sin(t6)*cos(t2 + t3 + t4) + sin(t2 + t3 + t4)*cos(t5)*cos(t6);
sx = -(sin(t1)*sin(t5) + cos(t1)*cos(t5)*cos(t2 + t3 + t4))*sin(t6) - sin(t2 + t3 + t4)*cos(t1)*cos(t6);
sy = (-sin(t1)*cos(t5)*cos(t2 + t3 + t4) + sin(t5)*cos(t1))*sin(t6) - sin(t1)*sin(t2 + t3 + t4)*cos(t6);
sz = -sin(t6)*sin(t2 + t3 + t4)*cos(t5) + cos(t6)*cos(t2 + t3 + t4);
ax = sin(t1)*cos(t5) - sin(t5)*cos(t1)*cos(t2 + t3 + t4);
ay = -sin(t1)*sin(t5)*cos(t2 + t3 + t4) - cos(t1)*cos(t5);
az = -sin(t5)*sin(t2 + t3 + t4);
px = 0.0823*sin(t1)*cos(t5) + 0.10915*sin(t1) - 0.0823*sin(t5)*cos(t1)*cos(t2 + t3 + t4) + 0.09465*sin(t2 + t3 + t4)*cos(t1) - 0.425*cos(t1)*cos(t2) - 0.39225*cos(t1)*cos(t2 + t3);
py = -0.0823*sin(t1)*sin(t5)*cos(t2 + t3 + t4) + 0.09465*sin(t1)*sin(t2 + t3 + t4) - 0.425*sin(t1)*cos(t2) - 0.39225*sin(t1)*cos(t2 + t3) - 0.0823*cos(t1)*cos(t5) - 0.10915*cos(t1);
pz = -0.425*sin(t2) - 0.0823*sin(t5)*sin(t2 + t3 + t4) - 0.39225*sin(t2 + t3) - 0.09465*cos(t2 + t3 + t4) + 0.089159;

% Собираем 12 функций в один вектор-столбец
F_sym = [nx; ny; nz; sx; sy; sz; ax; ay; az; px; py; pz];
vars = [t1, t2, t3, t4, t5, t6];

% 3. РУЧНОЙ РАСЧЕТ ЯКОБИАНА (как мы и хотели)
disp('Собираем Якобиан 12x6 вручную через производные (diff)...');
J_sym = sym(zeros(12, 6));
for i = 1:12
    for j = 1:6
        J_sym(i, j) = diff(F_sym(i), vars(j));
    end
end

% 4. ПРЕВРАЩАЕМ В БЫСТРЫЕ ЧИСЛОВЫЕ ФУНКЦИИ
% Это позволяет вычислять Якобиан за миллисекунды в цикле
disp('Создаем быстрые функции...');
calc_F = matlabFunction(F_sym, 'Vars', {t1, t2, t3, t4, t5, t6});
calc_J = matlabFunction(J_sym, 'Vars', {t1, t2, t3, t4, t5, t6});

disp('Математика готова!');
disp(' ');

% ======================================================
% ШАГ 2: ДАННЫЕ ИЗ RoboDK (Твоя Цель)
% ======================================================
disp('======================================================');
disp(' ЗАГРУЗКА ЦЕЛИ: Координаты RoboDK');
disp('======================================================');

% Позиция (переводим мм в метры!)
X_target = -261.233 / 1000;
Y_target = -109.300 / 1000;
Z_target =  608.950 / 1000;

% Ориентация: Вектор вращения Axis-Angle (в градусах)
u_deg = -65.273;
v_deg = -75.187;
w_deg =  75.187;

% Конвертируем вектор RoboDK в Матрицу Вращения 3x3 (Формула Родригеса)
angle_deg = norm([u_deg, v_deg, w_deg]);
angle_rad = deg2rad(angle_deg);
axis = [u_deg, v_deg, w_deg] / angle_deg; % Единичный вектор оси

kx = axis(1); ky = axis(2); kz = axis(3);
K = [  0, -kz,  ky;
      kz,   0, -kx;
     -ky,  kx,   0];
R_target = eye(3) + sin(angle_rad)*K + (1 - cos(angle_rad))*(K*K);

% Собираем целевую матрицу 4x4 и вытаскиваем вектор 12x1
T_target = eye(4);
T_target(1:3, 1:3) = R_target;
T_target(1:3, 4) = [X_target; Y_target; Z_target];

F_target = [T_target(1:3,1); T_target(1:3,2); T_target(1:3,3); T_target(1:3,4)];

% ======================================================
% ШАГ 3: РЕШЕНИЕ (Алгоритм Ньютона-Рафсона)
% ======================================================
disp('======================================================');
disp(' РЕШЕНИЕ: Поиск углов суставов...');
disp('======================================================');

% НАЧАЛЬНАЯ ДОГАДКА (С чего робот начинает поиск)
% Важно: если все нули, робот вытянут вверх (сингулярность).
% Дадим ему легкий изгиб в локте, чтобы алгоритму было проще считать производные.
theta = [0; -pi/4; pi/2; -pi/4; -pi/2; 0]; 

max_iter = 100;      % Сколько попыток делаем
tolerance = 1e-5;    % Требуемая точность
alpha = 0.3;         % Скорость шага (чем меньше, тем стабильнее, но дольше)

success = false;

for iter = 1:max_iter
    % 1. Вычисляем текущее положение (12 элементов)
    F_current = calc_F(theta(1), theta(2), theta(3), theta(4), theta(5), theta(6));
    
    % 2. Считаем ошибку (Цель - Текущее)
    error_vector = F_target - F_current;
    err_magnitude = norm(error_vector);
    
    fprintf('Итерация %2d | Ошибка: %.6f\n', iter, err_magnitude);
    
    % 3. Проверка на победу
    if err_magnitude < tolerance
        success = true;
        break;
    end
    
    % 4. Считаем Якобиан (12x6) для текущей позы
    J_current = calc_J(theta(1), theta(2), theta(3), theta(4), theta(5), theta(6));
    
    % 5. Вычисляем дельту углов: Псевдоинверсия (pinv) * ошибку
    delta_theta = pinv(J_current) * error_vector;
    
    % 6. Обновляем углы
    theta = theta + alpha * delta_theta;
end

% ======================================================
% ШАГ 4: ВЫВОД РЕЗУЛЬТАТОВ
% ======================================================
disp('======================================================');
if success
    disp('✅ УСПЕХ: Углы найдены!');
    disp('Углы для ввода в RoboDK (в градусах):');
    
    % Переводим радианы в градусы и округляем для красоты
    theta_deg = rad2deg(theta);
    
    % Нормализуем углы, чтобы они были в пределах от -360 до 360
    theta_deg = mod(theta_deg + 180, 360) - 180;
    
    fprintf('t1 (Base)     = %8.3f deg\n', theta_deg(1));
    fprintf('t2 (Shoulder) = %8.3f deg\n', theta_deg(2));
    fprintf('t3 (Elbow)    = %8.3f deg\n', theta_deg(3));
    fprintf('t4 (Wrist 1)  = %8.3f deg\n', theta_deg(4));
    fprintf('t5 (Wrist 2)  = %8.3f deg\n', theta_deg(5));
    fprintf('t6 (Wrist 3)  = %8.3f deg\n', theta_deg(6));
else
    disp('❌ ОШИБКА: Алгоритм застрял и не сошелся.');
    disp('Попробуй изменить начальную догадку (переменная theta).');
end
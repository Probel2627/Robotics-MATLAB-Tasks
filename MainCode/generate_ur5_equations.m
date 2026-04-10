clear; clc;

% 1. Объявляем переменные углов
syms t1 t2 t3 t4 t5 t6 real

% 2. Объявляем константы звеньев ТОЖЕ КАК СИМВОЛЫ (буквы)
syms d1 a2 a3 d4 d5 d6 real

% 3. Оставляем конкретными только углы alpha, так как sin(pi/2)=1 и cos(pi/2)=0 (это сильно упростит матрицы)
a = [0, a2, a3, 0, 0, 0];
d = [d1, 0, 0, d4, d5, d6];
p = sym('pi');
alpha = [p/2, 0, 0, p/2, -p/2, 0];
theta = [t1, t2, t3, t4, t5, t6];

% 4. Функция генерации матрицы DH
get_DH_matrix = @(t, a, al, d) [
    cos(t), -sin(t)*cos(al),  sin(t)*sin(al), a*cos(t);
    sin(t),  cos(t)*cos(al), -cos(t)*sin(al), a*sin(t);
    0,       sin(al),         cos(al),        d;
    0,       0,                  0,                 1
];

% Создаем 6 матриц
A1 = get_DH_matrix(theta(1), a(1), alpha(1), d(1));
A2 = get_DH_matrix(theta(2), a(2), alpha(2), d(2));
A3 = get_DH_matrix(theta(3), a(3), alpha(3), d(3));
A4 = get_DH_matrix(theta(4), a(4), alpha(4), d(4));
A5 = get_DH_matrix(theta(5), a(5), alpha(5), d(5));
A6 = get_DH_matrix(theta(6), a(6), alpha(6), d(6));

% Умножаем и упрощаем
T_final = simplify(A1 * A2 * A3 * A4 * A5 * A6);

% Выводим Вектор позиции (p)
disp('--- (p) ---');
fprintf('px = %s\n\n', char(T_final(1,4)));
fprintf('py = %s\n\n', char(T_final(2,4)));
fprintf('pz = %s\n\n', char(T_final(3,4)));

% Выводим Вектор нормали (n)
disp('--- (n) ---');
fprintf('nx = %s\n\n', char(T_final(1,1)));
fprintf('ny = %s\n\n', char(T_final(2,1)));
fprintf('nz = %s\n\n', char(T_final(3,1)));

% Для векторов s и a
disp('--- (s) ---');
fprintf('sx = %s\n\n', char(T_final(1,2)));
fprintf('sy = %s\n\n', char(T_final(2,2)));
fprintf('sz = %s\n\n', char(T_final(3,2)));

disp('--- (a) ---');
fprintf('ax = %s\n\n', char(T_final(1,3)));
fprintf('ay = %s\n\n', char(T_final(2,3)));
fprintf('az = %s\n\n', char(T_final(3,3)));
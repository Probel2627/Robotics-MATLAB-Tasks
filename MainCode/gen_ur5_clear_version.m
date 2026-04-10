clear; clc;

% 1. Объявляем символьные переменные для углов суставов
syms t1 t2 t3 t4 t5 t6 real

% 2. Объявляем символьные переменные для длин звеньев (чтобы формула была буквенной)
syms d1 a2 a3 d4 d5 d6 real

% 3. Параметры DH для UR5
% Используем обычный pi, так как дальше мы применим round()
alpha = [pi/2, 0, 0, pi/2, -pi/2, 0];
a = [0, a2, a3, 0, 0, 0];
d = [d1, 0, 0, d4, d5, d6];
theta = [t1, t2, t3, t4, t5, t6];



% 4. Умная функция генерации матрицы DH с жестким округлением
% Это убивает машинные погрешности (превращает 6.12e-17 в идеальный 0)
get_DH_matrix = @(t, a, al, d) [
    cos(t), -sin(t)*round(cos(al)),  sin(t)*round(sin(al)), a*cos(t);
    sin(t),  cos(t)*round(cos(al)), -cos(t)*round(sin(al)), a*sin(t);
    0,       round(sin(al)),         round(cos(al)),        d;
    0,       0,                      0,                     1
];

% 5. Создаем 6 матриц для каждого сустава
A1 = get_DH_matrix(theta(1), a(1), alpha(1), d(1));
A2 = get_DH_matrix(theta(2), a(2), alpha(2), d(2));
A3 = get_DH_matrix(theta(3), a(3), alpha(3), d(3));
A4 = get_DH_matrix(theta(4), a(4), alpha(4), d(4));
A5 = get_DH_matrix(theta(5), a(5), alpha(5), d(5));
A6 = get_DH_matrix(theta(6), a(6), alpha(6), d(6));



% 6. Перемножаем и упрощаем (это может занять пару секунд)
disp('Вычисляем чистую алгебру для UR5...');
T_final = simplify(A1 * A2 * A3 * A4 * A5 * A6);

% 7. Выводим результаты в консоль (уже с точкой с запятой на конце!)
disp(' ');
disp('% ========================================');
disp('% --- ВЕКТОР НОРМАЛИ (n) ---');
fprintf('nx = %s;\n', char(T_final(1,1)));
fprintf('ny = %s;\n', char(T_final(2,1)));
fprintf('nz = %s;\n\n', char(T_final(3,1)));

disp('% --- ВЕКТОР СКОЛЬЖЕНИЯ (s) ---');
fprintf('sx = %s;\n', char(T_final(1,2)));
fprintf('sy = %s;\n', char(T_final(2,2)));
fprintf('sz = %s;\n\n', char(T_final(3,2)));

disp('% --- ВЕКТОР ПОДХОДА (a) ---');
fprintf('ax = %s;\n', char(T_final(1,3)));
fprintf('ay = %s;\n', char(T_final(2,3)));
fprintf('az = %s;\n\n', char(T_final(3,3)));

disp('% --- ВЕКТОР ПОЗИЦИИ (p) ---');
fprintf('px = %s;\n', char(T_final(1,4)));
fprintf('py = %s;\n', char(T_final(2,4)));
fprintf('pz = %s;\n', char(T_final(3,4)));
disp('% ========================================');

a2 = -0.425;
a3 = -0.39225;
d1 = 0.089159;
d4 = 0.10915;
d5 = 0.09465;
d6 = 0.0823;

px = d6*(cos(t5)*sin(t1) - cos(t2 + t3 + t4)*cos(t1)*sin(t5)) + d4*sin(t1) + a2*cos(t1)*cos(t2) + d5*sin(t2 + t3 + t4)*cos(t1) + a3*cos(t1)*cos(t2)*cos(t3) - a3*cos(t1)*sin(t2)*sin(t3);

disp(px)

f1  = T_final(1,1); % nx
f2  = T_final(2,1); % ny
f3  = T_final(3,1); % nz
f4  = T_final(1,2); % sx
f5  = T_final(2,2); % sy
f6  = T_final(3,2); % sz
f7  = T_final(1,3); % ax
f8  = T_final(2,3); % ay
f9  = T_final(3,3); % az
f10 = T_final(1,4); % px
f11 = T_final(2,4); % py
f12 = T_final(3,4); % pz

jacobian_matrix = [
  f1/t1, f1/t2, f1/t3, f1/t4, f1/t5, f1/t6;
  f2/t1, f2/t2, f2/t3, f2/t4, f2/t5, f2/t6;
  f3/t1, f3/t2, f3/t3, f3/t4, f3/t5, f3/t6;
  f4/t1, f4/t2, f4/t3, f4/t4, f4/t5, f4/t6;
  f5/t1, f5/t2, f5/t3, f5/t4, f5/t5, f5/t6;
  f6/t1, f6/t2, f6/t3, f6/t4, f6/t5, f6/t6;
  f7/t1, f7/t2, f7/t3, f7/t4, f7/t5, f7/t6;
  f8/t1, f8/t2, f8/t3, f8/t4, f8/t5, f8/t6;
  f9/t1, f9/t2, f9/t3, f9/t4, f9/t5, f9/t6;
  f10/t1, f10/t2, f10/t3, f10/t4, f10/t5, f10/t6;
  f11/t1, f11/t2, f11/t3, f11/t4, f11/t5, f11/t6;
  f12/t1, f12/t2, f12/t3, f12/t4, f12/t5, f12/t6;
];

jacobian_matrix = simplify(jacobian_matrix);

disp(jacobian_matrix)
disp(size(jacobian_matrix))
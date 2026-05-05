function T = UR5(t1, t2, t3, t4, t5, t6)
    % Константы из параметров UR5 (в метрах)
    a2 = -0.425; 
    a3 = -0.39225; 
    d1 = 0.089159; 
    d4 = 0.10915; 
    d5 = 0.09465; 
    d6 = 0.0823;

    % Параметры alpha в градусах для функции get_A_matrix[cite: 3, 11]
    alpha = [90, 0, 0, 90, -90, 0];

    % Расчет матриц для каждого сустава[cite: 11]
    % Переводим входные радианы в градусы для get_A_matrix[cite: 3]
    A1 = get_A_matrix(rad2deg(t1), 0, alpha(1), d1);
    A2 = get_A_matrix(rad2deg(t2), a2, alpha(2), 0);
    A3 = get_A_matrix(rad2deg(t3), a3, alpha(3), 0);
    A4 = get_A_matrix(rad2deg(t4), 0, alpha(4), d4);
    A5 = get_A_matrix(rad2deg(t5), 0, alpha(5), d5);
    A6 = get_A_matrix(rad2deg(t6), 0, alpha(6), d6);

    % Итоговая матрица через перемножение (Матричный метод)[cite: 11]
    T = A1 * A2 * A3 * A4 * A5 * A6;
end
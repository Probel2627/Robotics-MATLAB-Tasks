function T = UR5_extended(t1, t2, t3, t4, t5, t6)
    % Размеры звеньев UR5 (в метрах)
    a2 = -0.425; 
    a3 = -0.39225; 
    d1 = 0.089159; 
    d4 = 0.10915; 
    d5 = 0.09465; 
    d6 = 0.0823;

    % Вектор нормали (n)
    nx = (sin(t1)*sin(t5) + cos(t1)*cos(t5)*cos(t2 + t3 + t4))*cos(t6) - sin(t6)*sin(t2 + t3 + t4)*cos(t1);
    ny = (sin(t1)*cos(t5)*cos(t2 + t3 + t4) - sin(t5)*cos(t1))*cos(t6) - sin(t1)*sin(t6)*sin(t2 + t3 + t4);
    nz = sin(t6)*cos(t2 + t3 + t4) + sin(t2 + t3 + t4)*cos(t5)*cos(t6);

    % Вектор скольжения (s)
    sx = -(sin(t1)*sin(t5) + cos(t1)*cos(t5)*cos(t2 + t3 + t4))*sin(t6) - sin(t2 + t3 + t4)*cos(t1)*cos(t6);
    sy = (-sin(t1)*cos(t5)*cos(t2 + t3 + t4) + sin(t5)*cos(t1))*sin(t6) - sin(t1)*sin(t2 + t3 + t4)*cos(t6);
    sz = -sin(t6)*sin(t2 + t3 + t4)*cos(t5) + cos(t6)*cos(t2 + t3 + t4);

    % Вектор подхода (a)
    ax = sin(t1)*cos(t5) - sin(t5)*cos(t1)*cos(t2 + t3 + t4);
    ay = -sin(t1)*sin(t5)*cos(t2 + t3 + t4) - cos(t1)*cos(t5);
    az = -sin(t5)*sin(t2 + t3 + t4);

    % Вектор позиции (p)
    px = 0.0823*sin(t1)*cos(t5) + 0.10915*sin(t1) - 0.0823*sin(t5)*cos(t1)*cos(t2 + t3 + t4) + 0.09465*sin(t2 + t3 + t4)*cos(t1) - 0.425*cos(t1)*cos(t2) - 0.39225*cos(t1)*cos(t2 + t3);
    py = -0.0823*sin(t1)*sin(t5)*cos(t2 + t3 + t4) + 0.09465*sin(t1)*sin(t2 + t3 + t4) - 0.425*sin(t1)*cos(t2) - 0.39225*sin(t1)*cos(t2 + t3) - 0.0823*cos(t1)*cos(t5) - 0.10915*cos(t1);
    pz = -0.425*sin(t2) - 0.0823*sin(t5)*sin(t2 + t3 + t4) - 0.39225*sin(t2 + t3) - 0.09465*cos(t2 + t3 + t4) + 0.089159;

    % Сборка итоговой матрицы
    T = [nx, sx, ax, px; 
         ny, sy, ay, py; 
         nz, sz, az, pz; 
         0,  0,  0,  1];
end
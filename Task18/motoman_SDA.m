function [T_L, T_R] = motoman_SDA(q_w, qL, qR)
    if nargin == 0
        q_w = 0; qL = [90, 90, -90, -130, 0, -60, 90]; qR = [90, -90, -90, -130, 0, -60, 90]; 
    end

    delete(allchild(gca)); hold on; grid on;
    set(gca, 'Color', [0.1 0.1 0.1], 'XColor', 'w', 'YColor', 'w', 'ZColor', 'w');
    axis([-1200 1200 -1200 1200 0 2000]); 
    
    % УСТАНОВЛЕННЫЙ ВАМИ ВИД (Вид "со спины")
    view([-45 25]); 

    % 1. Основание (Белый Pillar)
    plot3([0 0], [0 0], [0 875], 'w', 'LineWidth', 10); 

    % 2. Талия
    T_waist = get_A_matrix(q_w, 0, 0, 875);
    
    % 3. ПЛЕЧИ: Коррекция ориентации
    R_corr_L = [1 0 0 0; 0 0 1 0; 0 -1 0 0; 0 0 0 1]; 
    R_corr_R = [-1 0 0 0; 0 0 -1 0; 0 -1 0 0; 0 0 0 1];
    
    % Сохраняем физические координаты RoboDK (Y=205 и Y=-205)
    T_L_start = T_waist * [eye(3), [0; 205; 0]; 0 0 0 1] * R_corr_L;
    T_R_start = T_waist * [eye(3), [0; -205; 0]; 0 0 0 1] * R_corr_R;

    % Отрисовка торса (Желтая балка)
    pL = T_L_start(1:3,4)'; pR = T_R_start(1:3,4)';
    plot3([pL(1) pR(1)], [pL(2) pR(2)], [pL(3) pR(3)], 'y', 'LineWidth', 8);

    % 4. ОТРИСОВКА РУК
    % Левая рука (Blue)
    T_L = draw_arm_SDA(T_L_start, qL, 'b'); 
    
    % Правая рука (Red) с коррекцией +180 для правильной отрисовки вниз
    qR_fixed = qR;
    qR_fixed(1) = qR(1) + 180; 
    T_R = draw_arm_SDA(T_R_start, qR_fixed, 'r');
end

function Tend = draw_arm_SDA(T_base, q, color)
    % Параметры из чертежа: d3=360, d5=360, d7=155
    alpha = [-90, 90, -90, 90, -90, 90, 0];
    d = [0, 0, 360, 0, 360, 0, 155]; 
    a = zeros(1,7);
    Curr_T = T_base; pts = [T_base(1:3,4)'];
    for i = 1:7
        Curr_T = Curr_T * get_A_matrix(q(i), a(i), alpha(i), d(i));
        pts = [pts; Curr_T(1:3,4)'];
        f = create_mobile_frame(); set(f, 'Matrix', Curr_T);
    end
    plot3(pts(:,1), pts(:,2), pts(:,3), [color '-o'], 'LineWidth', 4, 'MarkerFaceColor', 'y');
    Tend = Curr_T;
end
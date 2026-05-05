function [T_flange, T_tcp] = motoman_SIA(q1, q2, q3, q4, q5, q6, q7)
    % Новая Home позиция: q4 = 90, остальные 0
    if nargin == 0
        q1=0; q2=0; q3=0; q4=90; q5=0; q6=0; q7=0;
    end

    % Настройка графики
    delete(allchild(gca)); hold on; grid on;
    set(gca, 'Color', [0.1 0.1 0.1], 'XColor', 'w', 'YColor', 'w', 'ZColor', 'w');
    axis([-1500 1500 -1500 1500 0 2000]); 
    view([135 30]);
    xlabel('X'); ylabel('Y'); zlabel('Z');
    
    % DH Параметры из чертежа
    % d1=410, d3=490, d5=420, d7=180
    alpha = [-90, 90, -90, 90, -90, 90, 0];
    a = [0, 0, 0, 0, 0, 0, 0];
    d = [410, 0, 490, 0, 420, 0, 180];
    
    % Вычисление матриц трансформации
    A1 = get_A_matrix(q1, a(1), alpha(1), d(1));
    A2 = A1 * get_A_matrix(q2, a(2), alpha(2), d(2));
    A3 = A2 * get_A_matrix(q3, a(3), alpha(3), d(3));
    A4 = A3 * get_A_matrix(q4, a(4), alpha(4), d(4));
    A5 = A4 * get_A_matrix(q5, a(5), alpha(5), d(5));
    A6 = A5 * get_A_matrix(q6, a(6), alpha(6), d(6));
    A7 = A6 * get_A_matrix(q7, a(7), alpha(7), d(7));

    % Отрисовка скелета
    pts = [0 0 0; A1(1:3,4)'; A2(1:3,4)'; A3(1:3,4)'; A4(1:3,4)'; A5(1:3,4)'; A6(1:3,4)'; A7(1:3,4)'];
    plot3(pts(:,1), pts(:,2), pts(:,3), 'w-o', 'LineWidth', 3, 'MarkerFaceColor', 'r');
    
    % Отрисовка фреймов
    frames = {eye(4), A1, A2, A3, A4, A5, A6, A7};
    for i = 1:length(frames)
        f = create_mobile_frame(); 
        set(f, 'Matrix', frames{i});
    end

    T_flange = A7;
    T_tcp = A7;
end
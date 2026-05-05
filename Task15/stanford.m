function T6 = stanford(q)
    % q = [theta1, theta2, d3, theta4, theta5, theta6]
    
    % Размеры (в мм)
    d1 = 1000; % Высота основания
    d2 = 200;  % Смещение плеча
    d6 = 150;  % Длина кисти
    
    % Матрицы перехода (используем твою get_A_matrix)
    % Joint 1: Основание
    A1 = get_A_matrix(q(1), 0, -90, d1);
    
    % Joint 2: Плечо (теперь q2 = 0 это горизонтальное положение)
    A2 = get_A_matrix(q(2), 0, 90, d2);
    
    % Joint 3: Призматический сустав (выдвижение)
    A3 = get_A_matrix(0, 0, 0, q(3));
    
    % Joint 4-6: Сферический кистевой сустав
    A4 = get_A_matrix(q(4), 0, -90, 0);
    A5 = get_A_matrix(q(5), 0, 90, 0);
    A6 = get_A_matrix(q(6), 0, 0, d6);

    % Настройка сцены
    hold on; grid on; axis equal;
    view(135, 30);
    xlabel('X'); ylabel('Y'); zlabel('Z');
    xlim([-1500 1500]); ylim([-1500 1500]); zlim([0 2000]);

    % Список всех трансформаций для отрисовки
    T_list = {eye(4), A1, A1*A2, A1*A2*A3, A1*A2*A3*A4, A1*A2*A3*A4*A5, A1*A2*A3*A4*A5*A6};
    
    pts = zeros(length(T_list), 3);
    for i = 1:length(T_list)
        T_curr = T_list{i};
        pts(i, :) = T_curr(1:3, 4)';
        
        % Отрисовка твоих осей (HGTransform)
        f = create_mobile_frame();
        set(f, 'Matrix', T_curr);
    end
    
    % Отрисовка скелета робота
    plot3(pts(:,1), pts(:,2), pts(:,3), '-o', 'LineWidth', 3, 'MarkerFaceColor', 'y', 'Color', [0.3 0.3 0.3]);
    
    T6 = T_list{end};
end
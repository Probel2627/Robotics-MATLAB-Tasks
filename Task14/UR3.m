function [T_flange, T_tcp] = UR3(t1, t2, t3, t4, t5, t6)
    if nargin == 0
        t1=0; t2=-90; t3=-90; t4=-90; t5=90; t6=0;
    end

    delete(allchild(gca)); hold on; grid on;
    set(gca, 'Color', [0.1 0.1 0.1], 'XColor', 'w', 'YColor', 'w', 'ZColor', 'w');
    axis([-900 900 -900 900 0 1000]); 
    view([135 30]);
    xlabel('X, m'); ylabel('Y, m'); zlabel('Z, m');
    
    d1 = 152; a2 = -244; a3 = -213; d4 = 112; d5 = 83; d6 = 82; 
    alpha = [90, 0, 0, 90, -90, 0]; 
    
    A1 = get_A_matrix(t1, 0,  alpha(1), d1);
    A2 = A1 * get_A_matrix(t2, a2, alpha(2), 0);
    A3 = A2 * get_A_matrix(t3, a3, alpha(3), 0);
    A4 = A3 * get_A_matrix(t4, 0,  alpha(4), d4);
    A5 = A4 * get_A_matrix(t5, 0,  alpha(5), d5);
    A6 = A5 * get_A_matrix(t6, 0,  alpha(6), d6);

    % Skeleton plotting
    robot_pts = [0 0 0; A1(1:3,4)'; A2(1:3,4)'; A3(1:3,4)'; A4(1:3,4)'; A5(1:3,4)'; A6(1:3,4)'];
    plot3(robot_pts(:,1), robot_pts(:,2), robot_pts(:,3), 'w-o', 'LineWidth', 3, 'MarkerFaceColor', 'w');
    
    % Display frame at the flange
    f_tcp = create_mobile_frame(); 
    set(f_tcp, 'Matrix', A6); 

    T_flange = A6;
    T_tcp = A6;
end
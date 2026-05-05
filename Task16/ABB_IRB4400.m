function [T_flange, T_tcp] = ABB_IRB4400(t1, t2, t3, t4, t5, t6)
    % Set default joints to zero if no input is provided
    if nargin == 0
        t1=0; t2=0; t3=0; t4=0; t5=0; t6=0;
    end

    % UI Setup and Axis Limits
    delete(allchild(gca)); hold on; grid on;
    set(gca, 'Color', [0.1 0.1 0.1], 'XColor', 'w', 'YColor', 'w', 'ZColor', 'w');
    axis([-2000 2000 -2000 2000 0 2500]); 
    view([135 30]);
    xlabel('X'); ylabel('Y'); zlabel('Z');
    
    % DH Parameters from your DH_convetion_4.m
    alpha = [-90, 0, 90, -90, 90, 0];
    a = [200, -890, -150, 0, 0, 0];
    d = [680, 0, 0, 880, 0, 140];
    
    % 1. Compute Transformation Matrices (Classical DH)
    A1 = get_A_matrix(t1, a(1), alpha(1), d(1));
    
    % Joint 2: Apply +90 offset per Task 16 requirements
    A2 = A1 * get_A_matrix(t2 + 90, a(2), alpha(2), d(2));
    
    % Joint 3: Apply mechanical coupling compensation (t3 - t2)
    % This ensures the elbow maintains orientation relative to the floor like the real ABB 4400
    A3 = A2 * get_A_matrix(t3 - t2, a(3), alpha(3), d(3));
    
    A4 = A3 * get_A_matrix(t4, a(4), alpha(4), d(4));
    A5 = A4 * get_A_matrix(t5, a(5), alpha(5), d(5));
    A6 = A5 * get_A_matrix(t6, a(6), alpha(6), d(6));

    % 2. Draw Skeleton Model
    pts = [0 0 0; A1(1:3,4)'; A2(1:3,4)'; A3(1:3,4)'; A4(1:3,4)'; A5(1:3,4)'; A6(1:3,4)'];
    plot3(pts(:,1), pts(:,2), pts(:,3), 'w-o', 'LineWidth', 3, 'MarkerFaceColor', 'r');
    
    % 3. Draw Coordinate Frames
    frames = {eye(4), A1, A2, A3, A4, A5, A6};
    for i = 1:length(frames)
        f = create_mobile_frame(); % Using your exact file name
        set(f, 'Matrix', frames{i});
    end

    T_flange = A6;
    T_tcp = A6;
end
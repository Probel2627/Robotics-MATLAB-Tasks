function T_end = adept(t1_deg, t2_deg, d3, t4_deg)
    if nargin < 4, t1_deg=0; t2_deg=0; d3=0; t4_deg=0; end

    %Radians
    t1 = deg2rad(t1_deg);
    t2 = deg2rad(t2_deg);
    t4 = deg2rad(-t4_deg); %Inverse rotating to see same rotation on RoboDk

    z_arm1 = 342;   
    z_arm2 = 394;   
    z_tcp_min = 184;
    L1 = 425;       
    L2 = 375;       
 
    hold on; grid on;
    set(gca, 'Color', [0.15 0.15 0.15], 'XColor', 'w', 'YColor', 'w', 'ZColor', 'w');
    axis([-900 900 -900 900 0 1000]); 
    view([135 30]); 
    xlabel('X, mm'); ylabel('Y, mm'); zlabel('Z, mm');
    
    T0 = eye(4);

    T1 = T0 * transZ(z_arm1) * rotZ(t1);

    T2_base = T1 * transX(L1) * transZ(z_arm2 - z_arm1);
    T2 = T2_base * rotZ(t2);

    T3 = T2 * transX(L2);
 
    T_end = T3 * transZ(z_tcp_min + d3 - z_arm2) * rotZ(t4);
  
    P_floor = [0; 0; 0];
    P_base_top = [0; 0; z_arm1];
    P_elbow_low = T1 * [L1; 0; 0; 1]; P_elbow_low = P_elbow_low(1:3);
    P_elbow_high = T2_base(1:3, 4);
    P_wrist = T3(1:3, 4);
    P_tcp = T_end(1:3, 4);

    %plot3([X1 X2], [Y1 Y2], [Z1 Z2], 'цвет', 'толщина')
    plot3([P_floor(1) P_base_top(1)], [P_floor(2) P_base_top(2)], [P_floor(3) P_base_top(3)], 'w', 'LineWidth', 15);

    plot3([P_base_top(1) P_elbow_low(1)], [P_base_top(2) P_elbow_low(2)], [P_base_top(3) P_elbow_low(3)], 'w', 'LineWidth', 10);

    plot3([P_elbow_low(1) P_elbow_high(1)], [P_elbow_low(2) P_elbow_high(2)], [P_elbow_low(3) P_elbow_high(3)], 'w', 'LineWidth', 8);

    plot3([P_elbow_high(1) P_wrist(1)], [P_elbow_high(2) P_wrist(2)], [P_elbow_high(3) P_wrist(3)], 'w', 'LineWidth', 8);

    plot3([P_wrist(1) P_tcp(1)], [P_wrist(2) P_tcp(2)], [P_wrist(3) P_tcp(3)], 'r', 'LineWidth', 5);

    plot3(P_base_top(1), P_base_top(2), P_base_top(3), 'wo', 'MarkerFaceColor', 'w');
    plot3(P_elbow_high(1), P_elbow_high(2), P_elbow_high(3), 'wo', 'MarkerFaceColor', 'w');
    
    as = 120;
    f1 = create_mobile_frame(as); set(f1, 'Matrix', T1);
    f2 = create_mobile_frame(as); set(f2, 'Matrix', T2);
    
    R_flip = [1 0 0 0; 0 -1 0 0; 0 0 -1 0; 0 0 0 1];
    f4 = create_mobile_frame(as); set(f4, 'Matrix', T_end * R_flip);
end
function T_total = PPP(d1, d2, d3, frames)
    T1_pos = makehgtform('translate', [d1, 0, 0]);
    T1 = T1_pos * makehgtform('yrotate', pi/2);

    T2_pos = T1_pos * makehgtform('translate', [0, d2, 0]);
    T2 = T2_pos * makehgtform('xrotate', -pi/2);

    T3 = T2_pos * makehgtform('translate', [0, 0, d3]);

    frames(1).Matrix = eye(4);
    frames(2).Matrix = T1;
    frames(3).Matrix = T2;
    frames(4).Matrix = T3;

    pts = [0 0 0; d1 0 0; d1 d2 0; d1 d2 d3];
    plot3(pts(:,1), pts(:,2), pts(:,3), 'k-', 'LineWidth', 3);
    
    T_total = T3;
end
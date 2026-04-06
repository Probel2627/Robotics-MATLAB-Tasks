function T_total = RPP(theta1, d2, d3, frames)
    T1 = makehgtform('zrotate', deg2rad(theta1));
    T2 = T1 * makehgtform('translate', [d2, 0, 0]);
    T3 = T2 * makehgtform('translate', [0, 0, d3]);

    frames(1).Matrix = eye(4);
    frames(2).Matrix = T1;
    frames(3).Matrix = T2;
    frames(4).Matrix = T3;

    p1 = [0; 0; 0; 1];
    p2 = T1 * [0; 0; 0; 1];
    p3 = T2 * [0; 0; 0; 1];
    p4 = T3 * [0; 0; 0; 1];
    
    pts = [p1(1:3)'; p2(1:3)'; p3(1:3)'; p4(1:3)'];
    plot3(pts(:,1), pts(:,2), pts(:,3), 'm-', 'LineWidth', 3);

    T_total = T3;
end
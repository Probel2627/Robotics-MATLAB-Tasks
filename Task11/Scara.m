function T_end = Scara(theta1, theta2, d3, theta4, l1, l2)
   
    delete(allchild(gca)); 
    hold on; grid on;
    set(gca, 'Color', [0.15 0.15 0.15], 'XColor', 'w', 'YColor', 'w', 'ZColor', 'w', 'GridColor', [0.5 0.5 0.5]);
    axis([-1 1 -1 1 0 1.2]); 
    view(3); 
    xlabel('X'); ylabel('Y'); zlabel('Z');
    
    d1 = 0.342;
    
    T1 = transZ(d1) * rotZ(theta1);
    f1 = create_mobile_frame(); 
    set(f1, 'Matrix', T1);      
    
    T2 = T1 * transX(l1) * rotZ(theta2);
    f2 = create_mobile_frame();
    set(f2, 'Matrix', T2);
    
    T3_top = T2 * transX(l2);
    
    T4 = T3_top * transZ(-d3) * rotZ(theta4);
    f4 = create_mobile_frame();
    set(f4, 'Matrix', T4);
    
    P_floor = [0; 0; 0]; 
    P1 = T1(1:3, 4); 
    P2 = T2(1:3, 4); 
    P3 = T3_top(1:3, 4); 
    P4 = T4(1:3, 4);
    
    X_coords = [P_floor(1), P1(1), P2(1), P3(1), P4(1)];
    Y_coords = [P_floor(2), P1(2), P2(2), P3(2), P4(2)];
    Z_coords = [P_floor(3), P1(3), P2(3), P3(3), P4(3)];
    
    plot3(X_coords, Y_coords, Z_coords, 'w-o', 'LineWidth', 5, 'MarkerSize', 6, 'MarkerFaceColor', 'w');
    
    T_end = T4; 
end

function T = rotZ(angle)
    T = [cos(angle), -sin(angle), 0, 0; sin(angle), cos(angle), 0, 0; 0, 0, 1, 0; 0, 0, 0, 1];
end
function T = transX(distance)
    T = eye(4); T(1, 4) = distance;
end
function T = transZ(distance)
    T = eye(4); T(3, 4) = distance;
end
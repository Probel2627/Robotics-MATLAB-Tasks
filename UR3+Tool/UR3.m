function [T_flange, T_tcp] = UR3(t1, t2, t3, t4, t5, t6)
    if nargin == 0
        t1 = 0; t2 = -pi/2; t3 = -pi/2; t4 = -pi/2; t5 = pi/2; t6 = 0;
    end

    delete(allchild(gca)); hold on; grid on;
    set(gca, 'Color', [0.15 0.15 0.15], 'XColor', 'w', 'YColor', 'w', 'ZColor', 'w');
    axis([-0.8 0.8 -0.8 0.8 -0.2 1.0]); view(3);
    
    d1 = 0.1519; a2 = -0.24365; a3 = -0.21325; d4 = 0.11235; d5 = 0.08535; d6 = 0.0819;
    
    T0 = eye(4);
    T1 = T0 * DH(t1, d1, 0, pi/2);
    T2 = T1 * DH(t2, 0, a2, 0);
    T3 = T2 * DH(t3, 0, a3, 0);
    T4 = T3 * DH(t4, d4, 0, pi/2);
    T5 = T4 * DH(t5, d5, 0, -pi/2);
    T6 = T5 * DH(t6, d6, 0, 0); 

    tool_roll = deg2rad(90); 
    T_mount = T6 * rotZ(tool_roll); 

    T_p1 = T_mount * transZ(0.100); 
    T_p2 = T_p1 * transX(-0.039);   
    T_p3 = T_p2 * rotY(deg2rad(6.21)) * transZ(0.225); 
    T_p4 = T_p3 * rotY(deg2rad(45)) * transZ(0.111);   

    pts = [T6(1:3,4), T_p1(1:3,4), T_p2(1:3,4), T_p3(1:3,4), T_p4(1:3,4)];
    plot3(pts(1,:), pts(2,:), pts(3,:), 'r', 'LineWidth', 5);
    
    draw_small_frame(T_p4, 0.1);

    robot_pts = [T0(1:3,4), T1(1:3,4), T2(1:3,4), T3(1:3,4), T4(1:3,4), T5(1:3,4), T6(1:3,4)];
    plot3(robot_pts(1,:), robot_pts(2,:), robot_pts(3,:), 'w-o', 'LineWidth', 3, 'MarkerFaceColor', 'w');

    T_flange = T6;
    T_tcp = T_p4;
end

function T = DH(theta, d, a, alpha)
    T = [cos(theta), -sin(theta)*cos(alpha),  sin(theta)*sin(alpha), a*cos(theta);
         sin(theta),  cos(theta)*cos(alpha), -cos(theta)*sin(alpha), a*sin(theta);
         0,           sin(alpha),             cos(alpha),            d;
         0,           0,                      0,                     1];
end

function T = rotY(a); T = [cos(a) 0 sin(a) 0; 0 1 0 0; -sin(a) 0 cos(a) 0; 0 0 0 1]; end
function T = rotZ(a); T = [cos(a) -sin(a) 0 0; sin(a) cos(a) 0 0; 0 0 1 0; 0 0 0 1]; end
function T = transX(dist); T = eye(4); T(1,4) = dist; end
function T = transZ(dist); T = eye(4); T(3,4) = dist; end

function draw_small_frame(T, l)
    p = T(1:3,4); x = p + T(1:3,1)*l; y = p + T(1:3,2)*l; z = p + T(1:3,3)*l;
    plot3([p(1) x(1)], [p(2) x(2)], [p(3) x(3)], 'r', 'LineWidth', 2);
    plot3([p(1) y(1)], [p(2) y(2)], [p(3) y(3)], 'g', 'LineWidth', 2);
    plot3([p(1) z(1)], [p(2) z(2)], [p(3) z(3)], 'b', 'LineWidth', 2);
end
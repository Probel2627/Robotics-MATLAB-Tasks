close all; clear; clc;

Lshape();
xlabel('X'); ylabel('Y'); zlabel('Z');
title('Task 7.1: L-Shape Chain Rule');

base_frame = create_mobile_frame();

T1_0 = [0 -1 0 6; 
        1 0 0 0;
        0 0 1 0;
        0 0 0 1];

T2_1 = [1 0 0 8;
        0 0 -1 0;
        0 1 0 0;
        0 0 0 1];

T3_2 = [0 0 -1 0;
        0 1 0 -3;
        1 0 0 0;
        0 0 0 1];

T4_3 = [0 -1 0 -6;
        1 0 0 0;
        0 0 1 0;
        0 0 0 1];

T2_0 = T1_0 * T2_1;
T3_0 = T2_0 * T3_2;
T4_0 = T3_0 * T4_3;

disp('Frame 1...');
f1 = create_mobile_frame();
translate_XYZ(f1, [1 0 0], 6);
rotation_XYZ(f1, [0 0 1], 90, [6 0 0]);
pause(1); 

disp('Frame 2...');
f2 = create_mobile_frame();
translate_XYZ(f2, [1 0 0], 6);
translate_XYZ(f2, [0 1 0], 8); 
rotation_XYZ(f2, [0 0 1], 90, [6 8 0]); 
rotation_XYZ(f2, [1 0 0], -90, [6 8 0]); 
pause(1);


disp('Frame 3...');
f3 = create_mobile_frame();
translate_XYZ(f3, [1 0 0], 6);
translate_XYZ(f3, [0 1 0], 8);
translate_XYZ(f3, [0 0 1], 3); 

f3.Matrix(1:3, 1:3) = T3_0(1:3, 1:3); 
pause(1);

disp('Frame 4...');
f4 = create_mobile_frame();
translate_XYZ(f4, [0 1 0], 8);
translate_XYZ(f4, [0 0 1], 3); 
f4.Matrix(1:3, 1:3) = T4_0(1:3, 1:3);

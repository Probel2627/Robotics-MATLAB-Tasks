close all; clear; clc;

figure;
Dshape(); 
xlabel('X'); ylabel('Y'); zlabel('Z');
title('Task 7.2: D-Shape Chain Rule Animation');

base_frame = create_mobile_frame();

% --- VISUAL INSPECTION MATRICES ---
% Frame 1: Bottom corner [8, 0, 0]
T1_0 = [1 0 0 8; 0 1 0 0; 0 0 1 0; 0 0 0 1]; 

% Frame 2: Back corner [8, 8, 0], rotated 90 deg around X
T2_1 = [1 0 0 0; 0 0 -1 8; 0 1 0 0; 0 0 0 1];

% Frame 3: Upper back corner [8, 8, 3], rotated 90 deg around Y
T3_2 = [0 0 1 0; 0 1 0 0; -1 0 0 3; 0 0 0 1];

% Frame 4: Top slope corner [8, 3, 8]
T4_3 = [1 0 0 0; 0 1 0 -5; 0 0 1 5; 0 0 0 1];

% Frame 5: Top front corner [8, 0, 8], rotated -90 deg around Z
T5_4 = [0 1 0 0; -1 0 0 -3; 0 0 1 0; 0 0 0 1];

% --- CHAIN RULE CALCULATIONS ---
T2_0 = T1_0 * T2_1;
T3_0 = T2_0 * T3_2;
T4_0 = T3_0 * T4_3;
T5_0 = T4_0 * T5_4;

% --- ANIMATION SEQUENCE ---

disp('Animating Frame 1...');
f1 = create_mobile_frame();
translate_XYZ(f1, [1 0 0], 8); 
pause(1);

disp('Animating Frame 2...');
f2 = create_mobile_frame();
translate_XYZ(f2, [1 0 0], 8);
translate_XYZ(f2, [0 1 0], 8);
rotation_XYZ(f2, [1 0 0], 90, [8 8 0]);
pause(1);

disp('Animating Frame 3...');
f3 = create_mobile_frame();
translate_XYZ(f3, [1 0 0], 8);
translate_XYZ(f3, [0 1 0], 8);
translate_XYZ(f3, [0 0 1], 3);
f3.Matrix(1:3, 1:3) = T3_0(1:3, 1:3);
pause(1);

disp('Animating Frame 4...');
f4 = create_mobile_frame();
translate_XYZ(f4, [1 0 0], 8);
translate_XYZ(f4, [0 1 0], 8);
translate_XYZ(f4, [0 0 1], 3);
translate_XYZ(f4, [0 -1 1], 5)
f4.Matrix(1:3, 1:3) = T4_0(1:3, 1:3);
pause(1);

disp('Animating Frame 5...');
f5 = create_mobile_frame();
translate_XYZ(f5, [1 0 0], 8);
translate_XYZ(f5, [0 0 1], 8);
f5.Matrix(1:3, 1:3) = T5_0(1:3, 1:3);

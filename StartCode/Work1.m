close all
clc

%Making all our 8 points
vertices = [
    0 0 0; 0 2 0; 0 2 2; 0 0 2; %First square 
    5 0 0; 5 2 0; 5 2 2; 5 0 2  %Second square changed only x 
];

%Connecting the points to make faces
faces = [
    1 2 3 4; 
    5 6 7 8; 
    1 2 6 5; 
    2 3 7 6; 
    3 4 8 7; 
    4 1 5 8  
];

%Patching our dotes to make whole figure
h = patch('Vertices', vertices, 'Faces', faces, ...
          'FaceColor', [0.3 0.6 0.9], 'FaceAlpha', 0.6, 'EdgeColor', 'k');  

g = patch('Vertices', vertices, 'Faces', faces, ...
          'FaceColor', 'none', 'FaceAlpha', 0.6, 'EdgeColor', 'r'); 

% Define the initial axes
x_axis = [1 0 0];
y_axis = [0 1 0];
z_axis = [0 0 1];

grid on; axis equal;
view(135, 30); % 3D view
xlabel('X'); ylabel('Y'); zlabel('Z');
title('Rotation and Translation Test');

%Got this recomendation from forum, needed to make picture stable
axis([-20 20 -20 20 -20 20]); 

hold on; 
%Just to see better rotation, higlight the X axis from 0 to 5
axis_length = 3;

line_U = line([0 axis_length], [0 0], [0 0], 'Color', 'r', 'LineWidth', 2);
line_V = line([0 0], [0 axis_length], [0 0], 'Color', 'g', 'LineWidth', 2);
line_W = line([0 0], [0 0], [0 axis_length], 'Color', 'b', 'LineWidth', 2);

text_U = text(axis_length + 0.2, 0, 0, 'U', 'Color', 'r', 'FontWeight', 'bold');
text_V = text(0, axis_length + 0.2, 0, 'V', 'Color', 'g', 'FontWeight', 'bold');
text_W = text(0, 0, axis_length + 0.2, 'W', 'Color', 'b', 'FontWeight', 'bold');

translate_system = hgtransform;
set([h, line_U, line_V, line_W, text_U, text_V, text_W], 'Parent', translate_system);

translate_system_ghost = hgtransform;
set([g, line_U, line_V, line_W, text_U, text_V, text_W], 'Parent', translate_system_ghost);

Lines

hold off;

origin = [0 0 0];


% RZ RX RY RZ | TX TV RU TW
translate_XYZ(translate_system, x_axis, 5)        
translate_UVW(translate_system, 'V', 5)           
rotation_XYZ(translate_system, z_axis, 45, origin)
rotation_UVW(translate_system, 'U', 45)           
rotation_XYZ(translate_system, y_axis, 45, origin) 
rotation_XYZ(translate_system, x_axis, 45, origin)
rotation_XYZ(translate_system, z_axis, 30, origin)
translate_UVW(translate_system, 'W', 5)           

%Ghost
% | RW RU RV RW TU TV RU TW
rotation_UVW(translate_system_ghost, 'W', 30);   
rotation_UVW(translate_system_ghost, 'U', 45);   
rotation_UVW(translate_system_ghost, 'V', 45);   
rotation_UVW(translate_system_ghost, 'W', 45);   
translate_UVW(translate_system_ghost, 'U', 5);   

translate_UVW(translate_system_ghost, 'V', 5);    
rotation_UVW(translate_system_ghost, 'U', 45);    
translate_UVW(translate_system_ghost, 'W', 5);    

disp('Main Matrix');
disp(translate_system.Matrix);
disp('Ghost Matrix');
disp(translate_system_ghost.Matrix);

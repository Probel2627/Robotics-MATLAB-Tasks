function Dshape()
    % Define the vertices of the prismatic object
    Auvw=[0 0 0]'; %1
    Buvw=[0 8 0]';%2
    Cuvw=[0 8 3]';%3
    Duvw=[0 3 8]';%4
    Euvw=[0 0 8]';%5
    Fuvw=[8 0 0]';%6
    Guvw=[8 8 0]';
    Huvw=[8 8 3]';
    Iuvw=[8 3 8]';
    Juvw=[8 0 8]';
    vertices = [Auvw'; Buvw'; Cuvw'; Duvw'; Euvw'; Fuvw'; Guvw'; Huvw'; Iuvw'; Juvw'];
    
    % Define the faces of the prismatic object
    faces = [1 2 3 4 5; 6 7 8 9 10];%; 2 3 4 5;8 9 13 14; 9 8 11 12]%; 6 5 11 12; 4 3 9 10; 4 5 11 10; 1 6 12 7; 1 2 8 7];
    faces2= [1 2 7 6;4 5 10 9;3 4 9 8;2 3 8 7];
    
    % Create a figure window and set the axis properties
    figure;
    view(130, 30);
    limit=10;
    % Set the limits of the axes
    xlim([-limit, limit]);
    ylim([-limit, limit]);
    zlim([-limit, limit]);
    
    grid on;
    hold on;
    
    % Plot the prismatic object
    patch('Vertices', vertices, 'Faces', faces, 'FaceColor', 'k', 'FaceAlpha', 0.1);
    patch('Vertices', vertices, 'Faces', faces2, 'FaceColor', 'k', 'FaceAlpha', 0.1);
end
function Lshape()
    % Define the vertices of the prismatic object
    Auvw=[0 0 0]'; %1
    ABuvw=[0 3 0]';%2
    Buvw=[0 8 0]';%3
    Cuvw=[0 8 3]';%4
    Duvw=[0 3 3]';%5
    Euvw=[0 3 8]';%6
    Fuvw=[0 0 8]';%7
    Guvw=[6 0 0]';
    Huvw=[6 8 0]';
    Iuvw=[6 8 3]';
    Juvw=[6 3 3]';
    Kuvw=[6 3 8]';
    Luvw=[6 0 8]';
    vertices = [Auvw'; Buvw'; Cuvw'; Duvw'; Euvw'; Fuvw'; Guvw'; Huvw'; Iuvw'; Juvw'; Kuvw'; Luvw'];
    
    % Define the faces of the prismatic object
    faces = [1 2 3 4 5 6; 7 8 9 10 11 12];%; 2 3 4 5;8 9 13 14; 9 8 11 12]%; 6 5 11 12; 4 3 9 10; 4 5 11 10; 1 6 12 7; 1 2 8 7];
    faces2= [1 2 8 7;4 3 9 10;6 5 11 12;1 7 12 6;4 10 11 5;2 8 9 3];
    
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

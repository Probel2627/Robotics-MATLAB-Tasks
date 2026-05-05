function h = create_mobile_frame(scale)
    if nargin < 1, scale = 100; end 
    
    h = hgtransform;
    
    line([0 scale], [0 0], [0 0], 'Color', 'r', 'LineWidth', 2.5, 'Parent', h); % X (Красный)
    line([0 0], [0 scale], [0 0], 'Color', 'g', 'LineWidth', 2.5, 'Parent', h); % Y (Зеленый)
    line([0 0], [0 0], [0 scale], 'Color', 'b', 'LineWidth', 2.5, 'Parent', h); % Z (Синий)
    
    text(scale, 0, 0, 'X', 'Color', 'r', 'FontSize', 8, 'FontWeight', 'bold', 'Parent', h);
    text(0, scale, 0, 'Y', 'Color', 'g', 'FontSize', 8, 'FontWeight', 'bold', 'Parent', h);
    text(0, 0, scale, 'Z', 'Color', 'b', 'FontSize', 8, 'FontWeight', 'bold', 'Parent', h);
end
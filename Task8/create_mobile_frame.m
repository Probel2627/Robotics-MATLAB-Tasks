function frame_transform = create_mobile_frame()
    frame_transform = hgtransform;
    
    axis_length = 2;
    
    line([0 axis_length], [0 0], [0 0], 'Color', 'r', 'LineWidth', 2, 'Parent', frame_transform);
    text(axis_length + 0.2, 0, 0, 'X', 'Color', 'r', 'FontWeight', 'bold', 'Parent', frame_transform);

    line([0 0], [0 axis_length], [0 0], 'Color', 'g', 'LineWidth', 2, 'Parent', frame_transform);
    text(0, axis_length + 0.2, 0, 'Y', 'Color', 'g', 'FontWeight', 'bold', 'Parent', frame_transform);
    
    line([0 0], [0 0], [0 axis_length], 'Color', 'b', 'LineWidth', 2, 'Parent', frame_transform);
    text(0, 0, axis_length + 0.2, 'Z', 'Color', 'b', 'FontWeight', 'bold', 'Parent', frame_transform);
end
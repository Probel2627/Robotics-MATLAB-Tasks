function rotation_UVW(transform_container, axis_name, total_angle)
    if axis_name == 'U'
        local_axis = [1 0 0];
    elseif axis_name == 'V'
        local_axis = [0 1 0];
    elseif axis_name == 'W'
        local_axis = [0 0 1];
    else
        error('Use U V or W');
    end

    step_direction = sign(total_angle); 

    R_step = makehgtform('axisrotate', local_axis, deg2rad(step_direction));

    for i = 1:abs(total_angle)

        transform_container.Matrix = transform_container.Matrix * R_step;
        
        drawnow; 
        pause(0.02);
    end
end
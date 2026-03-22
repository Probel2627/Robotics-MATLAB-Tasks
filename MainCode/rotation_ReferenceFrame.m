function rotation_ReferenceFrame(transform_container, global_axis, angle)
    step_direction = sign(angle); 
    R_step = makehgtform('axisrotate', global_axis, deg2rad(step_direction));

    M = transform_container.Matrix;
    current_position = [M(1,4), M(2,4), M(3,4)];
    
    T_to_origin = makehgtform('translate', -current_position);
    T_back = makehgtform('translate', current_position);

    for i = 1:abs(angle)
        transform_container.Matrix = T_back * R_step * T_to_origin * transform_container.Matrix;
        drawnow; 
        pause(0.02); 
    end
end
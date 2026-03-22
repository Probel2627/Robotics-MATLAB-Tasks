function rotation_XYZ(transform_container, direction_axis, angle, origin_point)
    step_direction = sign(angle); 

    R_step = makehgtform('axisrotate', direction_axis, deg2rad(step_direction));

    T_to_origin = makehgtform('translate', -origin_point);
    T_back = makehgtform('translate', origin_point);

    for i = 1:abs(angle)

        transform_container.Matrix = T_back * R_step * T_to_origin * transform_container.Matrix;
        
        drawnow; 
        pause(0.02); 
    end
end
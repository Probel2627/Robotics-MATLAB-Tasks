function translate_XYZ_simple(transform_container, direction_axis, distance)
    step_direction = sign(distance); 
    delta = direction_axis * step_direction; 

    T_step = makehgtform('translate', delta);

    for i = 1:abs(distance)

        transform_container.Matrix = T_step * transform_container.Matrix;
        
        drawnow;
        pause(0.2);
    end
end
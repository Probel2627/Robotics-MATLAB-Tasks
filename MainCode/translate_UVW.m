function translate_UVW(transform_container, axis_name, distance)
    % Определяем базовый вектор локальной оси
    if axis_name == 'U'
        local_axis = [1 0 0];
    elseif axis_name == 'V'
        local_axis = [0 1 0];
    elseif axis_name == 'W'
        local_axis = [0 0 1];
    else
        error('Используйте ''U'', ''V'' или ''W''');
    end

    step_direction = sign(distance); 
    delta = local_axis * step_direction; 
    
    % Создаем матрицу шага перемещения
    T_step = makehgtform('translate', delta);

    for i = 1:abs(distance)
        % Умножаем СПРАВА для перемещения по локальным осям (Tool Frame)
        transform_container.Matrix = transform_container.Matrix * T_step;
        
        drawnow; 
        pause(0.02); 
    end
end
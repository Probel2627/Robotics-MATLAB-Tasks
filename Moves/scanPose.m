clear; clc;
RDK = Robolink;
robot = RDK.Item('UR5');


for i = 1:8
    target_name = sprintf('Target %d', i); % Ищем мишени по именам
    item = RDK.Item(target_name);
    
    if item.Valid()
        pose = item.Pose();
        % Форматируем матрицу в строку, которую поймет MATLAB
        matrix_str = mat2str(pose, 4); 
        fprintf('P{%d} = %s;\n', i, matrix_str);
    else
        fprintf('%% ОШИБКА: Мишень "%s" не найдена в RoboDK!\n', target_name);
    end
end

clear all; clc;

fprintf('Scanning for joysticks...\n');
joy = [];
id_found = 0;

for id = 1:5
    try
        joy = vrjoystick(id);
        fprintf('Success! Found joystick at ID: %d\n', id);
        id_found = id;
        break; 
    catch
    end
end

if isempty(joy)
    error('No joystick found. Check USB and restart MATLAB.');
end

fprintf('========================================\n');
fprintf('JOYSTICK DIAGNOSTIC TOOL\n');
fprintf('Press Button 1 to EXIT.\n');
fprintf('========================================\n\n');

while true
    btns = button(joy);
    axes_data = read(joy);
    pressed_btns = find(btns);
    
    clc;
    fprintf('--- ACTIVE ID: %d ---\n', id_found);
    fprintf('--- BUTTONS ---\n');
    if isempty(pressed_btns)
        fprintf('No buttons pressed.\n');
    else
        fprintf('Active Button(s): %s\n', num2str(pressed_btns));
    end
    
    fprintf('\n--- AXES ---\n');
    for i = 1:length(axes_data)
        fprintf('Axis %d: %+0.3f\n', i, axes_data(i));
    end
    
    if btns(1)
        fprintf('\nExiting...\n');
        break;
    end
    
    pause(0.1); 
end

close(joy);
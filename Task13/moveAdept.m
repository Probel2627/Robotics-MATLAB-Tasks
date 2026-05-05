clear; clc; close all;

try
    RDK = Robolink;

    robot = RDK.Item('', RDK.ITEM_TYPE_ROBOT);
    
    if ~robot.Valid()
        error('No Robot');
    end
    disp('RoboDK: connected');
catch
    error('Error RoboDk');
end

try
    joy = vrjoystick(1);
    disp('joystick con');
catch
    error('no joystick');
end

t1_deg = 0;   
t2_deg = 0;   
d3     = 0;   
t4_deg = 0;   
is_frozen = false;
deadzone  = 0.15;

disp('=====================================================');
disp('DIGITAL TWIN (TASK 13):');
disp('  LB (Button 5)     -> FREEZE');
disp('  Start (Button 8)  -> HOME');
disp('  Button A (Button 1)-> EXIT');
disp('=====================================================');

fig = figure('Name', 'Adept Cobra S800: Digital Twin', 'Color', [0.1 0.1 0.1]);

while true
    axes_data = read(joy);
    btns      = button(joy);

    if btns(1), break; end 

    if btns(8) 
        t1_deg = 0; t2_deg = 0; d3 = 0; t4_deg = 0;
        disp('🏠 Возврат в Home (0, 0, 0, 0)');
        pause(0.2);
    end
    
    if btns(5)
        is_frozen = ~is_frozen;
        if is_frozen, disp('❄️ Заморозка включена'); else, disp('🔥 Управление активно'); end
        pause(0.3);
    end

    if ~is_frozen
      
        speed_rot = 1.5; 
        speed_z   = 5.0; 

        if abs(axes_data(1)) > deadzone, t1_deg = t1_deg + axes_data(1) * speed_rot; end
        if abs(axes_data(2)) > deadzone, t2_deg = t2_deg + axes_data(2) * speed_rot; end
       
        if abs(axes_data(5)) > deadzone, d3 = d3 - axes_data(5) * speed_z; end
     
        if abs(axes_data(4)) > deadzone, t4_deg = t4_deg + axes_data(4) * speed_rot; end
        
        if d3 < 0; d3 = 0; end
        if d3 > 210; d3 = 210; end
    end
    
    %matlab same vis
    cla;
    T_mat = adept(t1_deg, t2_deg, d3, t4_deg); 
   
    robot.setJoints([t1_deg, t2_deg, d3, t4_deg]); 

    clc;
    fprintf('position\n');
    fprintf('Joints: [t1=%.1f°, t2=%.1f°, d3=%.1f мм, t4=%.1f°]\n', t1_deg, t2_deg, d3, t4_deg);
    fprintf('MATLAB TCP (P): [X=%.2f, Y=%.2f, Z=%.2f]\n', T_mat(1,4), T_mat(2,4), T_mat(3,4));
    fprintf('-------------------------\n');
    fprintf('Compare matlab and Robodk\n');
    if d3 == 0,   fprintf('If d3=0 => Z=526.0\n'); end
    if d3 == 210, fprintf('If d3=210 => Z=736.0\n'); end

    drawnow;
    pause(0.01);
end

close(joy);
disp('Программа завершена.');
function translate_XYZ_math(system_to_move, direction_axis, distance)
    %For moving in + and - direction
    step_direction = sign(distance); 
    %Understanding of direction which axis move
    delta = direction_axis * step_direction; 
    %Our 4x4 Matrix
    T_step = [1 0 0 delta(1);
              0 1 0 delta(2);
              0 0 1 delta(3);
              0 0 0 1];
    
    %Main loop
    for i = 1:abs(distance)
        
        %Checking our moving_system list
        for j = 1:length(system_to_move)
            obj = system_to_move(j);
            
            %Code for patch part
            if isgraphics(obj, 'patch')
                %Getting our matrix from vertices
                V = obj.Vertices; 
               
                %Explain in video
                V_homo = [V, ones(size(V, 1), 1)]'; 
                
                V_new_homo = T_step * V_homo;
                
                %Back to 8x3 version
                obj.Vertices = V_new_homo(1:3, :)'; 
            
            %Code for line part    
            elseif isgraphics(obj, 'line')

                P1 = [obj.XData(1); obj.YData(1); obj.ZData(1); 1];
                P2 = [obj.XData(2); obj.YData(2); obj.ZData(2); 1];
 
                P1_new = T_step * P1;
                P2_new = T_step * P2;
             
                obj.XData = [P1_new(1), P2_new(1)];
                obj.YData = [P1_new(2), P2_new(2)];
                obj.ZData = [P1_new(3), P2_new(3)];
           
            %Code for text part    
            elseif isgraphics(obj, 'text')
                Pos = [obj.Position(1); obj.Position(2); obj.Position(3); 1];
                Pos_new = T_step * Pos;
                obj.Position = Pos_new(1:3)';
            end
        end
        
        drawnow; 
        pause(0.2); 
    end
end
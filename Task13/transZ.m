function T = transZ(distance)
    T = eye(4); 
    T(3, 4) = distance;
end
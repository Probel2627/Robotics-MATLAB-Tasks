function T = transX(distance)
    T = eye(4); 
    T(1, 4) = distance;
end
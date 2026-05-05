function A = get_A_matrix(teta, a_param, alpha, d)
    A = [cosd(teta), -cosd(alpha)*sind(teta),  sind(alpha)*sind(teta), a_param*cosd(teta);
         sind(teta),  cosd(alpha)*cosd(teta), -sind(alpha)*cosd(teta), a_param*sind(teta);
         0,           sind(alpha),             cosd(alpha),            d;
         0,           0,                       0,                      1];
end
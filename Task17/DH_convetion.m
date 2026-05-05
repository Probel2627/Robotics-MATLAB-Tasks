teta1 = 0;
teta2 = 90;
teta3 = 0;
teta4 = 0;
teta5 = 0;
teta6 = 0;

alpha1 = -90;
alpha2 = 0;
alpha3 = 90;
alpha4 = -90;
alpha5 = 90;
alpha6 = 0;

a1 = 200;
a2 = -890;
a3 = -150;
a4 = 0;
a5 = 0;
a6 = 0;

d1 = 680;
d2 = 0;
d3 = 0;
d4 = 880;
d5 = 0;
d6 = 140;

A1 = get_A_matrix(teta1, a1, alpha1, d1);
A2 = get_A_matrix(teta2, a2, alpha2, d2);
A3 = get_A_matrix(teta3, a3, alpha3, d3);
A4 = get_A_matrix(teta4, a4, alpha4, d4);
A5 = get_A_matrix(teta5, a5, alpha5, d5);
A6 = get_A_matrix(teta6, a6, alpha6, d6);

fprintf('\n--- A1 ---\n');
disp(A1);

fprintf('---  A2 ---\n');
disp(A2);

fprintf('---  A3 ---\n');
disp(A3);

fprintf('---  A4 ---\n');
disp(A4);

fprintf('---  A5 ---\n');
disp(A5);

fprintf('---  A6 ---\n');
disp(A6);

T_total = A1 * A2 * A3 * A4 * A5 * A6;
disp('Last matrix');
disp(T_total);
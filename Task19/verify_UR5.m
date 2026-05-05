% --- Verification Script for Task 19 ---
clc; clear;

% 1. Определение тестовых конфигураций (углы в радианах)
test_q = [
    0, 0, 0, 0, 0, 0;                    % Home position
    pi/4, -pi/3, pi/2, -pi/4, pi/6, 1.0; % Random pose 1
    -1.2, 0.4, -0.8, 0.1, -0.5, 0.2      % Random pose 2
];

fprintf('Starting UR5 Kinematics Verification...\n');
fprintf('Target Precision: < 1e-08\n\n');

for i = 1:size(test_q, 1)
    q = test_q(i, :);
    
    % Вызов матричной функции (эталон)
    T_mat = UR5(q(1), q(2), q(3), q(4), q(5), q(6));
    
    % Вызов новой функции (Task 19)
    T_ext = UR5_extended(q(1), q(2), q(3), q(4), q(5), q(6));
    
    % Вычисление разности через норму Фробениуса
    error_val = norm(T_mat - T_ext, 'fro');
    
    % Вывод результатов
    fprintf('Test Case %d:\n', i);
    fprintf('  Difference Norm: %.10e\n', error_val);
    
    if error_val < 1e-8
        fprintf('  Result: PASSED\n\n');
    else
        fprintf('  Result: FAILED\n\n');
    end
end
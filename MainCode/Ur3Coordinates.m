base_frame = create_mobile_frame();

figure('Name', 'Live TCP Tracker', 'Color', 'w');
view(3); grid on; hold on;
axis([-800 800 -800 800 -200 800]); 

f1 = create_mobile_frame();
translate_XYZ(f1, [0 0 1], 152)
rotation_XYZ(f1, [1 0 0], -90, [0 0 152])
translate_UVW(f1, [0 0 1], 120)


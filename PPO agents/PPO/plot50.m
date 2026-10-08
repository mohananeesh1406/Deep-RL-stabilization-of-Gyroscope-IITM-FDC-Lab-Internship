
plot(t, y, 'LineWidth', 1.2);
xlabel('Time (s)', 'FontName', 'Times New Roman', 'FontSize', 20);
ylabel('Angular Position \psi (degrees)', 'FontName', 'Times New Roman', 'FontSize', 20);
title('Step Response of PPO Agent', 'FontName', 'Times New Roman', 'FontSize', 20);
yline(50, 'r--', 'LineWidth', 4);


% Set X-axis range from 0 to 100
xlim([0 150]);

set(gca, 'FontName', 'Times New Roman', 'FontSize', 20);
grid on;
% Flywheel stress vs omega^2 - linearised fit
% Collects (omega, sigma_max) pairs interactively, plots sigma vs omega^2,
% fits a straight line, and finds omega_safe for a target safe stress.

n = input('How many data points do you have? ');

omega = zeros(1, n);
sigma = zeros(1, n);

for i = 1:n
    omega(i) = input(sprintf('Enter omega for point %d (rad/s): ', i));
    sigma(i) = input(sprintf('Enter sigma_max for point %d (MPa): ', i));
end

omega_sq = omega.^2;

% Fit a straight line: sigma = k*omega_sq + c
p = polyfit(omega_sq, sigma, 1);
k = p(1);
c = p(2);

% Plot
scatter(omega_sq, sigma, 'filled');
hold on;
fit_line = k*omega_sq + c;
plot(omega_sq, fit_line, 'r-');
xlabel('omega^2 (rad/s)^2');
ylabel('sigma\_max (MPa)');
title('Stress vs omega^2 (linearised)');
grid on;
hold off;

fprintf('Gradient k = %f MPa per (rad/s)^2\n', k);
fprintf('Intercept c = %f MPa\n', c);

% Solve for safe omega given a target safe stress
sigma_safe = input('Enter target safe stress (MPa), e.g. sigma_yield/FoS: ');
omega_safe = sqrt((sigma_safe - c) / k);
fprintf('omega_safe = %f rad/s\n', omega_safe);

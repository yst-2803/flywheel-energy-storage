% Flywheel: motor-driven spin-up then coast-down
% Solved numerically with ode45 (tau is time-varying)

M = 2;               % mass of disc, kg
R = 0.1;              % radius of disc, m
b = 0.05;             % friction coefficient
I = 0.5*M*R^2;        % moment of inertia, solid disc

tau_0 = 1;            % motor torque while engaged, Nm
t_cutoff = 3;         % motor disengages at 3s

tau_func = @(t) tau_0 * (t < t_cutoff);   % torque on until cutoff, then zero
odefun = @(t, omega) (tau_func(t) - b*omega) / I;

tspan = [0 8];        % solve from t=0 to t=8 seconds
omega0 = 0;           % initial condition: starts at rest

[t, omega] = ode45(odefun, tspan, omega0);   % call ode45

% --- numeric outputs ---
idx_cutoff = find(t >= t_cutoff, 1);
omega_at_cutoff = omega(idx_cutoff);
omega_final = omega(end);

printf("Omega at motor cutoff (t=3s): %.4f rad/s\n", omega_at_cutoff);
printf("Omega at end of run (t=8s): %.6f rad/s\n", omega_final);

% --- piecewise analytic solution, for verification against ode45 ---
omega1 = @(t) (tau_0/b) * (1 - exp(-(b/I)*t));             % stage 1: torque applied
omega_at_cut = omega1(t_cutoff);
omega2 = @(t) omega_at_cut * exp(-(b/I)*(t - t_cutoff));   % stage 2: coasting down

omega_analytic = zeros(size(t));
omega_analytic(t < t_cutoff) = omega1(t(t < t_cutoff));
omega_analytic(t >= t_cutoff) = omega2(t(t >= t_cutoff));

err = abs(omega - omega_analytic);
printf("Max error, ode45 vs piecewise analytic: %.6f rad/s (%.4f%% of peak)\n", ...
    max(err), max(err)/max(omega)*100);

% --- plotting (yours, unchanged) ---
plot(t, omega, 'LineWidth', 1.5);
xline(t_cutoff, '--k', 'Motor cutoff');
xlabel('Time (s)');
ylabel('Angular velocity, omega (rad/s)');
title('Flywheel: motor-driven spin-up then coast-down');
grid on;

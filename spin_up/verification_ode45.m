M = 2; R = 0.1; b = 0.05; I = 0.5*M*R^2;
tau_0 = 1; t_cutoff = 3;

% Two ode45 calls, split exactly at the discontinuity
odefun_on  = @(t, omega) (tau_0 - b*omega) / I;
odefun_off = @(t, omega) (0 - b*omega) / I;

[ta, omega_a] = ode45(odefun_on, [0 t_cutoff], 0);
[tb, omega_b] = ode45(odefun_off, [t_cutoff 8], omega_a(end));

t = [ta; tb(2:end)];
omega = [omega_a; omega_b(2:end)];

% Piecewise analytic solution, same as before
omega1 = @(t) (tau_0/b) * (1 - exp(-(b/I)*t));
omega_at_cut = omega1(t_cutoff);
omega2 = @(t) omega_at_cut * exp(-(b/I)*(t - t_cutoff));

omega_analytic = zeros(size(t));
omega_analytic(t < t_cutoff) = omega1(t(t < t_cutoff));
omega_analytic(t >= t_cutoff) = omega2(t(t >= t_cutoff));

err = abs(omega - omega_analytic);
printf("Omega at cutoff (split method): %.6f rad/s\n", omega_a(end));
printf("Max error, split ode45 vs analytic: %.6f rad/s (%.4f%% of peak)\n", ...
    max(err), max(err)/max(omega)*100);

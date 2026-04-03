clear; close all; clc;

%% Daten
load(fullfile('Daten_G.mat'))

u = Daten_G.signals.values(:,2); 
y = Daten_G.signals.values(:,1); 
t = Daten_G.time;
T = t(2) - t(1); 
N = length(y);

%% Aufgabe d) IV4 Algorithmus

k_start = 4;
L = N - k_start + 1;


y_tilde = y(k_start:end) - y(k_start-3:end-3);
Psi = build_reduced_regressor(y, u, k_start, N);
theta_LS = (Psi' * Psi) \ (Psi' * y_tilde);


[A_ls, B_ls] = params_to_poly(theta_LS);
h = filter(B_ls, A_ls, u); % Hilfsvariable
W = build_reduced_regressor(h, u, k_start, N);
theta_IV = (W' * Psi) \ (W' * y_tilde);


[A_iv, B_iv] = params_to_poly(theta_IV);
epsilon = filter(A_iv, 1, y) - filter(B_iv, 1, u);
Psi_e = -epsilon(1:N-1);
y_e   =  epsilon(2:N);
d1 = (Psi_e' * Psi_e) \ (Psi_e' * y_e);
D_filter = [1, d1];


y_f = filter(D_filter, 1, y);
u_f = filter(D_filter, 1, u);
h_new = filter(B_iv, A_iv, u);
h_f   = filter(D_filter, 1, h_new);

y_tilde_f = y_f(k_start:end) - y_f(k_start-3:end-3);
Psi_f = build_reduced_regressor(y_f, u_f, k_start, N);
W_f   = build_reduced_regressor(h_f, u_f, k_start, N);

theta_IV4 = (W_f' * Psi_f) \ (W_f' * y_tilde_f);

%% Ergebnisse 
alpha1 = theta_IV4(1);
alpha2 = theta_IV4(2);
alpha3 = -(alpha1 + alpha2 + 1);
beta1  = theta_IV4(3);
beta2  = theta_IV4(4);
beta3  = theta_IV4(5);

fprintf('--- Identifizierte Diskrete Parameter ---\n');
fprintf('alpha1 = %.5f\nalpha2 = %.5f\nalpha3 = %.5f\n', alpha1, alpha2, alpha3);
fprintf('beta1  = %.5f\nbeta2  = %.5f\nbeta3  = %.5f\n', beta1, beta2, beta3);

%% Aufgabe e) Modellvergleich

[A_final, B_final] = params_to_poly(theta_IV4);
y_sim = filter(B_final, A_final, u);

figure('Name', 'Modellvalidierung', 'Color', 'w');
plot(t, y, 'b', 'LineWidth', 1); hold on;
plot(t, y_sim, 'r', 'LineWidth', 1);
grid on;
legend('Messung y', 'Simulation y_{sim}');
xlabel('Zeit [s]'); ylabel('Winkel');
title('Vergleich: Messdaten vs. Identifiziertes Modell (IV4)');

%% 5. Aufgabe e) Physikalische Parameter bestimmen


fprintf('\n--- Berechnung physikalischer Parameter (fsolve) ---\n');


E2 = alpha1 + alpha2 + 1;
if E2 <= 0

    x0 = [1e-3; 1e-3; 10; 0.1]; 
else
    E = sqrt(E2);
    C_est = log(E) / T;
    
    cos_w0T = -(alpha1 + 1) / (2 * E);
    cos_w0T = max(min(cos_w0T, 1), -1); 
    w0_est = acos(cos_w0T) / T;
    

    term = T * (E2 - 1);
    if abs(term) < 1e-9, term = 1e-9; end
    A0 = (beta3 - beta1) / term;
    
    sin_val = E * sin(w0_est * T);
    if abs(sin_val) < 1e-9, sin_val = 1e-9; end
    B0 = (beta1 - A0 * T) / sin_val;
    

    if abs(A0) < 1e-9, S = 1000; else, S = 1/A0; end
    r = B0 * w0_est * S;
    
    JM0 = S / (1 + r);
    JL0 = r * JM0;
    d0  = -(2 * C_est * JM0 * JL0) / S;
    c0  = (w0_est^2 + C_est^2) * (JM0 * JL0) / S;
    
    x0 = abs([JM0; JL0; c0; d0]);
    fprintf('Startwerte (Analytisch): JM=%.2e, JL=%.2e, c=%.2f, d=%.2e\n', ...
        x0(1), x0(2), x0(3), x0(4));
end

% --- B. Optimierung (fsolve) ---

options = optimoptions('fsolve', ...
    'Display', 'off', ...           
    'FunctionTolerance', 1e-12, ...
    'StepTolerance', 1e-12, ...
    'MaxFunctionEvaluations', 20000);

% Gleichungssystem lösen: F(x) = 0
fun = @(x) phys_eq_system(x, theta_IV4, T);
[phys_params, residuum, exitflag, output] = fsolve(fun, x0, options);

JM_id = phys_params(1);
JL_id = phys_params(2);
c_id  = phys_params(3);
d_id  = phys_params(4);

fprintf('fsolve abgeschlossen (Exitflag: %d)\n', exitflag);
fprintf('Restfehler (Norm) = %.5e\n', norm(residuum));
fprintf('\n--- Identifizierte Physikalische Parameter ---\n');
fprintf('JM = %.5e [kg m^2]\n', JM_id);
fprintf('JL = %.5e [kg m^2]\n', JL_id);
fprintf('c  = %.5e [N m/rad]\n', c_id);
fprintf('d  = %.5e [N m s/rad]\n', d_id);


%% === Lokale Funktionen ===

function Psi = build_reduced_regressor(y_sig, u_sig, k0, N)
    % Spalte 1: -(y(k-1) - y(k-3))
    col1 = -(y_sig(k0-1:N-1) - y_sig(k0-3:N-3));
    % Spalte 2: -(y(k-2) - y(k-3))
    col2 = -(y_sig(k0-2:N-2) - y_sig(k0-3:N-3));

    col3 = u_sig(k0-1:N-1);
    col4 = u_sig(k0-2:N-2);
    col5 = u_sig(k0-3:N-3);
    Psi = [col1, col2, col3, col4, col5];
end

function [A, B] = params_to_poly(theta)

    a1 = theta(1);
    a2 = theta(2);
    a3 = -(a1 + a2 + 1);
    b1 = theta(3);
    b2 = theta(4);
    b3 = theta(5);
    A = [1, a1, a2, a3];
    B = [0, b1, b2, b3];
end

function F = phys_eq_system(x, theta_id, T)

    JM = x(1); JL = x(2); c = x(3); d = x(4);
    

    A_coeff = 1 / (JM + JL);
    C = -((JM + JL) * d) / (2 * JM * JL); 
    
    term1 = ((JM + JL) * c) / (JM * JL);
    w0_sq = term1 - C^2;

    if w0_sq < 0, w0_sq = 0; end 
    w0 = sqrt(w0_sq);
    
    if w0 < 1e-9, B_coeff = 0; else
        B_coeff = JL / ((JM + JL) * JM * w0);
    end
    

    a1_theo = -2 * exp(C*T) * cos(w0*T) - 1;
    a2_theo = exp(2*C*T) + 2 * exp(C*T) * cos(w0*T);
    
    b1_theo = A_coeff*T + B_coeff*exp(C*T)*sin(w0*T);
    b2_theo = -2*A_coeff*T*exp(C*T)*cos(w0*T) - 2*B_coeff*exp(C*T)*sin(w0*T);
    b3_theo = A_coeff*T*exp(2*C*T) + B_coeff*exp(C*T)*sin(w0*T);
    
    % Residuum: Differenz zwischen Theorie und Identifikation
    F = [ a1_theo - theta_id(1);
          a2_theo - theta_id(2);
          b1_theo - theta_id(3);
         %b2_theo - theta_id(4);
          b3_theo - theta_id(5)]; 
end
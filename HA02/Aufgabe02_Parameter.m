% =========================================================================
% =========================================================================
clear; clc;

% --- 1. Gegebene Systemparameter ---
J = 4.2e-4;             
T_sigma_omega = 0.003;  
T = 0.0005;             
M_max = 0.15;          

% Streckenverstärkung
K_S = 1/J;

% --- 2. Auslegung b): P-T1-Entwurf ---
% Streckenpol (diskret)
d_Strecke = exp(-T / T_sigma_omega); 

% DBO Parameter 
z_N_b = d_Strecke;                  
K_DBO_b = J / (2 * T_sigma_omega);  

% Umrechnung auf Summenform (Trapezregel) für Implementierung
% Formeln aus Teilaufgabe e)
Kp_b_impl = K_DBO_b * (1 + z_N_b) / 2;
Ki_b_impl = K_DBO_b * (1 - z_N_b) / T;
Ki_sum_b  = Ki_b_impl * T / 2;      

% Führungsfilter b) Parameter
% G_F(z) = (1-z_N) * z / (z - z_N)
num_F_b = [(1 - z_N_b), 0];
den_F_b = [1, -z_N_b];



% --- 3. Auslegung d): Totzeit-Entwurf  ---
k_steps = T_sigma_omega / T; % k = 6

% Berechnung d1 
term_root = sqrt(1 + 8*k_steps + 8*k_steps^2);
num_d1 = 1 + 4*k_steps + 4*k_steps^2 + term_root;
den_d1 = 4 * (1 + k_steps)^2;
d1_d = -num_d1 / den_d1; 

% Berechnung Kp 
num_Kp = 1 + 4*k_steps - term_root;
den_Kp = 2 * k_steps^2 * T * K_S;
K_DBO_d = num_Kp / den_Kp;

% Umrechnung auf Summenform (Trapezregel)
% Der Reglerterm ist K * (1 + d1 * z^-1) / (1 - z^-1)
% Das entspricht K * (z + d1) / (z - 1).
% Die Nullstelle z_N liegt also bei -d1_d.
z_N_d = -d1_d; 

Kp_d_impl = K_DBO_d * (1 + z_N_d) / 2;
Ki_d_impl = K_DBO_d * (1 - z_N_d) / T;
Ki_sum_d  = Ki_d_impl * T / 2;

% Führungsfilter d) Parameter
% G_F(z) = (1 + d1) / (1 + d1 * z^-1) = (1+d1)z / (z + d1)
num_F_d = [(1 + d1_d), 0];
den_F_d = [1, d1_d];


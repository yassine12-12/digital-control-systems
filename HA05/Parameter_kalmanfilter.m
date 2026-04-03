clear; clc;

%% ==== Parameter aus Aufgabenblatt ====
T    = 1e-4;        % Abtastzeit
J    = 4.22e-4;     % Trägheitsmoment
T_EM = 0.0011;      % Zeitkonstante


A_a = [0 1 0;
       0 0 1/J;
       0 0 -1/T_EM];

B_a  = [0; 0; 1/T_EM];     % Eingang u = M_M*
Bz_a = [0; -1/J; 0];       % Störung z = M_L (als Störeingang)
Ce_a = [1 0 0];            % Messmatrix y = eps

A_b = [A_a   Bz_a;
       0 0 0 0];

B_b = [B_a;
       0];

Ce_b = [Ce_a 0];           % y = eps

alpha = exp(-T/T_EM);

%% -------------------------
%% Fall a) OHNE Störgröße 
%% -------------------------
Phi_T_a = [ 1, T, (T_EM/J)*(T - T_EM*(1-alpha));
            0, 1, (T_EM/J)*(1-alpha);
            0, 0, alpha ];

H_a = [ (1/J)*(T^2/2 - T_EM*T + T_EM^2*(1-alpha));
        (1/J)*(T - T_EM*(1-alpha));
        (1-alpha) ];

P_0_a = eye(3);
R_a   = 1e-6;
Q_a   = diag([10 10 10]);

%% -------------------------
%% Fall b) MIT Störgröße 
%% -------------------------
Phi_T_b = [ 1, T, (T_EM/J)*(T - T_EM*(1-alpha)),  -(T^2)/(2*J);
            0, 1, (T_EM/J)*(1-alpha),             -T/J;
            0, 0, alpha,                           0;
            0, 0, 0,                               1 ];

H_b = [ (1/J)*(T^2/2 - T_EM*T + T_EM^2*(1-alpha));
        (1/J)*(T - T_EM*(1-alpha));
        (1-alpha);
        0 ];

P_0_b = eye(4);
R_b   = 1e-6;
Q_b   = diag([10 10 10 1000]);
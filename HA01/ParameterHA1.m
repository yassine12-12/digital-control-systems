J = 4.2e-4;         % Trägheitsmoment [kg*m^2]

% Zeitkonstanten
T_EM = 3e-3;        % elektrische/mechanische Zeitkonstante [s]
T = 1e-3;           % Abtastzeit [s]
T_AH = T / 2;       % Zeitkonstante des Abtast- und Halteglieds [s]
T1 = T_EM + T_AH;   % zusammengefasste Zeitkonstante [s]

% Strecke (I–T1)
K_I = 1 / J;        % statische Verstärkung der Strecke

% Reglerparameter nach Betragsoptimum
K_p = 1 / (2 * K_I * T1);  % Reglerverstärkung
T_n = 4 * T1;              % Nachstellzeit [s]

% Führungsfilter (bei Betragsoptimum T_F = T_n)
T_F = T_n;
syms s t T J T_EM real positive

% Systemmatrizen (kontinuierlich)
A = [0 1 0;
     0 0 1/J;
     0 0 -1/T_EM];

B = [0; 0; 1/T_EM];

I = eye(size(A));

% 1) Phi(t) über Laplace-Rücktransformation:
%    Phi(t) = L^{-1}{ (sI - A)^(-1) }
Phi_t = simplify(ilaplace(inv(s*I - A), s, t));

% 2) Phi(T) (diskrete Zustandsmatrix, Abtastzeit = T)
Phi = simplify(subs(Phi_t, t, T));

% 3) H = ∫_0^{T} Phi(t) * B dt
H = simplify(int(Phi_t * B, t, 0, T));

Phi     % diskrete Zustandsmatrix
H       % diskrete Eingangsmatrix
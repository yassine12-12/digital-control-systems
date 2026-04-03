syms s t T J T_EM real positive

% erweiterter Zustand: x_e = [eps; omega; M_M; z]
Ae = [ 0  1        0        0;
       0  0      1/J     -1/J;
       0  0   -1/T_EM     0;
       0  0        0        0 ];

Be = [0; 0; 1/T_EM; 0];

Ie = eye(size(Ae));

% 1) Übergangsmatrix Phi_e(t) = L^{-1}{ (sI - Ae)^(-1) }
Phi_e_t = ilaplace(inv(s*Ie - Ae), s, t);
Phi_e_t = simplify(Phi_e_t);

% 2) Diskrete Zustandsmatrix Phi_e = Phi_e(T)
Phi_e = simplify(subs(Phi_e_t, t, T));

% 3) Diskrete Eingangsmatrix
%    H_e = ∫_0^{T} Phi_e(t) * Be dt
H_e = simplify(int(Phi_e_t * Be, t, 0, T));

Phi_e     % diskrete Übergangsmatrix
H_e       % diskrete Eingangsmatrix
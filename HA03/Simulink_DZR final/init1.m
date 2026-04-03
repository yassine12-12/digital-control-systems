clear all
syms T1 T2 Ks e T w0   
syms J Ts             
%% geg. Strecke 
A=[ 0      1/J ;
    0   -1/Ts ];

B=[ 0 ;
    1/Ts ];

C=[1 0];
D=[0];

%% Transformation berechnen  
phi=[ 1,     (Ts/J)*(1-exp(-T/Ts)) ;
      0,      exp(-T/Ts)          ];

H=[ (1/J)*( T - Ts*(1-exp(-T/Ts)) ) ;
     (1-exp(-T/Ts)) ];

Su = [H phi*H];
Su_inv = Su^-1;
TR = [Su_inv(2,:); Su_inv(2,:)*phi];

phiR = simplify(TR*phi*inv(TR));
CR  = simplify(C*inv(TR));

a0 = exp(-T/Ts);
a1 = -(1 + exp(-T/Ts));

b0 = (Ts - (T + Ts)*exp(-T/Ts)) / J;
b1 = (T - Ts*(1 - exp(-T/Ts))) / J;


an = 1;

%% Dead-Beat-Regler berechnen
r1=-a0;
r2=-a1;
R=[r1 r2];
q1z = 1/(b0+b1);

%% Binomial-Regler berechnen 
P2=1;
P1bin = -2*exp(-w0*T);
P0bin = exp(-2*w0*T);

r1bin = P0bin/P2*an - a0;
r2bin = P1bin/P2*an - a1;
Rbin  = [r1bin r2bin];

q1zbin = ((a0+r1bin)+(a1+r2bin)+an)/(b0+b1);

%% Regler nach Butterworth berechnen
we = w0/sqrt(2);     

P2=1
P1=-2*exp(-we*T)*cos(we*T)
P0=exp(-2*we*T)

r1b=P0/P2*an-a0
r2b=P1/P2*an-a1
q1zb = ((a0+r1b)+(a1+r2b)+an)/(b0+b1)
Rb=[r1b r2b]

%% Streckenparameter
J  = 4.2e-4;     % kg*m^2
Ts = 3e-3;       % s

%% Abtastzeit
T = 0.5e-3;      % s

%% Reglerparameter
w0 = 10/Ts
%% Simulationsparameter
tsim  = 0.2;     
tstep = 0.05;     
%% Substitution
q1z    = double(subs(q1z));
R      = double(subs(R));

q1zbin = double(subs(q1zbin));
Rbin   = double(subs(Rbin));

q1zb   = double(subs(q1zb));
Rb     = double(subs(Rb));

A    = double(subs(A));
B    = double(subs(B));
C    = double(subs(C));
H    = double(subs(H));
phi  = double(subs(phi));
TR   = double(subs(TR));

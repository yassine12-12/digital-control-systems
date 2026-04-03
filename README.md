# Digital Control Systems

![MATLAB](https://img.shields.io/badge/MATLAB-0076A8?style=for-the-badge&logo=mathworks&logoColor=white)
![Simulink](https://img.shields.io/badge/Simulink-0076A8?style=for-the-badge&logo=mathworks&logoColor=white)

MATLAB/Simulink implementations of digital control techniques applied to a rotational electromechanical system — a motor driving an inertial load (J = 4.2×10⁻⁴ kg·m², T_EM = 3 ms).

---

### HA01 — Quasi-Continuous PI Control
PI controller designed via the Betragsoptimum method. Sample-and-hold modelled as T_AH = T/2. Includes discrete command pre-filter.

### HA02 — Digital Magnitude Optimum
Two discrete PI designs: P-T1 pole placement and a dead-time compensating design (k = 6 delay steps). Both use trapezoidal sum-form implementation.

### HA03 — State-Space Controller
State-feedback controllers via three pole placement strategies: Dead-Beat (z = 0), Binomial, and Butterworth. Matrices derived symbolically via Laplace inversion.

### HA04 — Parameter Identification
IV4 (Instrumental Variables) system identification of a two-mass system. Extracts discrete transfer function coefficients, then recovers physical parameters (J_M, J_L, c, d) via `fsolve`.

### HA05 — Kalman Filter
Discrete Kalman filter for state estimation (angle, velocity, motor torque). Extended to a 4-state model with load torque disturbance estimation.

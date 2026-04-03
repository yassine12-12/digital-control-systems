# Digital Control Systems

![MATLAB](https://img.shields.io/badge/MATLAB-0076A8?style=for-the-badge&logo=mathworks&logoColor=white)
![Simulink](https://img.shields.io/badge/Simulink-0076A8?style=for-the-badge&logo=mathworks&logoColor=white)

MATLAB/Simulink implementations of digital control techniques applied to a **rotational electromechanical system** — a motor driving an inertial load (J = 4.2×10⁻⁴ kg·m²) with electrical/mechanical time constant T_EM = 3 ms.

---

## Structure

```
HA01/   Quasi-continuous control (Betragsoptimum)
HA02/   Digital magnitude optimum — P-T1 and dead-time designs
HA03/   Digital state-space controller (Dead-Beat, Binomial, Butterworth)
HA04/   Parameter identification (IV4 algorithm)
HA05/   Kalman filter design (with and without disturbance)
```

---

### HA01 — Quasi-Continuous Control
**Topic:** Design of a quasi-continuous PI controller using the **Betragsoptimum** (magnitude optimum) method.

- Models the sample-and-hold element as an equivalent time delay T_AH = T/2
- Derives controller gains K_p and T_n from the combined time constant T₁ = T_EM + T_AH
- Includes a command pre-filter G_F(s)
- Simulated in Simulink (`HA01.slx`)

Key files: `HA01/ParameterHA1.m`, `HA01/HA01.slx`

---

### HA02 — Digital Magnitude Optimum
**Topic:** Discrete-time PI controller design — two approaches:

- **P-T1 design:** Discrete pole placement using the Betragsoptimum; controller implemented in sum form via the trapezoidal rule
- **Dead-time design:** Accounts for the k = T_σ/T = 6 step delay; optimal controller zeros derived analytically
- Both designs include a discrete command pre-filter G_F(z)
- Simulated in Simulink (`DR_Aufgabe02.slx`)

Key files: `HA02/Aufgabe02_Parameter.m`, `HA02/DR_Aufgabe02.slx`

---

### HA03 — Digital State-Space Controller
**Topic:** State-feedback controller design via pole placement — three methods:

- **Dead-Beat:** Places all closed-loop poles at z = 0 (finite settling time)
- **Binomial:** Places poles at z = exp(−ω₀T)
- **Butterworth:** Maximally flat frequency response pole placement
- State-space matrices (Φ, H) derived symbolically via Laplace inversion in MATLAB
- Simulated in Simulink (`digitaler_zr.mdl`)

Key files: `HA03/Simulink_DZR final/init1.m`, `HA03/Simulink_DZR final/digitaler_zr.mdl`

---

### HA04 — Parameter Identification
**Topic:** System identification of a **two-mass system** using the **IV4 (Instrumental Variables of order 4)** algorithm.

- Loads measured input/output data (`Daten_G.mat`)
- Implements least-squares (LS) estimation then iterates with IV4 for bias-free estimates
- Identifies discrete transfer function coefficients (α₁, α₂, α₃, β₁–β₃)
- Recovers physical parameters (J_M, J_L, c, d) via `fsolve`
- Model validation by comparing simulated vs. measured output

Key files: `HA04/HA04GP1.m`

---

### HA05 — Kalman Filter
**Topic:** Discrete Kalman filter design for state estimation of the rotational system.

- **ha5a.m:** Derives discrete state-transition matrix Φ and input matrix H symbolically (3-state: angle ε, velocity ω, motor torque M_M)
- **ha5b.m:** Extended 4-state model with load torque disturbance — two filter designs:
  - **Case a** — without disturbance state (3×3)
  - **Case b** — with disturbance state (4×4)
- Simulated in Simulink (`Einmassensystem.slx`)

Key files: `HA05/Parameter_kalmanfilter.m`, `HA05/ha5a.m`, `HA05/ha5b.m`

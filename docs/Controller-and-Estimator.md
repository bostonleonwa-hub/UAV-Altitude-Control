# PID Controller and Kalman State Estimator

## PID altitude controller

The controller uses the error between commanded altitude and feedback altitude:

$$
e(t) = z_{\mathrm{ref}}(t)-z_{\mathrm{fb}}(t)
$$

The continuous-time PID controller includes a filtered derivative term:

$$
U_{\mathrm{PID}}(s)=\left(K_p+\frac{K_i}{s}+K_d\frac{Ns}{s+N}\right)E(s)
$$

| Parameter | Value |
|---|---|
| Proportional gain, $K_p$ | 34.19 |
| Integral gain, $K_i$ | 4.39 |
| Derivative gain, $K_d$ | 24.42 |
| Derivative filter coefficient, $N$ | 10 |
| Anti-windup | Back-calculation |

Derivative filtering reduces noise-driven thrust fluctuations. Anti-windup mitigates integrator buildup when commanded thrust reaches actuator limits.

## Sensor and low-pass filter

The simulated altitude sensor adds zero-mean measurement noise with a standard deviation of 0.02 m, sampled at 100 Hz. A first-order low-pass filter provides smoothed altitude feedback:

$$
H(s)=\frac{1}{0.02s+1}
$$

The Kalman estimator receives the raw noisy altitude measurement separately from the low-pass-filtered signal.

## Discrete Kalman state estimator

The state consists of altitude and vertical velocity:

$$
x_k=\begin{bmatrix}z_k\\v_k\end{bmatrix}
$$

The discrete state-space model is:

$$
x_{k+1}=Ax_k+Bu_k+w_k
$$

$$
y_k=Cx_k+v_k^{\mathrm{noise}}
$$

At $T_s=0.01\ \mathrm{s}$:

$$
A = \begin{bmatrix}
1 & 0.01 \\
0 & 1
\end{bmatrix},
\qquad
B = \begin{bmatrix}
0.00005 \\
0.01
\end{bmatrix},
\qquad
C = \begin{bmatrix}
1 & 0
\end{bmatrix}
$$

The known model input is commanded thrust correction converted to acceleration:

$$
u_k=\frac{u_{\mathrm{PID}}}{m}
$$

The altitude measurement noise variance is:

$$
R=(0.02)^2=0.0004\ \mathrm{m}^2
$$

The estimator does not directly receive the wind disturbance. Its altitude and velocity estimates can therefore be compared with true simulated states to assess robustness to unmodeled forces.

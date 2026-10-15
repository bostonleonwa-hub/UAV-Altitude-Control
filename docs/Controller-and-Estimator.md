# PID Controller and Kalman State Estimator

## Closed-loop architecture

The feedback altitude used by the PID controller is the **Kalman-estimated altitude**, not the raw noisy altitude measurement. The filter also estimates vertical velocity, but the PID uses only the estimated altitude component.

## PID altitude controller

The tracking error is

$$
e(t)=z_{\mathrm{ref}}(t)-\hat z(t).
$$

The continuous-time parallel PID controller uses a filtered derivative term:

$$
U_{\mathrm{PID}}(s)=\left(K_p+\frac{K_i}{s}+K_d\frac{Ns}{s+N}\right)E(s).
$$

| Parameter | Final setting |
|---|---:|
| Proportional gain, $K_p$ | 46.5 |
| Integral gain, $K_i$ | 4.38969736985132 |
| Derivative gain, $K_d$ | 27 |
| Derivative filter coefficient, $N$ | 6.5 |
| Anti-windup | Clamping |
| PID correction bounds | −14.715 to +15.285 N |
| Applied thrust bounds | 0 to 30 N |

Hover-thrust feedforward ($mg=14.715$ N) is added to the PID correction before actuator saturation. Clamping anti-windup prevents continued integrator buildup while the correction saturates in the direction of error.

## Altitude measurement

The simulated sensor adds zero-mean noise with standard deviation $\sigma_z=0.02$ m at a 0.01 s sampling interval. Its measurement variance is

$$
R=\sigma_z^2=(0.02)^2=0.0004\ \mathrm{m}^2.
$$

The final validation uses a fixed seed (`12345`) in the Simulink Random Number block. A previously documented low-pass filter is not the PID feedback source in the validated configuration; **estimated altitude from the Kalman filter is the feedback signal**.

## Discrete two-state Kalman estimator

The estimated state is

$$
x_k=\begin{bmatrix}z_k\\v_{z,k}\end{bmatrix}.
$$

The simplified constant-acceleration discrete model is

$$
x_{k+1}=Ax_k+Bu_k+w_k,\qquad y_k=Cx_k+\nu_k,
$$

with $T_s=0.01$ s and

$$
A=\begin{bmatrix}1&0.01\\0&1\end{bmatrix},\qquad
B=\begin{bmatrix}0.00005\\0.01\end{bmatrix},\qquad
C=\begin{bmatrix}1&0\end{bmatrix}.
$$

Here $u_k$ is modeled vertical acceleration from the known thrust correction, $w_k$ is process-model uncertainty, and $\nu_k$ is measurement noise. The wind force is not directly provided as a known filter input, so estimation error may increase during the disturbance.

## Validated estimation accuracy

| Metric | Result |
|---|---:|
| Raw altitude sensor RMSE | 0.019887 m |
| Kalman altitude RMSE | 0.009352 m |
| Relative altitude RMSE reduction | 52.97% |
| Kalman vertical velocity RMSE | 0.111240 m/s |

See [Testing and Results](testing-and-results.md) for the definitions and flight-phase analysis.

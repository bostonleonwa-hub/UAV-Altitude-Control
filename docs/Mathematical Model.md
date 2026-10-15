# UAV Altitude Control — Mathematical Model

## Model parameters

| Parameter | Symbol | Value |
|---|---|---|
| Mass | $m$ | 1.5 kg |
| Gravity | $g$ | 9.81 m/s² |
| Nominal hover thrust | $T_{\mathrm{hover}}$ | 14.715 N |
| Thrust saturation | $T$ | 0–30 N |
| Altitude reference | $z_{\mathrm{ref}}$ | 10 m, step at 1 s |
| Wind disturbance | $F_w$ | −3 N during 20–25 s |
| Kalman sampling interval | $T_s$ | 0.01 s |

## Vertical dynamics

The model treats upward altitude as positive. Newton's second law gives

$$
m\ddot z=T-mg+F_w,
\qquad \ddot z=\frac{T-mg+F_w}{m}.
$$

Simulink integrates acceleration to obtain vertical velocity and altitude:

$$
\dot v_z=\ddot z,\qquad \dot z=v_z.
$$

## Hover feedforward and actuator saturation

At stationary hover without disturbance:

$$
T_{\mathrm{hover}}=mg=(1.5)(9.81)=14.715\ \mathrm{N}.
$$

The PID controller supplies a correction relative to hover thrust:

$$
T_{\mathrm{cmd}}=mg+u_{\mathrm{PID}},\qquad
T=\operatorname{sat}(T_{\mathrm{cmd}},0,30).
$$

The PID correction is constrained consistently with the thrust actuator, from $-14.715$ to $+15.285$ N.

For $F_w=-3$ N, the equilibrium thrust during the disturbance is

$$
T_{\mathrm{hover,wind}}=mg-F_w=17.715\ \mathrm{N}.
$$

The −3 N force corresponds to a $-2$ m/s² acceleration contribution for a 1.5 kg vehicle **before feedback compensation**.

## Scope

The model assumes constant mass and gravity, one-dimensional vertical motion, and idealized actuator response subject to thrust limits. Attitude dynamics, aerodynamic drag, ground contact, and motor lag are not modeled.

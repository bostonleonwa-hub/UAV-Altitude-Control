# UAV Altitude Control — Mathematical Model

## System parameters

| Parameter | Symbol | Value |
|---|---|---|
| Vehicle mass | $m$ | 1.5 kg |
| Gravitational acceleration | $g$ | 9.81 m/s² |
| Hover thrust | $T_{\mathrm{hover}}$ | 14.715 N |
| Thrust limits | $T$ | 0–30 N |
| Altitude command | $z_{\mathrm{ref}}$ | 10 m |
| Wind disturbance | $F_w$ | −3 N, from 10–15 s |
| Estimator sample period | $T_s$ | 0.01 s (100 Hz) |

## Vertical dynamics

The UAV is modeled as a one-dimensional vertical system. Newton's second law gives:

$$
m\ddot{z} = T - mg + F_w
$$

Therefore, vertical acceleration is:

$$
\ddot{z} = \frac{T - mg + F_w}{m}
$$

Two cascaded integrators in Simulink calculate vertical velocity and altitude from acceleration. The model assumes constant mass and gravity, and omits aerodynamic drag, attitude dynamics, motor response delays, and ground contact.

## Hover thrust and actuator limits

At stationary hover without external disturbances:

$$
T_{\mathrm{hover}} = mg = (1.5)(9.81) = 14.715\ \mathrm{N}
$$

The controller commands hover thrust plus a feedback correction:

$$
T_{\mathrm{cmd}} = mg + u_{\mathrm{PID}}
$$

The actuator limits applied thrust:


$$
T = \mathrm{sat}(T_{\mathrm{cmd}}, 0, 30)
$$
  

For a constant downward disturbance of $F_w=-3\ \mathrm{N}$, stationary hover requires:

$$
T_{\mathrm{hover,wind}} = mg-F_w = 17.715\ \mathrm{N}
$$

[mathematical-model.md](https://github.com/user-attachments/files/33178893/mathematical-model.md)
# Mathematical Model — UAV Vertical Altitude Control

## Purpose and scope
This project simulates **one-dimensional vertical motion** of a simplified UAV. It is a controls and estimation demonstration, **not** a complete multirotor flight-dynamics or motor model. Positive altitude, velocity, and thrust are upward.

## Variables and parameters
| Symbol | Description | Value or units |
|---|---|---|
| $`m`$ | Vehicle mass | $`1.5\ \mathrm{kg}`$ |
| $`g`$ | Gravitational acceleration | $`9.81\ \mathrm{m/s^2}`$ |
| $`z`$ | True altitude | m |
| $`v=\dot z`$ | True vertical velocity | m/s |
| $`a=\ddot z`$ | True vertical acceleration | $`\mathrm{m/s^2}`$ |
| $`z_c`$ | Commanded altitude | m; test target 10 m |
| $`T`$ | Applied upward thrust | N, constrained to $`[0,30]`$ |
| $`F_w`$ | External vertical disturbance | N; test applies $`-3`$ N |
| $`u_{PID}`$ | PID thrust correction relative to hover | N |
| $`T_s`$ | Estimator sample period | 0.01 s (100 Hz) |
## Force balance


Newton's second law gives:

$$
m\ddot{z} = T -mg + F_W
$$

Thus, the vertical acceleration is:

```math
a = \frac{T - mg + F_w}{m}
```

Two cascaded integrators in Simulink produce velocity and altitude from acceleration.

## Hover thrust and motor limits

At steady hover without a disturbance, acceleration and wind force are zero.

$$
T_{\mathrm{hover}} = mg = (1.5)(9.81) = 14.715\ \mathrm{N}
$$

The controller requests thrust as a hover feedforward plus a feedback correction:

$$
T_{\mathrm{cmd}} = mg + u_{\mathrm{PID}}
$$

The motor model limits the applied thrust:

$$
T = \operatorname{sat}(T_{\mathrm{cmd}}, 0, 30)
$$

For a constant downward disturbance of -3 N, the thrust required for stationary hover is:

$$
T_{\mathrm{hover,wind}} = mg - F_w = 17.715\ \mathrm{N}
$$

This explains the expected thrust increase during the wind test.

## Altitude reference and measurements
The test commands an altitude step from 0 m to 10 m at approximately $`t=1`$ s. The model adds sampled measurement noise to the true altitude:


```math
z_m[k]=z[k]+n[k],\qquad n[k]\sim\mathcal N(0,\sigma_z^2),
```


where $`\sigma_z=0.02`$ m (2 cm), sampled at 100 Hz. The noise model is a simulation assumption, not a characterization of a particular physical sensor.

A first-order low-pass filter is available:


```math
H(s)=\frac{1}{0.02s+1}.
```


The project also contains a discrete Kalman estimator that fuses noisy altitude measurements with a simplified motion model.

## Signals and notation
| Signal | Meaning |
|---|---|
| $`z_c`$ | Desired altitude |
| $`z_{true}`$ | Actual simulated altitude from the plant |
| $`z_m`$ | Noisy altitude sensor measurement |
| $`z_f`$ | Low-pass-filtered altitude |
| $`\hat z`$ | Kalman-estimated altitude |
| $`v_{true}`$ | Actual simulated vertical velocity |
| $`\hat v`$ | Kalman-estimated vertical velocity |

## Simulink implementation
![Final vertical dynamics subsystem](../figures/architecture/03-vertical-dynamics.png)

For the full signal flow, see [system architecture](../figures/architecture/01-system-architecture.png). The controller and estimator are documented separately in [PID Controller](pid-controller.md) and [Kalman Filter](kalman-filter.md).

## Modeling limitations
The simulation has ideal instantaneous thrust response within the actuator limits, no explicit drag, no horizontal axes, and no sensor bias model. These assumptions make it suitable for introductory GNC analysis but not direct deployment on hardware.

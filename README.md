# UAV Altitude Control and State Estimation

**MATLAB / Simulink · PID Control · Kalman Filtering · State-Space Modeling**

A one-dimensional UAV simulation integrating **closed-loop PID altitude control**, **actuator saturation and anti-windup**, **noisy altitude sensing**, and a **discrete Kalman filter** that estimates altitude and vertical velocity. The PID uses **Kalman-estimated altitude as its feedback signal**.

The project evaluates a 10 m altitude step, a −3 N downward disturbance, estimation accuracy, and reproducibility under fixed-seed sensor noise. All results below are **simulation results**, not flight-test measurements.

## Validated results

| Metric | Fixed-seed result |
|---|---:|
| 2% settling time (relative to command at 1 s) | **2.72 s** |
| 1% settling time | **7.56 s** |
| Peak overshoot | **3.93%** |
| Maximum altitude deviation during wind (20–25 s) | **4.96 cm** |
| Hover thrust standard deviation (15–20 s) | **2.834 N** |
| Raw altitude sensor RMSE | **1.989 cm** |
| Kalman altitude RMSE | **0.935 cm** |
| Reduction in altitude RMSE | **52.97%** |
| Kalman vertical velocity RMSE | **0.1112 m/s** |

The final controller was validated over **30 s** with a fixed Random Number block seed. Repeating the same simulation produced identical logged altitude and thrust outputs.

## Simulation plots

### Altitude tracking

![Final altitude tracking](Figures/Results/final-altitude-tracking.png)

The commanded altitude steps to 10 m at 1 s. The wind disturbance acts from 20–25 s.

### Disturbance rejection and thrust

![Final thrust response](Figures/Results/final-thrust-response.png)

A 1.5 kg vehicle requires **14.715 N** to hover without wind and **17.715 N** to balance the −3 N disturbance at steady hover. Instantaneous commanded thrust fluctuates due to feedback and measurement noise.

### Kalman state estimation

![Altitude estimation error](Figures/Results/final-kalman-altitude-error.png)

The Kalman filter reduced altitude estimation RMSE by **52.97%** relative to the raw noisy altitude measurement over the 30-second simulation.

![Velocity estimation](Figures/Results/final-velocity-estimation.png)

Vertical velocity was estimated from the filter's two-state model, with **0.1112 m/s** RMSE against simulated true velocity.

## Final model configuration

| Parameter | Value |
|---|---|
| Vehicle mass | 1.5 kg |
| Gravity | 9.81 m/s² |
| Hover thrust | 14.715 N |
| Actuator limits | 0–30 N |
| Altitude target | 10 m, commanded at 1 s |
| Wind disturbance | −3 N, 20–25 s |
| Altitude sensor noise | Zero mean, standard deviation 0.02 m |
| Sensor / Kalman sample time | 0.01 s (100 Hz) |
| Random Number block seed | 12345 (fixed-noise validation) |
| PID `Kp`, `Ki`, `Kd` | 46.5, 4.38969736985132, 27 |
| PID derivative filter coefficient `N` | 6.5 |
| PID anti-windup | Clamping |
| PID feedback | Kalman-estimated altitude |
| Kalman states | Altitude, vertical velocity |

## Architecture and methods

1. **Dynamics:** Model vertical acceleration from thrust, gravity, and external force, then integrate to velocity and altitude.
2. **Altitude sensor:** Add zero-mean random measurement noise to true altitude.
3. **State estimator:** Use a discrete Kalman filter to estimate altitude and vertical velocity from noisy altitude observations.
4. **PID feedback:** Use estimated altitude to calculate thrust correction; combine with hover-thrust feedforward and limit applied thrust to 0–30 N.
5. **Validation:** Compare controller response, disturbance rejection, estimation RMSE, and fixed-seed repeatability.

**Scope:** This is a simplified vertical-motion model. It does not simulate full six-degree-of-freedom flight, attitude control, aerodynamic drag, motor response lag, or real hardware.

## Documentation

- [Mathematical Model](docs/Mathematical-Model.md) — force balance, hover thrust, actuator limits.
- [Controller and Estimator](docs/Controller-and-Estimator.md) — PID and Kalman equations and configuration.
- [Testing and Results](docs/Testing-and-Results.md) — measurement definitions, numerical results, and limitations.

## Repository structure

- `Model/` — Simulink model
- `Scripts/` — MATLAB initialization and analysis scripts
- `Figures/Architecture/` — model architecture images
- `Figures/Development/` — tuning and development images
- `Figures/Results/` — final and historical result figures
- `docs/` — project documentation

**Project focus:** Guidance, Navigation, and Control (GNC), feedback control, disturbance rejection, and state estimation.

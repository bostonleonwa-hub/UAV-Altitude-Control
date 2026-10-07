%% Altitude Controller Initialization
% Initializes vehicle, controller, sensor, filter,
% and Kalman estimator parameters.

%% Simulation
Ts = 0.01;                  % Sample time [s]
sampleRate = 1/Ts;          % 100 Hz


%% Vehicle Parameters
m = 1.5;                    % Vehicle mass [kg]
g = 9.81;                   % Gravity [m/s^2]

hoverThrust = m*g;          % Hover thrust [N] = 14.715 N

T_min = 0;                  % Minimum thrust [N]
T_max = 30;                 % Maximum thrust [N]


%% PID Controller
Kp = 34.1948073252816;
Ki = 4.38969736985132;
Kd = 24.4181996821772;

N_pid = 10;                 % Derivative filter coefficient

% PID thrust-correction limits
u_min = T_min - hoverThrust;
u_max = T_max - hoverThrust;


%% Altitude Sensor
sigma_z = 0.02;             % Measurement standard deviation [m]

R = sigma_z^2;              % Measurement noise covariance
% R = 0.0004


%% Low-Pass Filter
tau = 0.02;                 % Filter time constant [s]

LPF_num = 1;
LPF_den = [tau 1];


%% Kalman Filter Model
% State vector:
% x = [altitude;
%      vertical velocity]

A = [1 Ts;
    0  1];

B = [0.5*Ts^2;
    Ts];

C = [1 0];

D = 0;

% Discrete state-space model
droneEstimator = ss(A,B,C,D,Ts);


%% Kalman Noise Covariances

Q = [1e-6  0;
    0     0.005];

R = 0.0004;

N = [0;
    0];


%% Display initialization message
disp('Altitude Controller initialized successfully.')
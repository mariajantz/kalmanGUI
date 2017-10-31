function [loc, loc_meas, loc_est] = Kalman_filter(duration, dt, value, inp_ns, sig_ns)

A = [1 dt; 0 1];
B = [dt^2/2, dt^2/2; dt, dt];
C = [1 0];

%direction vector
if value(1) == 'U'
    reach = [0 1; 0 1;];
elseif value(1) == 'D'
    reach = [0 -1; 0 -1;];
elseif value(1) == 'R'
    reach = [1 0; 1 0;];
elseif value(1) == 'L'
    reach = [-1 0; -1 0;];
end
%reach = [1 0; 1 0];
B = B*reach;

u = 1.5; %acceleration magnitude
state =[0,0;0,0]; %initial state;
est = state; %estimate of position
acc_noise_mag = inp_ns;%0.05; %variability in movement
sig_noise_mag = sig_ns;%10;%10; % noise in signal
ez = sig_noise_mag^2; %error from signal noise
ex = acc_noise_mag^2 * [dt^4/4 dt^3/2; dt^3/2 dt^2]; %error from variance 
%Steve refers to ex as 'Q'
P = ex; %covariance

loc = []; %actual location
vel = []; %actual velocity
loc_meas = []; %measured location

for t = 0:dt:duration
    acc_noise = acc_noise_mag * [(dt^2/2)*randn, (dt^2/2)*randn; dt*randn, dt*randn];
    state = A*state+B*u+acc_noise; % state is the position and velocity B*u is the change in position as a function of acceleration
    %this model assumes a constant acceleration and direction
    sig_noise1 = sig_noise_mag*randn;
    sig_noise2 = sig_noise_mag*randn;
    y(1) = state(1,1)+sig_noise1;%C*state
    y(2) = state(1,2)+sig_noise2;
    loc = [loc; state(1,:)];
    loc_meas = [loc_meas; y];
    vel = [vel; state(2)];
    %pause
end

loc_est = [];
vel_est = [];
P_est = P;
P_mag_est = [];
pre_state = [];
pre_var = [];
for t = 1:length(loc)
    est = A*est+B*u;
    pre_state = [pre_state; est(1,:)];
    P = A*P*A'+ex;
    pre_var = [pre_var;P];
    K = P*C'*inv(C*P*C'+ez);
    est = est + K * (loc_meas(t) - C*est);
    P = (eye(2)-K*C)*P;
    loc_est = [loc_est; est(1,:)];
    vel_est = [vel_est; est(2,:)];
    P_mag_est = [P_mag_est; P(1)];
end
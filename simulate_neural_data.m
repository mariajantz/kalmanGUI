function simdata = simulate_neural_data

%place targets
targets = 8; 
for targ = 1:targets
    x(targ) = cos(2*pi*targ/targets); 
    y(targ) = sin(2*pi*targ/targets); 
end
plot(x, y, 'ok', 'LineWidth', 3); hold on; 

%generate sample points based on line
%TODO: could update this in terms of a parabola
pick_target = 3; 
num_samps = 20; 
xpts = 0:x(pick_target)/num_samps:x(pick_target);
ypts = 0:y(pick_target)/num_samps:y(pick_target);
plot(xpts, ypts, '.-b', 'Linewidth', 2); 

%make neurons that are tuned to diff directions
neurons = 16; 
pd = 2*pi*rand(16, 1); 
xn = cos(pd); 
yn = sin(pd); 
plot(xn, yn, '+m'); 
%add Poisson-generated noise




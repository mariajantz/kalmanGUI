%function simdata = simulate_neural_data

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

%calculate how those neurons would respond to the given path
for t=2:num_samps
    reachdir = atan(ypts(t)/xpts(t)); 
    %basically do backwards population vector to calculate each neuron's
    %response - not sure about this
    %TODO
end
%add Poisson-generated noise




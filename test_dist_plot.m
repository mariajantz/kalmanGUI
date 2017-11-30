close all;
mcell = {[1 0] [0 0] [5 .5]};
pcell = {[1 .1; .1 1], [.5 0; 0 1], [1 .1; .1 .5]}; %MUST BE SQUARE POSITIVE MATRIX

plot_dist(mcell, pcell); 

function plot_dist(mu_cell, phi_cell)
%define colors for the signal, model, and combined distributions
redcolors = [184 6 0; 229 136 125]/255; %dark, then light
bluecolors = [12 48 181; 134 154 219]/255;
greencolors = [35 97 15; 112 176 83]/255;
colors = {redcolors, bluecolors, greencolors}; 

for i=1:3
    mu = mu_cell{i}; 
    phi = phi_cell{i};
ell_cell = calc_ellpr(mu, phi); 
figure(10); hold on;
plot(ell_cell{1}(:, 1), ell_cell{1}(:, 2), 'Linewidth', 2, 'Color', colors{i}(1, :));
plot(ell_cell{2}(:, 1), ell_cell{2}(:, 2), 'Linewidth', 2, 'Color', colors{i}(2, :));
axis equal; 
end

end

function ellipse_pr = calc_ellpr(mu, phi)
%calculate F, midpt, sd, inds for sd1 and sd2 
%call function to return ellipse array

%TODO: set this according to actual values
%should use mu + 2* sqrt of variance to determine limits
%choose the range of the plot
varmat = sqrt(phi)*2.5; %calculate the std dev matrix
nsamples = 200; 
x = (mu(1)-varmat(1, 1)):(2*varmat(1, 1)/nsamples):(mu(1)+varmat(1, 1)); 
y = (mu(2)-varmat(2, 2)):(2*varmat(2, 2)/nsamples):(mu(2)+varmat(2, 2)); 
[X,Y] = meshgrid(x,y);
%calculate multivariate normal distribution
F = mvnpdf([X(:) Y(:)],mu,phi); 
F = reshape(F,length(y),length(x));
%find high middle point 
[midpt, idx] = max(F(:)); 
[row, col] = ind2sub(size(F), idx);
%find 1, 2 std dev
sdev = std(F(:, col)); 
%discrimination value = how selectively it finds circle
discval = .01;
sd1inds = not(abs(sign(sign(midpt-sdev-discval - F) + sign(midpt-sdev+discval - F))));
sd2inds = not(abs(sign(sign(midpt-2*sdev-discval - F) + sign(midpt-2*sdev+discval - F))));

%assign values and center on zero
%and normalize back to mu location
ell_vals1 = (calc_ell(sd1inds)-[row,col]).*([range(x) range(y)]/nsamples) + mu;
ell_vals2 = (calc_ell(sd2inds)-[row,col]).*([range(x) range(y)]/nsamples) + mu;

ellipse_pr = {ell_vals1, ell_vals2};
end

function ellipse_arr = calc_ell(inds)
%switch these values to the correct coordinate system for normal plotting
%and normalize to the correct scale
[row, col]=find(inds>0);
%for each row, find the extreme columns
vals1 = []; vals2 = [];
for x=1:length(col)
    xidx = find(col==col(x));
    vals1(end+1, :) = [row(min(xidx)), col(x)]; 
    vals2(end+1, :) = [row(max(xidx)), col(x)]; 
end
ellipse_arr = [[vals1(:, 1); flipud(vals2(:, 1)); vals1(1, 1)], ...
    [vals1(:, 2); flipud(vals2(:, 2)); vals1(1, 2)]];

end


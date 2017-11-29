close all;
mu = [1 0];
Sigma = [.1 .1; .1 1];

%define colors for the signal, model, and combined distributions
redcolors = [184 6 0; 229 136 125]/255; %dark, then light
bluecolors = [12 48 181; 134 154 219]/255;
greencolors = [35 97 15; 112 176 83]/255;

%switch these values to the correct coordinate system for normal plotting
%and normalize to the correct scale
ell_cell = calc_ellpr(mu, Sigma); 
figure; hold on;
plot(ell_cell{1}(:, 1), ell_cell{1}(:, 2), 'Linewidth', 2, 'Color', redcolors(1, :));
plot(ell_cell{2}(:, 1), ell_cell{2}(:, 2), 'Linewidth', 2, 'Color', redcolors(2, :));
axis equal; 

function ellipse_pr = calc_ellpr(mu, phi)
%calculate F, midpt, sd, inds for sd1 and sd2 
%call function to return ellipse array

%TODO: set this according to actual values
%choose the range of the plot
x = -3:.01:3; y = -3:.01:3;
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

%assign values and normalize back to mu location
ell_vals1 = (calc_ell(sd1inds)-[row,col])/length(x) + mu;
ell_vals2 = (calc_ell(sd2inds)-[row,col])/length(x) + mu;

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


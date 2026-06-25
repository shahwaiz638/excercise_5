function plotClassEllipsoids(mu, covm, color)
% 1. Get eigenvalues (D) and eigenvectors (V)
[V, D] = eig(covm);

% The lengths of the semi-axes are the square roots of the eigenvalues
% (which represent 1 standard deviation along the principal axes)
radii_1std = sqrt(diag(D))';

% Define the standard deviations we want to plot
stdDevs = [1, 2, 3];

% Loop through 1, 2, and 3 standard deviations
for sd = stdDevs
    % Scale the base radii by the standard deviation level
    current_radii = radii_1std * sd;

    % Generate a standard axis-aligned ellipsoid at the origin
    % syntax: ellipsoid(xc, yc, zc, xr, yr, zr, n)
    [X, Y, Z] = ellipsoid(0, 0, 0, current_radii(1), current_radii(2), current_radii(3), 30);

    % Rotate and translate the ellipsoid points
    % Pack points into an N x 3 matrix
    pts = [X(:), Y(:), Z(:)];

    % Apply rotation (V) and shift to the mean (mu)
    rotated_pts = (pts * V') + mu(:)';

    % Reshape back into surface grids for plotting
    X_rot = reshape(rotated_pts(:,1), size(X));
    Y_rot = reshape(rotated_pts(:,2), size(Y));
    Z_rot = reshape(rotated_pts(:,3), size(Z));

    % Plot the ellipsoid surface with transparency (Alpha)
    mesh(X_rot, Y_rot, Z_rot, 'FaceColor', 'none', 'EdgeColor', color, 'EdgeAlpha', 0.2);
end

% 2. Plot the Principal Axes (drawn out to 3 standard deviations)
for d = 1:3
    % Direction vector of the principal axis
    axis_direction = V(:, d)'; 
    % Half-length of the axis at 3 standard deviations
    half_length = radii_1std(d) * 3; 

    % Calculate start and end points for the line
    p_start = mu(:)' - half_length * axis_direction;
    p_end   = mu(:)' + half_length * axis_direction;

    % Draw the principal axis line using matlab's line() function
    line([p_start(1), p_end(1)], ...
        [p_start(2), p_end(2)], ...
        [p_start(3), p_end(3)], ...
        'Color', color, 'LineWidth', 2);
end

% Plot the center mean point
plot3(mu(1), mu(2), mu(3), 'k.', 'MarkerSize', 15);
end
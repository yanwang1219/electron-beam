clf; clear;
%% Parameters.
space_size = [20, 10];  % space size in z and x direction.
plate_length = 8;       % the lengh of plate, which holds electrons.
plate_left_z = 5.5;       % the central position of left plate pair. x default to 0
plate_righ_z = 14.5;      % the central position of right plate pair. x default to 0
n_q = 100;              % number of electrons on each plate.
d = 4;                  % Distance between two plates in a pair.
resolution = 5;        % How many points in each meter.
q = 1;                  % Electrical amplitude of each electron.
m = 2;                  % the mass of electron.
X0 = [0, 1, 30, 0];    % partical initial state: [z, x, z_dot, x_dot]
delta_t = 0.01;         % simulation time step.
t_max = 10000;           % max simulation time steps.

%% Generate space Electrical field.
z = linspace(0, space_size(1), space_size(1) * resolution);
x = linspace(-space_size(2) / 2, space_size(2) / 2, space_size(2) * resolution);
[z_mesh, x_mesh] = meshgrid(z,x);
[Ez, Ex] = x_selector(z_mesh, x_mesh, plate_length, ...
    plate_left_z, plate_righ_z, d, n_q, q);
quiver(z_mesh, x_mesh, Ez, Ex);
%% Run simulation
% 1. get electrical field applied on partical.
trajectory = zeros(t_max, length(X0));
trajectory(1,:) = X0;
for i = 2:t_max + 1
    E_partical = [...
        interp2(z_mesh, x_mesh, Ez, trajectory(i-1, 1), trajectory(i-1, 2)), ...
        interp2(z_mesh, x_mesh, Ex, trajectory(i-1, 1), trajectory(i-1, 2))];
    trajectory(i,:) = ...
        electron(trajectory(i-1,:), E_partical, delta_t, q, m);  
end
trajectory = trajectory(1:i,:);     % drop zeros
quiver(z_mesh, x_mesh, Ez, Ex);
hold on;
plot(trajectory(:,1), trajectory(:,2));

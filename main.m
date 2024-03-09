clf; clear;
%% Parameters.
space_size = [40, 10, 10];  % space size in z and x direction.
plate_length = 8;       % the lengh of plate, which holds electrons.
plate_left_z1_y1 = [5.5, 0];     % the central position of left plate pair. x default to 0
plate_righ_z2_y2 = [14.5,0];    % the central position of right plate pair. x default to 0
plate_left_z1_x1 = [23.5, 0];     % the central position of left plate pair. x default to 0
plate_righ_z2_x2 = [32.5,0]; 
plate_width = 8;
n_z = 5;              % number of electrons on each plate.
n_y = 5;
n_x = 5;
d = 8;                  % Distance between two plates in a pair.
resolution = 5;         % How many points in each meter.
q = 1;                  % Electrical amplitude of each electron.
m = 2;                  % the mass of electron.
X0 = [0, -1, -1, 15,0, 0];     % partical initial state: [z, x, y, z_dot, x_dot,y_dot]
delta_t = 0.01;         % simulation time step.
t_max = 10000;          % max simulation time steps.

%% Generate space Electrical field.
z = linspace(0, space_size(1), space_size(1) * resolution);     % splite z-axis equally
x = linspace(-space_size(2) / 2, space_size(2) / 2, ...
    space_size(2) * resolution);                                % splite the x-axis equally
y = linspace(-space_size(3)/2, space_size(3)/2, space_size(3) * resolution);
[z_mesh, x_mesh, y_mesh] = meshgrid(z,x,y);                               % splite the space according to z,x
[Ez_x_selector,Ex_x_selector,Ey_x_selector] = x_selector(z_mesh, x_mesh, y_mesh,plate_length,  ...
    plate_left_z1_y1(1),plate_left_z1_y1(2), plate_righ_z2_y2(1), plate_righ_z2_y2(2), d, n_z, n_y, 1, q);
[Ez_y_selector,Ex_y_selector,Ey_y_selector] = y_selector(z_mesh, x_mesh, y_mesh,plate_length,  ...
    plate_left_z1_x1(1),plate_left_z1_x1(2), plate_righ_z2_x2(1), plate_righ_z2_x2(2), d, n_z, 1, n_x,q);
Ez = Ez_x_selector + Ez_y_selector; %Ez_y_selector;
Ex = Ex_x_selector + Ex_y_selector; %Ex_y_selector;
Ey = Ey_x_selector + Ey_y_selector; %Ey_y_selector;
%quiver(z_mesh(:, :, 25), x_mesh(:, :, 25), Ez, Ex)
quiver3(z_mesh, x_mesh, y_mesh, Ez, Ex, Ey);                                 % plot arrows with directional components
%% Run simulation
% 1. get electrical field applied on partical.
trajectory = zeros(t_max, length(X0));      % create trajectory array
trajectory(1,:) = X0;                       % initial trajectory
for i = 2:t_max + 1
    E_partical = [...
        interp3(z_mesh, x_mesh, y_mesh, Ez, ...
            trajectory(i-1, 1), trajectory(i-1, 2), trajectory(i-1, 3)), ...
        interp3(z_mesh, x_mesh,y_mesh, Ex, ...
            trajectory(i-1, 1), trajectory(i-1, 2),trajectory(i-1, 3)), ...
        interp3(z_mesh, x_mesh,y_mesh,  Ey, ...
            trajectory(i-1, 1), trajectory(i-1, 2), trajectory(i-1, 3))];               % get electriacl field strength applied on partical.
    trajectory(i,:) = ...
        electron(trajectory(i-1,:), E_partical, delta_t, q, m);     % get the next state of electron
    if trajectory(i,1) < 0 ||...
            trajectory(i,1) > space_size(1) || ...
            trajectory(i,2) < - space_size(2) / 2 ||...
            trajectory(i,2) > space_size(2) / 2 ||...
            trajectory(i,3) > space_size(3)  ||...
            trajectory(i,3) < - space_size(3) / 2 
        break;
    end
        
end
trajectory = trajectory(1:i,:);                                     % drop zeros
quiver3(z_mesh, x_mesh,y_mesh, Ez, Ex, Ey);                                     % plot the electrical field
hold on;
xlim([0 space_size(1)]);
quiver3(trajectory(1:i-1,1), ...                                     % plot the trajactory of electron
    trajectory(1:i-1,2), ...
    trajectory(1:i-1,3), ...
    trajectory(2:i,1) - trajectory(1:i-1,1), ...
    trajectory(2:i,2) - trajectory(1:i-1,2),...
    trajectory(2:i,3) - trajectory(1:i-1,3),...
    'AutoScale','off');  
                                                                        
xlabel('z-axis');                                                   % plot settings 
ylabel('y-axis');
zlabel('x-axis');
title('Electron beam system');
legend('electrical field','particle')

clf; clear;
%% Parameters.
space_size = [40, 10, 10];                                                 % space size along z, x, y direction.
plate_length = 8;                                                          % the length of plate.
plate_left_z1_y1 = [5.5, 0];                                               % z,y coordinates of the central position of left plate pair in x-selector. 
plate_righ_z2_y2 = [14.5,0];                                               % z,y coordinates of the central position of right plate pair in x-selector.
plate_left_z1_x1 = [23.5, 0];                                              % z,x coordinates of the central position of left plate pair in y-selector.  
plate_righ_z2_x2 = [32.5,0];                                               % z,x coordinates of the central position of right plate pair in y-selector.  
n_z = 5;                                                                   % number of electrons on each plate along z-axis.
n_y = 5;                                                                   % number of electrons on each plate along y-axis. For y selector, will be replaced by 1.
n_x = 5;                                                                   % number of electrons on each plate along x-axis. For x selector, will be replaced by 1.
d = 8;                                                                     % distance between two plates in one pair plate.
resolution = 5;                                                            % how many points in each meter.
q = 1;                                                                     % electrical amplitude of each electron.
m = 2;                                                                     % the mass of electron.
X0 = [0, -1, -1, 15,0, 0];                                                 % initial state of released particle: [z-velocity, x-velocity, y-velocity, z-acceleration, x-acceleration, y-acceleration]
delta_t = 0.01;                                                            % simulation time step.
t_max = 10000;                                                             % max simulation time steps.

%% Generate space Electrical field.
z = linspace(0, space_size(1), space_size(1) * resolution);                % splite z-axis equally.
x = linspace(-space_size(2) / 2, space_size(2) / 2, ...
    space_size(2) * resolution);                                           % splite x-axis equally.
y = linspace(-space_size(3)/2, space_size(3)/2,...
    space_size(3) * resolution);                                           % splite y-axis equally.
[z_mesh, x_mesh, y_mesh] = meshgrid(z,x,y);                                % splite the space according to z, x, y
[Ez_x_selector,Ex_x_selector,Ey_x_selector] = x_selector(z_mesh,...        % calculate electrical field from x-selector
    x_mesh, y_mesh,plate_length,  ...
    plate_left_z1_y1(1),plate_left_z1_y1(2), plate_righ_z2_y2(1),...
    plate_righ_z2_y2(2), d, n_z, n_y, 1, q);
[Ez_y_selector,Ex_y_selector,Ey_y_selector] = y_selector(z_mesh,...        % calculate electrical field from y-selector 
    x_mesh, y_mesh,plate_length,  ...
    plate_left_z1_x1(1),plate_left_z1_x1(2), plate_righ_z2_x2(1),...
    plate_righ_z2_x2(2), d, n_z, 1, n_x,q);
Ez = Ez_x_selector + Ez_y_selector;                                        % whole electrical field from x- and y-selector along z-axis.
Ex = Ex_x_selector + Ex_y_selector;                                        % whole electrical field from x- and y-selector along x-axis.
Ey = Ey_x_selector + Ey_y_selector;                                        % whole electrical field from x- and y-selector along y-axis.

%% plot space Electrical field.
downsampling_ratio = 7;                                                    % plot electrical field but with downsampling resolution.                                       
E_field_fig = quiver3(z_mesh(1:downsampling_ratio:end,...
    1:downsampling_ratio:end, 1:downsampling_ratio:end), ...
    x_mesh(1:downsampling_ratio:end,...
    1:downsampling_ratio:end, 1:downsampling_ratio:end), ...
    y_mesh(1:downsampling_ratio:end,...
    1:downsampling_ratio:end, 1:downsampling_ratio:end), ...               
    Ez(1:downsampling_ratio:end, 1:downsampling_ratio:end,...              % plot electrical field's arrows with directional components
    1:downsampling_ratio:end), ...
    Ex(1:downsampling_ratio:end, 1:downsampling_ratio:end,...
    1:downsampling_ratio:end), ...
    Ey(1:downsampling_ratio:end, 1:downsampling_ratio:end,...
    1:downsampling_ratio:end));                                            
E_field_fig.Color = [0.7, 0.7, 0.7];                                       % color of electrical field.
E_field_fig.DisplayName = "electrical field";                                       % legend for electrical field.
hold on;

%% get the trajactory of released particle
trajectory = zeros(t_max, length(X0));                                     % create trajectory array
trajectory(1,:) = X0;                                                      % initial trajectory
for i = 2:t_max + 1
    E_partical = [...                                                      % get electrical field applied on partical.
        interp3(z_mesh, x_mesh, y_mesh, Ez,...                             % get electrical field along z-axis applied on partical.
            trajectory(i-1, 1), trajectory(i-1, 2), trajectory(i-1, 3)),...
        interp3(z_mesh, x_mesh,y_mesh, Ex,...                              % get electrical field along x-axis applied on partical.
            trajectory(i-1, 1), trajectory(i-1, 2),trajectory(i-1, 3)),...
        interp3(z_mesh, x_mesh,y_mesh,  Ey, ...                            % get electrical field along y-axis applied on partical.
            trajectory(i-1, 1), trajectory(i-1, 2), trajectory(i-1, 3))];               
    trajectory(i,:) = ...                                                  % get the next state of electron: [z-velocity, x-velocity, y-velocity, z-acceleration, x-acceleration, y-acceleration].
        electron(trajectory(i-1,:), E_partical, delta_t, q, m);            
    if trajectory(i,1) < 0 ||...                                           % judge whether the particle is over boundary
            trajectory(i,1) > space_size(1) || ...
            trajectory(i,2) < - space_size(2) / 2 ||...
            trajectory(i,2) > space_size(2) / 2 ||...
            trajectory(i,3) > space_size(3)  ||...
            trajectory(i,3) < - space_size(3) / 2 
        break;
    end
        
end
trajectory = trajectory(1:i,:);                                            % drop zeros 

%% plot the trajectory of particle 
traj_fig = quiver3(trajectory(1:i-1,1), ...                                % plot the trajactory of electron
    trajectory(1:i-1,2), ...
    trajectory(1:i-1,3), ...
    trajectory(2:i,1) - trajectory(1:i-1,1), ...
    trajectory(2:i,2) - trajectory(1:i-1,2),...
    trajectory(2:i,3) - trajectory(1:i-1,3));  
traj_fig.LineWidth = 1;
traj_fig.Color = 'g';
traj_fig.AutoScale = 'off';
traj_fig.DisplayName = "particle trajectory";

%% plot settings
xlim([0 space_size(1)]);                                                   
xlabel('z-axis');                                                  
ylabel('x-axis');
zlabel('y-axis');
title('Electron beam system');
legend;
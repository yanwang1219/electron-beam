function [E_z,E_x,E_y] = electrical_distribution(Z, X, Y, L_z, L_x, L_y, z0, x0, y0, n_z, n_y, n_x, q)
% creates E distribution generated from one plate in the whole space
% Inputs:
%   Z:  z_mesh.
%   X:  x_mesh.
%   Y:  y-mesh.
%   L_z:  length of one platte of capacitor along z-axis.
%   L_x:  length of one platte of capacitor along x-axis.
%   L_y:  length of one platte of capacitor along y-axis.
%   z0: the center position of one platte along z-axis.
%   x0: the center position of one platte along x-aixs.
%   y0: the center position of one platte along y-aixs.
%   n_z: the number of electron on each plate along z-axis.
%   n_y: the number of electron on each plate along y-axis.
%   n_x: the number of electron on each plate along x-axis.
%   q:  charge of one electron on the plate.
% Outputs:
%   E_z: whole electrical field in the whole space along z-axis.
%   E_x: whole electrical field in the whole space along x-axis.
%   E_y: whole electrical field in the whole space along y-axis.

    E_z = zeros(size(Z));                                                  % initial E_z array as 0.
    E_x = zeros(size(X));                                                  % initial E_x array as 0.
    E_y = zeros(size(Y));                                                  % initial E_x array as 0.
    for i = 1:n_z                                                          % iterate the electrons along z-axis on the plate
        for n = 1: n_y                                                     % iterate the electrons along y-axis on the plate
            for v = 1: n_x                                                 % iterate the electrons along x-axis on the plate
                [e_z, e_x, e_y] = single_electrical_field(...
                    q, (i-1)/(n_z-1+10e-8)*L_z + z0 - L_z/2, ....
                    (v-1)/(n_x-1+10e-8)*L_x + x0 - L_x/2, ...
                    (n-1)/(n_y-1+10e-8)*L_y + y0 - L_y/2,...
                    Z, X, Y); 
                E_z = E_z + e_z;                                           % add all electrical field at one point along z-axis 
                E_x = E_x + e_x;                                           % add all electrical field at one point along x-axis 
                E_y = E_y + e_y;                                           % add all electrical field at one point along y-axis
                
            end
        end
    end
%% plot plate    
    color = "red";                                                         % color for plate
    if q < 0                                                               % black for plate with negative charge
        color = "black";
    end
    if L_x == 0                                                            % plot plate in x-selector                                                      
        X = [x0, x0, x0, x0];                                              % coordinates of four vertices along X-axis
        Y = [y0 - L_y/2, y0 - L_y / 2, y0 + L_y/2, y0 + L_y / 2];          % coordinates of four vertices along Y-axis
        Z = [z0 - L_z/2, z0 + L_z / 2, z0 + L_z/2, z0 - L_z / 2];          % coordinates of four vertices along Z-axis
        fill3(Z, X, Y,color, 'HandleVisibility','off');
    elseif L_y == 0                                                        % plot plate in y-selector
        Y= [y0, y0, y0, y0];                                               % coordinates of four vertices along X-axis
        X = [x0 - L_x/2, x0 - L_x / 2, x0 + L_x/2, x0 + L_x / 2];          % coordinates of four vertices along Y-axis
        Z = [z0 - L_z/2, z0 + L_z / 2, z0 + L_z/2, z0 - L_z / 2];          % coordinates of four vertices along Z-axis
        fill3(Z, X, Y,color, 'HandleVisibility','off');
    end
    hold on;
end
   
    
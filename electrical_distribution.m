function [E_z,E_x,E_y] = electrical_distribution(Z, X, Y, L_z,L_x,L_y, z0, x0, y0, n_z, n_y ,n_x, q)
% creates E distribution generates from one plate in the whole space
% Inputs:
%   Z:  z_mesh.
%   X:  x_mesh.
%   L:  length of one platte of capacitor.
%   z0: the center position of one platte along z-axis.
%   x0: the center position of one platte along x-aixs.
%   n_z: the number of electron on each plate.
%   q:  charge of one electron on the plate.
% Outputs:
%   E_z: whole electrical strength in the whole space along z-axis.
%   E_x: whole electrical strength in the whole space along x-axis.

    E_z = zeros(size(Z));                                                  %initial E_z array as 0.
    E_x = zeros(size(X));                                                  %initial E_x array as 0.
    E_y = zeros(size(Y));   
    for i = 1:n_z
        for n = 1: n_y
            for v = 1: n_x
                [e_z, e_x, e_y] = single_electrical_field(...
                    q, (i-1)/(n_z-1+10e-8)*L_z + z0 - L_z/2, (v-1)/(n_x-1+10e-8)*L_x + x0 - L_x/2, (n-1)/(n_y-1+10e-8)*L_y + y0 - L_y/2, Z, X,Y); 
                E_z = E_z + e_z;                                                   % add all electrical field influence along z-axis at one point 
                E_x = E_x + e_x;                                                   % add all electrical field influence along x-axis at one point
                E_y = E_y + e_y;
                
            end
        end
    end
end

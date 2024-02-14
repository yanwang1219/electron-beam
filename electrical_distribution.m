function [E_z,E_x] = electrical_distribution(Z, X, L, z0, x0 ,n_q, q)
% creates E distribution generates from one plate in the whole space
% Inputs:
%   Z:  z_mesh.
%   X:  x_mesh.
%   L:  length of one platte of capacitor.
%   z0: the center position of one capacitor along z-axis.
%   x0: the center position of one capactitor along x-aixs.
%   n_q: the number of electron on each plate.
%   q:  charge of one electron on the plate.
% Outputs:
%   E_z: whole electrical strength in the whole space along z-axis.
%   E_x: whole electrical strength in the whole space along x-axis.

    E_z = zeros(size(Z));                                                  %initial E_z array as 0.
    E_x = zeros(size(X));                                                  %initial E_x array as 0.
    
    for i = 1:n_q
        [e_z, e_x] = single_electrical_field(...
            q, (i-1)/(n_q-1)*L + z0 - L/2, x0,Z, X); 
        E_z = E_z + e_z;                                                   % add all electrical field influence along z-axis at one point 
        E_x = E_x + e_x;                                                   % add all electrical field influence along x-axis at one point
    end
end

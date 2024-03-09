function [Ez, Ex, Ey] = x_selector(Z, X, Y, L, z0, y0 ,z1, y1, d, n_z, n_y, n_x, q)
%.m creates two pair plattes (capacitor), which generates electrical field in the space
%Inputs:
%   Z: z_mesh.
%   X: x_mesh.
%   L: plate_length.
%   z0: middle position of left pair plate.
%   z1: middle position of right pair plate.
%   d: distance bewteen one pair plates.
%   n_z: number of electrons on each plate. 
%   q: charge of one electron
%Outputs:
%   E_z:superimposed field strength along z-axis
%   E_x:superimposed field strength along x-axis
    [Ez1, Ex1, Ey1] = electrical_distribution(Z, X, Y, L,0,L,  z0, d/2 , y0, n_z, n_y,n_x, q);     % calculte the left above plate's electrical field strength distribution along z-axis and x-axis
    [Ez2, Ex2, Ey2] = electrical_distribution(Z, X, Y, L,0,L,  z0, -d/2, y0, n_z, n_y,n_x,-q);  % calculte the left bottom plate's electrical field strength distribution along z-axis and x-axis
    [Ez3, Ex3, Ey3] = electrical_distribution(Z, X, Y, L,0,L,  z1, d/2 , y1, n_z, n_y,n_x,-q);   % calculte the right above plate's electrical field strength distribution along z-axis and x-axis
    [Ez4, Ex4, Ey4] = electrical_distribution(Z, X, Y, L,0,L,  z1, -d/2, y1, n_z, n_y,n_x, q);   % calculte the right bottom plate's electrical field strength distribution along z-axis and x-axis

  

    Ez = Ez1 + Ez2 + Ez3 + Ez4;                                         % calculate 4 plates (2 capacitors)' electrical field strength distribution along z-axis
    Ex = Ex1 + Ex2 + Ex3 + Ex4;                                         % calculate 4 plates (2 capacitors)' electrical field strength distribution along x-axis
    Ey = Ey1 + Ey2 + Ey3 + Ey4; 
end

   




    
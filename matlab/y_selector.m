function [Ez, Ex, Ey] = y_selector(Z, X, Y, L, z0, x0, z1, x1, d, n_z,...
    n_y, n_x, q)
%  creates two pair plates --> y-selector
%Inputs:
%   Z, X, Y: x_mesh, z_mesh, y_mesh
%   L: plate_length.
%   z0: middle position along z-axis of left pair plates in x-selector.
%   x0: middle position along x-axis of left pair plates in x-selector.
%   z1: middle position along z-axis of right pair plates in x-selector.
%   x1: middle position along x-axis of right pair plates in x-selector.
%   d: distance bewteen one pair plates.
%   n_z: number of electrons on each plate along z-axis. 
%   n_y: number of electrons on each plate along y-axis.
%   n_x: number of electrons on each plate along x-axis.
%   q: charge of one electron
%Outputs:
%   E_z:superimposed field along z-axis
%   E_x:superimposed field along x-axis
%   E_y:superimposed field along y-axis

    [Ez1, Ex1, Ey1] = electrical_distribution(Z, X, Y, L, L, 0, z0, x0,...
        d/2, n_z, n_y, n_x, q);                                            % calculate the left front plate's electrical field distribution 
    [Ez2, Ex2, Ey2] = electrical_distribution(Z, X, Y, L, L, 0, z0, x0,...
        -d/2, n_z, n_y, n_x, -q);                                           % calculate the left hinter plate's electrical field distribution
    [Ez3, Ex3, Ey3] = electrical_distribution(Z, X, Y, L, L, 0, z1, x1,...
        d/2, n_z, n_y, n_x, -q);                                            % calculate the right front plate's electrical field distribution
    [Ez4, Ex4, Ey4] = electrical_distribution(Z, X, Y, L, L, 0, z1, x1,...
        -d/2, n_z, n_y, n_x, q);                                           % calculate the right hinter plate's electrical field distribution

    Ez = Ez1 + Ez2 + Ez3 + Ez4;                                            % calculate 4 plates (2 capacitors)' electrical field distribution along z-axis
    Ex = Ex1 + Ex2 + Ex3 + Ex4;                                            % calculate 4 plates (2 capacitors)' electrical field distribution along x-axis
    Ey = Ey1 + Ey2 + Ey3 + Ey4;                                            % calculate 4 plates (2 capacitors)' electrical field distribution along y-axis
   
end
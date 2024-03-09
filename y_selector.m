function [Ez, Ex, Ey] = y_selector(Z, X, Y, L, z0,x0, z1, x1, d, n_z, n_y, n_x, q)

    [Ez1, Ex1, Ey1] = electrical_distribution(Z, X, Y, L,L,0, z0, x0 , d/2, n_z, n_y, n_x, q);     % calculte the left front plate's electrical field strength distribution along z-axis and x-axis
    [Ez2, Ex2, Ey2] = electrical_distribution(Z, X, Y, L,L,0, z0, x0, -d/2, n_z, n_y, n_x,-q);  % calculte the left hinter plate's electrical field strength distribution along z-axis and x-axis
    [Ez3, Ex3, Ey3] = electrical_distribution(Z, X, Y, L,L,0,z1, x1 ,d/2, n_z, n_y, n_x,-q);   % calculte the right front above plate's electrical field strength distribution along z-axis and x-axis
    [Ez4, Ex4, Ey4] = electrical_distribution(Z, X, Y, L,L,0, z1, x1, -d/2, n_z, n_y, n_x, q);   % calculte the right hinter plate's electrical field strength distribution along z-axis and x-axis

    Ez = Ez1 + Ez2 + Ez3 + Ez4;                                         % calculate 4 plates (2 capacitors)' electrical field strength distribution along z-axis
    Ex = Ex1 + Ex2 + Ex3 + Ex4;                                         % calculate 4 plates (2 capacitors)' electrical field strength distribution along x-axis
    Ey = Ey1 + Ey2 + Ey3 + Ey4; 
   
end
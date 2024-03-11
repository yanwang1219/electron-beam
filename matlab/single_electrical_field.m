function [e_z,e_x,e_y] = single_electrical_field(q,z_0, x_0 ,y_0,z,x,y)
% Calculates the electrical field created from one single electron in the

% Inputs:
%   q: charge of one electron
%   z_0: position of one electron along z axis
%   x_0: position of one electron along x axis
%   y_0: position of one electron along y axis
% Outputs:
%   e_z: one electron generates E in the space along the z-axis
%   e_x: one electron generates E in the space along the x-axis
%   e_y: one electron generates E in the space along the y-axis
    
    const = (x-x_0).^2 +(z-z_0).^2 + (y-y_0).^2;                           %   constant value for 3-D calculation                          
    %const =((x-x_0).^2 + (z-z_0).^2).^1.5+10e-8;                          %   constant value for 2-D calculation                                       
    e_z = q *(z-z_0)./const;                                               %   z, x, y are all matrix
    e_x = q *(x-x_0)./const;
    e_y = q *(y-y_0)./const;
    
end
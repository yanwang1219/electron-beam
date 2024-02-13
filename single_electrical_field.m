function [e_z,e_x] = single_electrical_field(q,z_0, x_0,z,x)
%.m show the influence of one electron on the plate to the space enviornment
%Inputs:
%   q: charge of one electron
%   z_0: position of one electron along z axis
%   x_0: position of one electron along x axis
%Outputs:
%   e_z: one electron generates E in the space along the z-axis
%   e_x: one electron generates E in the space along the x-axis


    const =((x-x_0).^2 + (z-z_0).^2).^1.5+10e-8;
    e_z = q*(z-z_0)./const;
    e_x = q*(x-x_0)./const;   % (z,x) is matrix
end
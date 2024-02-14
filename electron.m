function [X_next] = electron(X, E, delta_t,q,m)
% Calculates the position / velocity of a single electron point in the next 
% time step.
%
% Inputs:
%   X: State-space representation of a single moving electron particle.
%   E: electrical field at the electron's position.
%   delta_t: duaration time between current state and next state.
%   q: Electrical amplitude of each electron.
%   m: the mass of electron.
% Outputs:
%   X_next: next state of electron. [z, x, z_dot, x_dot]

    A = [[1, 0, delta_t, 0];[0, 1, 0, delta_t];[0, 0, 1, 0];[0, 0, 0, 1]];
    B = [[0,0]; [0,0]; [q/m*delta_t, 0]; [0, q/m*delta_t]];
    X_next = A*X' + B*E';                                                  % calculate next state according to space state equations
end
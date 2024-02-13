function [X_next] = electron(X, E, delta_t,q,m)
    A = [[1, 0, delta_t, 0];[0, 1, 0, delta_t];[0, 0, 1, 0];[0, 0, 0, 1]];
    B = [[0,0]; [0,0]; [q/m*delta_t, 0]; [0, q/m*delta_t]];
    X_next = A*X' + B*E';
end
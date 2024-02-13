function [Ez, Ex] = x_selector(Z, X, L, z0, z1, d, n_q, q)
    [Ez1, Ex1] = electrical_distribution(Z, X, L, z0, d/2 ,n_q, q);
    [Ez2, Ex2] = electrical_distribution(Z, X, L, z0, -d/2 , n_q, -q);
    [Ez3, Ex3] = electrical_distribution(Z, X, L, z1, d/2 , n_q, -q);
    [Ez4, Ex4] = electrical_distribution(Z, X, L, z1, -d/2 , n_q, q);
    Ez = Ez1 + Ez2 + Ez3 + Ez4;
    Ex = Ex1 + Ex2 + Ex3 + Ex4;
end

   




    
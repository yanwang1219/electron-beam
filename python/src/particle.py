import numpy as np


class Particle_trajectory:

    def __init__(
            self,
            particle_charge,
            particle_mass,
            delta_t,
    ):
        self.particle_charge = particle_charge
        self.particle_mass =  particle_mass
        self.delta_t = delta_t
        

    def particle_state(self, E_point, state):
        system_matrix = np.array([[1, 0, 0, self.delta_t, 0, 0],
                    [0, 1, 0, 0, self.delta_t, 0],
                    [0, 0, 1, 0, 0, self.delta_t],
                    [0, 0, 0, 1,0, 0],
                    [0, 0, 0, 0, 1, 0],
                    [0, 0, 0, 0, 0, 1]])
        input_matrix = np.array([[0, 0, 0], [0, 0, 0], [0, 0, 0], [self.particle_charge/self.particle_mass*self.delta_t, 0, 0],
            [0, self.particle_charge/self.particle_mass*self.delta_t, 0],[0, 0, self.particle_charge/self.particle_mass*self.delta_t]])
        state = system_matrix .dot(state) +  input_matrix.dot(E_point).T
        return state

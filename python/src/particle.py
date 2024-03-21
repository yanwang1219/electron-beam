import numpy as np


class Particle_trajectory:

    def __init__(
            self,
            particle_charge: int,
            particle_mass: int,
            delta_t: float, ##??
    ):
        """_summary_

        Args:
            particle_charge (int): charge of released particle
            particle_mass (int): mass of charged particle
            delta_t (float): simulation time step
        """
        self.particle_charge = particle_charge
        self.particle_mass =  particle_mass
        self.delta_t = delta_t
        

    
    def particle_state(self, E_point: np.ndarray, state: np.ndarray) -> np.ndarray:
        """ calculate the next state of a particle using the state equation

        Args:
            E_point (np.ndarray): electric field strength at the current position of the particle
            state (np.ndarray): An array representing the current state of the particle with coordinates and velocity

        Returns:
            np.ndarray: An array representing the next state of the particle, including updated coordinates and velocity

        """
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

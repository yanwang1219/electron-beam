from selector import Selector
import matplotlib.pyplot as plt
import numpy as np
from particle import Particle_trajectory
from mpl_toolkits.mplot3d import Axes3D
from scipy.interpolate import RegularGridInterpolator
from typing import List, Tuple


class Calculation:
    def __init__(self, space_size: List[int], ax: plt.Axes, t_max: int):

        """calculate field strength, position of particle

        Args:
            space_size (List[int]): size of space
            ax (plt.Axes): a 3D axes object obtained from fig.gca()
            t_max (int): maximum simulation time
        """
        self.space_size = space_size
        self.ax = ax
        self.t_max = t_max

    
    def e_field_total(
        self, number_electric: List[int], resolution: int
    ) -> Tuple[np.ndarray, np.ndarray, np.ndarray, np.ndarray, np.ndarray]:
        """total field strength generated from X-Selektor and Y-Selektor

        Args:
            number_electric (List[int]): number of electron along each axis of the selectors
            resolution (int): resolution of the space

        Returns:
            A tuple containing:
                - E_total (np.ndarray): An array representing the total electric field strength from the X-selector and Y-selector.
                - mesh_grid (np.ndarray): mesh grid along the X, Y, and Z axes of the space.
                - z (np.ndarray): coordinates along the Z-axis of the space.
                - y (np.ndarray): coordinates along the Y-axis of the space.
                - x (np.ndarray): coordinates along the X-axis of the space.
        """
        z = np.linspace(
            0, self.space_size[0], self.space_size[0] * resolution
        )  # entlang Z-axis gesamten Raum aufteilen
        y = np.linspace(
            -self.space_size[1] / 2,
            self.space_size[1] / 2,
            self.space_size[2] * resolution,
        )  # entlang Y-axis gesamten Raum aufteilen
        x = np.linspace(
            -self.space_size[2] / 2,
            self.space_size[2] / 2,
            self.space_size[2] * resolution,
        )  # entlang X-axis gesamten Raum aufteilen
        mesh_grid = np.meshgrid(
            z, y, x, indexing="ij"
        )  # generate mesh grid for the space
        selector = Selector(
            [8, 8, 8], number_electric, mesh_grid, self.ax
        )  # instance of Selector
        E_total = selector.x_selector(5.5, 0, 8, 14.5, 0) + selector.y_selector(
            23.5, 0, 8, 32.5, 0
        )  # gesamte elektrische Feldstärke von X-Selektor plus Y-Selektor
        return E_total, mesh_grid, z, y, x

    def plot_E_field_total(
        self, downsampling_ratio: int, E_total: np.ndarray, mesh_grid: Tuple[np.ndarray]
    ):
        """
            plot field strength generated in the whole space

        Args:
            downsampling_ratio (int): downsampling ratio for visualizing the electric field vectors
            E_total (np.ndarray):  the total electric field strength in space
            mesh_grid (Tuple[np.ndarray]): mesh grid of coordinates in the space.
        """
        ax = self.ax
        scale = 0.1
        ax.quiver(
            mesh_grid[0][
                ::downsampling_ratio, ::downsampling_ratio, ::downsampling_ratio
            ],
            mesh_grid[1][
                ::downsampling_ratio, ::downsampling_ratio, ::downsampling_ratio
            ],
            mesh_grid[2][
                ::downsampling_ratio, ::downsampling_ratio, ::downsampling_ratio
            ],
            E_total[0][::downsampling_ratio, ::downsampling_ratio, ::downsampling_ratio]
            * scale,
            E_total[1][::downsampling_ratio, ::downsampling_ratio, ::downsampling_ratio]
            * scale,
            E_total[2][::downsampling_ratio, ::downsampling_ratio, ::downsampling_ratio]
            * scale,
        )

    def calculation_particle(
        self,
        E_total: np.ndarray,
        z: np.ndarray,
        y: np.ndarray,
        x: np.ndarray,
        init_state: List[float],
    ) -> np.ndarray:
        """calculate the electric field strength at the current position of the electron

        Args:
            E_total (np.ndarray): the total electric field strength in space
            z (np.ndarray): coordinates along the Z-axis of the space.
            y (np.ndarray): coordinates along the Y-axis of the space.
            x (np.ndarray): coordinates along the X-axis of the space.
            init_state (List[float]): include initial position, velocity of particle along z,y,x-axis

        Returns:
            np.ndarray: return next state of position,velocity of particle
        """
        interp_z = RegularGridInterpolator(
            (z, y, x), E_total[0]
        )  # interpolate electric field strength at the current particle position along the Z-axis
        interp_y = RegularGridInterpolator(
            (z, y, x), E_total[1]
        )  # interpolate electric field strength at the current particle position along the Y-axis
        interp_x = RegularGridInterpolator(
            (z, y, x), E_total[2]
        )  # interpolate electric field strength at the current particle position along the X-axis
        trajectory = np.zeros((self.t_max, len(init_state)))  # initial trajectory
        trajectory[0, :] = init_state
        particle_trajectory = Particle_trajectory(
            10, 2, 0.01
        )  # instance of Particle_trajectory
        for i in range(self.t_max):  # judge whether out of th boundary of plate
            if (
                trajectory[i, 0] < 0
                or trajectory[i, 0] > self.space_size[0]
                or trajectory[i, 1] < -self.space_size[1] / 2
                or trajectory[i, 1] > self.space_size[1] / 2
                or trajectory[i, 2] < -self.space_size[2] / 2
                or trajectory[i, 2] > self.space_size[2] / 2
            ):
                trajectory = trajectory[0:i, :]
                break
            pos = trajectory[i, :3]  # current positions of particle
            E_at_particle = np.array(
                [interp_z(pos), interp_y(pos), interp_x(pos)]
            )  # current field strength at particle's position
            trajectory[i + 1, :] = particle_trajectory.particle_state(
                E_at_particle, trajectory[i, :]
            )
        return trajectory

    def plot_particle_trajectory(self, trajectory: np.ndarray):
        """plot particle trajectory

        Args:
            trajectory (np.ndarray): trajectory of particle at each step
        """
        plt.quiver(
            trajectory[:-2, 0],
            trajectory[:-2, 1],
            trajectory[:-2, 2],
            trajectory[1:-1, 0] - trajectory[:-2, 0],
            trajectory[1:-1, 1] - trajectory[:-2, 1],
            trajectory[1:-1, 2] - trajectory[:-2, 2],
        )


if __name__ == "__main__":
    fig = plt.figure()
    ax = fig.gca(projection="3d")
    ax.set_xlabel("z-axis")
    ax.set_ylabel("x-axis")
    ax.set_zlabel("y-axis")
    ax.set_zlim(-6, 6)
    ax.set_xlim(0, 40)
    ax.set_ylim(-6, 6)
    ax.autoscale(True)
    result = Calculation([40, 10, 10], ax, 10000)  # instance of Calculation
    E_total, mesh_grid, z, y, x = result.e_field_total([5, 5, 5], 4)
    result.plot_E_field_total(7, E_total, mesh_grid)
    trajectory = result.calculation_particle(E_total, z, y, x, [0., -1., -1., 15., 0., 0.])
    result.plot_particle_trajectory(trajectory)
    plt.show()

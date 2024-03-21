import numpy as np
from typing import List 
import copy
from mpl_toolkits.mplot3d import Axes3D
from mpl_toolkits.mplot3d.art3d import Poly3DCollection
import matplotlib.pyplot as plt
from functools import reduce

class Selector:
    def __init__(
            self,
            length:List[int],
            electric_number:List[int],
            mesh_grid: List[np.ndarray], ##??why list
            ax: plt.Axes
            ):
        """calculate field strength

        Args:
            length (List[int]): length of platte along z, y, x axis
            electric_number (List[int]): electric number of platte along z, y, x axis
            mesh_grid (List[np.ndarray]): NumPy arrays generated by np.meshgrid(), dividing the entire space along the Z, Y, and X axes.
            ax (plt.Axes): 3D axes object obtained from fig.gca() 
        """
        
        self.length = length
        self.electric_number = electric_number
        self.charge = 1
        self.mesh_grid = np.array(mesh_grid)
        self.ax = ax


    def calculate_single_E_field(self, single_electric_position: List[int], charge: int) -> np.ndarray:
        """elektrische Feldstärke von jedem Elektron auf der Platte erzeugt

        Args:
            single_electric_position (List[int]): position of single electron
            charge (int): charge of each electron

        Returns:
            np.ndarray: an array representing the electric field strength generated by each electron
        """
        const = (single_electric_position[0] - self.mesh_grid[0])**2 + (single_electric_position[1] - self.mesh_grid[1])**2 + (single_electric_position[2] - self.mesh_grid[2])**2  
        e_z = charge *(self.mesh_grid[0] - single_electric_position[0]) / const
        e_y = charge *(self.mesh_grid[1] - single_electric_position[1]) / const
        e_x = charge *(self.mesh_grid[2] - single_electric_position[2]) / const
        return np.array((e_z, e_y, e_x)) ##??tuble
    
    
    def plate_E_field(self, center_point: List[float], charge: int, electric_number: List[int], length: List[int]) -> np.ndarray: 
        """ elektrische Feldstärke von der gesamten Platte erzeugt 

        Args:
            ##??center_point ( List[float]): coordinates of the center point of plate
            charge (int): the charge of each electron
            electric_number (List[int]): number of electrons along each axis of the plate
            length (List[int]): length of the plate along each axis

        Returns:
            np.ndarray: an array representing the total electric field generated by all electrons on the plate.
        """
        z = np.linspace(center_point[0]-length[0]/2, length[0], electric_number[0])  # generate coordinates along Z-axis for distributing electrons on the plate
        y = np.linspace(center_point[1]-length[1]/2, length[1], electric_number[1])
        x = np.linspace(center_point[2]-length[2]/2, length[2], electric_number[2])
        total = np.meshgrid(z,y,x) # generate mesh grid for distributing electrons on the plate
        positions = np.array((total[0].flatten(),total[1].flatten(),total[2].flatten())).T.tolist() # flatten the mesh grid coordinates
        positions[0] = self.calculate_single_E_field(positions[0],charge)  
        E = reduce(lambda E_sum, pos: E_sum + self.calculate_single_E_field(pos, charge), positions) # electric field generated by all electrons on the plate


        color = "red"    #Farbe der Platte
        if charge < 0:
            color = "black"

        X = [center_point[2] + length[2]/2, center_point[2] + length[2]/2, center_point[2] - length[2]/2,center_point[2] -length[2]/2]  #vier Ecken der Platte basierend auf Mittelposition berechnen
        Y = [center_point[1] + length[1]/2, center_point[1] + length[1]/2, center_point[1] - length[1]/2, center_point[1] - length[1]/2]
        Z = [center_point[0] - length[0]/2, center_point[0] + length[0]/2, center_point[0] + length[0]/2, center_point[0] - length[0]/2]
        verts = [list(zip(Z,Y,X))] # zip vertices of the plate
        self.ax.add_collection3d(Poly3DCollection(verts, facecolors=color))  # to 3D plot
        return E # return the total electric field generated by all electrons on the plate
    

    
    def x_selector (self, z0: int, y0: int, distance: int, z1: int, y1: int)->np.ndarray:
        """ elektrische Feldstärke von X-Selector

        Args:
            z0 (int): z-coordinate of the center point of left plate in the X-Selector
            y0 (int): y-coordinate of the center point of left plate in the X-Selector
            distance (int): distance between one pair plate
            z1 (int): z-coordinate of the center point of right plate in the X-Selector
            y1 (int): z-coordinate of the center point of right plate in the X-Selector

        Returns:
            np.ndarray: an array representing the total electric field generated by X-selector.
        """
 
        length = copy.deepcopy(self.length)
        length[2] = 0   # when length_x = 0 -->x_selector
        electric_number = copy.deepcopy(self.electric_number)
        electric_number[2] = 1 # in x-selector we only have 1 electron in x direction.
        E = self.plate_E_field([z0, y0, distance/2], self.charge,electric_number, length) \
            + self.plate_E_field([z0, y0, -distance/2], -self.charge,electric_number, length) \
            + self.plate_E_field([z1, y1, distance/2],-self.charge,electric_number, length) \
            + self.plate_E_field([z1, y1, -distance/2],self.charge,electric_number, length) 
        return E


    
    def y_selector (self, z0: int, x0: int, distance: int, z1: int, x1: int)->np.ndarray:
        """ elektrische Feldstärke von Y-Selector
        Args:
            z0 (int): z-coordinate of the center point of left plate in the Y-Selector
            x0 (int): x-coordinate of the center point of left plate in the Y-Selector
            distance (int): distance between one pair plate
            z1 (int): z-coordinate of the center point of right plate in the Y-Selector
            x1 (int): x-coordinate of the center point of right plate in the Y-Selector

        Returns:
            np.ndarray: an array representing the total electric field generated by Y-selector
        """
        length = copy.deepcopy(self.length)
        length[1] = 0  # when length_y = 0 --> y_selector
        electric_number = copy.deepcopy(self.electric_number)
        electric_number[1] = 1 # in x selector we only have 1 electron in y direction.
        E = self.plate_E_field([z0, distance/2, x0],self.charge,electric_number, length) \
          + self.plate_E_field([z0, -distance/2, x0],-self.charge,electric_number, length) \
          + self.plate_E_field([z1, distance/2, x1],-self.charge,electric_number, length) \
          + self.plate_E_field([z1, -distance/2, x1],self.charge,electric_number, length) 
        return E
        

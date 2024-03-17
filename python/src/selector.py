import numpy as np
from typing import List 
import copy
from mpl_toolkits.mplot3d import Axes3D
from mpl_toolkits.mplot3d.art3d import Poly3DCollection
import matplotlib.pyplot as plt

class Selector:
    def __init__(
            self,
            length:list,
            electric_number:list,
            mesh_grid: List[np.ndarray],
            ax
            ):
        
        self.length = length
        self.electric_number = electric_number
        self.charge = 1
        self.mesh_grid = mesh_grid
        self.ax = ax
        
    def calculate_single_E_field(self, single_electric_position: list,charge):
        #self.ax.scatter(*single_electric_position, c=color)
        const = (single_electric_position[0] - self.mesh_grid[0])**2 +(single_electric_position[1] - self.mesh_grid[1])**2 + (single_electric_position[2] - self.mesh_grid[2])**2  
        e_z = charge *(self.mesh_grid[0] - single_electric_position[0]) / const
        e_y = charge *(self.mesh_grid[1] - single_electric_position[1]) /const
        e_x = charge *(self.mesh_grid[2] - single_electric_position[2]) /const
        return e_z, e_y, e_x
    

    def plate_E_field(self, center_point: list, charge, electric_number, length):
        E_z = np.zeros(self.mesh_grid[0].shape)
        E_y = np.zeros(self.mesh_grid[1].shape)
        E_x = np.zeros(self.mesh_grid[2].shape)
        
        for i in range(electric_number[0]):        #z,y,x
            for n in range(electric_number[1]):
                for v in range(electric_number[2]):
                    single_electric_position = [
                        i/(electric_number[0]+10e-8)*length[0] + center_point[0]-length[0]/2,
                        n/(electric_number[1]+10e-8)*length[1] + center_point[1]-length[1]/2,
                        v/(electric_number[2]+10e-8)*length[2] + center_point[2]-length[2]/2,
                    ] 
                    e_z, e_y, e_x = self.calculate_single_E_field(single_electric_position,charge) 
                    E_z = E_z + e_z
                    E_y = E_y + e_y
                    E_x = E_x + e_x    
        color = "red"
        if charge < 0:
            color = "black"
       
        # if  electric_number[2] == 1: #x-selector
        X = [center_point[2] + length[2]/2, center_point[2] + length[2]/2, center_point[2] -length[2]/2,center_point[2] -length[2]/2]
        Y = [center_point[1] + length[1]/2, center_point[1] + length[1]/2, center_point[1] - length[1]/2, center_point[1] - length[1]/2]
        Z = [center_point[0] - length[0]/2, center_point[0] + length[0]/2,center_point[0] + length[0]/2, center_point[0] - length[0]/2]
        verts = [list(zip(Z,Y,X))]
        self.ax.add_collection3d(Poly3DCollection(verts ,facecolors=color))
        
        return np.array([E_z, E_y, E_x])
    
    def x_selector (self, z0, y0, distance, z1, y1):
        length = copy.deepcopy(self.length)
        length[2] = 0
        electric_number = copy.deepcopy(self.electric_number)
        electric_number[2] = 1 # in x selector we only have 1 electron in x direction.
        E = self.plate_E_field([z0, y0, distance/2], self.charge,electric_number, length) \
            + self.plate_E_field([z0, y0, -distance/2], -self.charge,electric_number, length) \
            + self.plate_E_field([z1, y1, distance/2],-self.charge,electric_number, length) \
            + self.plate_E_field([z1, y1, -distance/2],self.charge,electric_number, length) 
        return E

    def y_selector (self, z0, x0, distance, z1, x1):
        length = copy.deepcopy(self.length)
        length[1] = 0
        electric_number = copy.deepcopy(self.electric_number)

        electric_number[1] = 1 # in x selector we only have 1 electron in y direction.
        E = self.plate_E_field([z0, distance/2, x0],self.charge,electric_number, length) \
          + self.plate_E_field([z0, -distance/2, x0],-self.charge,electric_number, length) \
          + self.plate_E_field([z1, distance/2, x1],-self.charge,electric_number, length) \
          + self.plate_E_field([z1, -distance/2, x1],self.charge,electric_number, length) 
        #print(z0,x0)
        return E
        
